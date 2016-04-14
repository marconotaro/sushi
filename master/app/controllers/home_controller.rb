class HomeController < ApplicationController
  def index
    view_context.project_init
    @fgcz = SushiFabric::Application.config.fgcz?
  end
  def gstore
    # path
    @base = '/projects'
    @path = params[:project_id]
    @path = File.join(@path, params[:dirs]) if params[:dirs]
    parent = @path.split('/')
    parent.pop
    @parent = parent.join('/')
    @parent = params[:project_id] if @parent.empty?
    @sort = params[:format] if params[:format]
    @files = Dir[File.join(SushiFabric::GSTORE_DIR, @path)+"/*"]
    @total = @files.length

    # pager
    @page_unit = if page = params[:page] and unit = page[:unit] 
                   session[:gstore_page_unit] = unit.to_i
                 elsif unit = session[:gstore_page_unit]
                   unit.to_i
                 else
                   session[:gstore_page_unit] = 10
                 end
    current_page, sort = params[:format].to_s.split(/:/)
    @current_page = (current_page||1).to_i
    @page_list = (1..(@files.length.to_f/@page_unit).ceil).to_a
    start = (@current_page - 1) * @page_unit
    last  = @current_page * @page_unit - 1

    # sort
    if sort
      session[:gstore_reverse] = !session[:gstore_reverse]
      case sort
      when 'Name'
        @files.sort_by! {|file| File.basename(file)}
      when 'Last_Modified'
        @files.sort_by! {|file| File.mtime(file)}
      when 'Size'
        @files.sort_by! {|file| File.size(file)}
      end
      @files.reverse! if session[:gstore_reverse]
    else
      session[:gstore_reverse] = nil
      if @path == params[:project_id] 
        @files.sort_by! {|file| File.mtime(file)}
        @files.reverse!
      end
    end
    @files = @files[start..last]
    @fgcz = SushiFabric::Application.config.fgcz?
    if @fgcz and !@files
      redirect_to "http://fgcz-gstore.uzh.ch/projects/#{@path}.#{params[:format]}"
    end
  end
  def sushi_rank
    count_name = {}
    first_date = []
    this_month = Time.now.to_s.split.first.split(/-/)[0,2].join('-')
    monthly_mvp = {}
    @count_month = {}
    job_list = @@workflow_manager.job_list(false, nil)
    job_list.split(/\n/).each do |line|
      # e.g. "564201,fail,QC_sample_dataset.sh,2013-07-12 17:38:21,masaomi,1001\n"
      id, stat, script, date, name, project = line.chomp.split(/,/)
      count_name[name]||=0
      count_name[name]+=1
      date = date.split.first.split(/-/)[0,2].join('-')
      if date == this_month
        monthly_mvp[name]||=0
        monthly_mvp[name]+=1
      end
      @count_month[date]||=0
      @count_month[date]+=1
      first_date << date
    end
    @count_month = @count_month.to_a.sort
    @rank = count_name.sort_by{|name, count| count}.reverse
    @monthly_mvp = monthly_mvp
    @mvp = monthly_mvp.sort_by{|name, count| count}.reverse.first.first
    @first_date = first_date.sort.first.split.first
  end
end
