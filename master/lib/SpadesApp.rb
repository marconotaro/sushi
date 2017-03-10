#!/usr/bin/env ruby
# encoding: utf-8
Version = '20170310'

require 'sushi_fabric'
require_relative 'global_variables'
include GlobalVariables

class SpadesApp < SushiFabric::SushiApp
  def initialize
    super
    @name = 'Spades'
    @analysis_category = 'Assemble'
    @description =<<-EOS
SPAdes genome assembler
<a href='http://cab.spbu.ru/software/spades/'>http://cab.spbu.ru/software/spades/</a>
EOS
    
    @required_columns = ['Name','Read1']
    # optional params
    @params['cores'] = '8'
    @params['ram'] = '50'
    @params['scratch'] = '100'
    @params['spadesBasicOpt'] = ''
    @params['spadesBasicOpt', 'description'] = 'SPAdes basic options: --sc --meta, --rna, --plasmid, Default is empty for genome assembly without MDA' 
    @params['spadesPipeOpt'] = '--careful'
    @params['spadesPipeOpt', 'description'] = 'SPAdes pipeline options: --only-assembler, --careful'
    @params['cmdOptions'] = ''
    @params['cmdOptions', 'description'] = 'specify other commandline options for SPAdes; do not specify any option that is already covered by the dedicated input fields'
    @params['trimAdapter'] = true
    @params['trimAdapter', 'description'] = 'if adapters should be trimmed'
    @params['trimLeft'] = 0
    @params['trimLeft', 'description'] = 'fixed trimming at the "left" i.e. 5-prime end of the read'
    @params['trimRight'] = 0
    @params['trimRight', 'description'] = 'fixed trimming at the "right" i.e. 3-prime end of the read'
    @params['minTailQuality'] = 20
    @params['minTailQuality', 'description'] = 'if above zero, then reads are trimmed as soon as 4 consecutive bases have lower mean quality'
    @params['minAvgQuality'] = 20
    @params['minReadLength'] = 50
    @params['specialOptions'] = ''
    @params['specialOptions', 'description'] = 'special unsupported options that the R wrapper may support, format: <key>=<value>'
    @params['mail'] = ""
  end
  def preprocess
    if @params['paired']
      @required_columns << 'Read2'
    end
  end
  def next_dataset
    {'Name'=>@dataset['Name'], 
     'Fasta [File]'=>File.join(@result_dir, "#{@dataset['Name']}.fasta"),
     'SpadesLog [File]'=>File.join(@result_dir, "#{@dataset['Name']}_spades.log"),
     'TrimmomaticLog [File]'=>File.join(@result_dir, "#{@dataset['Name']}_preprocessing.log"),
     'Species'=>@dataset['Species'],
     'Read Count'=>@dataset['Read Count'],
    }.merge(extract_column("Factor")).merge(extract_column("B-Fabric"))
  end
  def commands
    run_RApp("EzAppSpades")
  end
end

if __FILE__ == $0
  run SpadesApp
  #usecase = Bowtie2App.new

  #usecase.project = "p1001"
  #usecase.user = 'masamasa'

  # set user parameter
  # for GUI sushi
  #usecase.params['process_mode'].value = 'SAMPLE'
  #usecase.params['refBuild'] = 'mm10'
  #usecase.params['paired'] = true
  #usecase.params['strandMode'] = 'both'
  #usecase.params['cores'] = 8
  #usecase.params['node'] = 'fgcz-c-048'

  # also possible to load a parameterset csv file
  # mainly for CUI sushi
  #usecase.parameterset_tsv_file = 'tophat_parameterset.tsv'
  #usecase.parameterset_tsv_file = 'test.tsv'

  # set input dataset
  # mainly for CUI sushi
  #usecase.dataset_tsv_file = 'tophat_dataset.tsv'

  # also possible to load a input dataset from Sushi DB
  #usecase.dataset_sushi_id = 3

  # run (submit to workflow_manager)
  #usecase.run
  #usecase.test_run

end

