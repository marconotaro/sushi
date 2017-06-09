module ApplicationHelper
  def linebreak_to_br(text)
    text.gsub(/\r\n|\r|\n/, "<br />")
  end
  def project_init
    if !session[:projects] or params[:select_project]
      @fgcz = SushiFabric::Application.config.fgcz?
      session[:employee] = (@fgcz and current_user and FGCZ.get_user_groups(current_user.login).include?('Employees'))
      session[:projects] = if @fgcz and current_user
                             FGCZ.get_user_projects(current_user.login).map{|project| project.gsub(/p/,'').to_i}.sort
                           else
                             [1001]
                           end
      session[:project] = if @fgcz and current_user
                            if project=params[:select_project] and number=project[:number] and number.to_i!=0 or
                               project=params[:project] and number=project[:number] and number.to_i!=0 and 
                               (session[:employee] or session[:projects].include?(number.to_i))
                              current_user.selected_project = number
                              current_user.save
                              number.to_i
                            elsif project_id = params[:project_id]
                              number = project_id.gsub(/p/,'')
                              current_user.selected_project = number
                              current_user.save
                              number.to_i
                            elsif current_user.selected_project != -1
                              current_user.selected_project
                            else
                              session[:projects].first
                            end
                          else
                            if project=params[:select_project] and number=project[:number] and number.to_i!=0 or
                               project=params[:project] and number=project[:number] and number.to_i!=0 and 
                               session[:projects].include?(number.to_i)
                               number.to_i
                            elsif session[:project]
                               session[:project]
                            else
                               session[:projects].first
                            end
                          end
      if @fgcz and current_user and current_user.selected_project == -1
        current_user.selected_project = session[:project]
        current_user.save
      end
    end
  end
  def td(str)
    if str.to_s.length > 16
      str="<span title='"+str+"'>"+str.to_s.split(//)[0,16].join+"...</span>"
    end
    str.to_s.html_safe
  end
end
