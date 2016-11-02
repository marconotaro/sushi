#!/usr/bin/env ruby
# encoding: utf-8

require 'sushi_fabric'
require_relative 'global_variables'
include GlobalVariables

class GatkJoinGenoTypesApp <  SushiFabric::SushiApp
  def initialize
    super
    @name = 'GATK JoinGenotypes'
    @params['process_mode'] = 'DATASET'
    @analysis_category = 'Variants'
    @description =<<-EOS
genotype,merge and annotate gvcf-Files<br/>
    EOS
    @required_columns = ['Name','GVCF','GVCFINDEX','Species','refBuild','grouping']
    @required_params = ['name']
    @params['cores'] = '8'
    @params['ram'] = '50'
    @params['scratch'] = '100'
    @params['name'] = 'GATK_Genotyping'
    @params['refBuild'] = ref_selector
    @params['grouping'] = ''
    @params['specialOptions'] = ''
    @params['mail'] = ""
  end
  def next_dataset
    report_dir = File.join(@result_dir, @params['name'])
    {'Name'=>@params['name'],
     'Report [File]'=>report_dir,
q#     'Html [Link]'=>File.join(report_dir, '00index.html'),
     'Species'=>@dataset['Species'],
     'refBuild'=>@params['refBuild'] 
    }
  end
  def set_default_parameters
    @params['refBuild'] = @dataset[0]['refBuild']
  end

  def commands
   run_RApp("EzAppJoinGenoTypes")
  end
      end
      
