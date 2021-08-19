#!/usr/bin/env ruby
# encoding: utf-8

require 'sushi_fabric'
require_relative 'global_variables'
include GlobalVariables


class SpatialSeuratSlidesApp < SushiFabric::SushiApp
  def initialize
    super
    @name = 'SpatialSeuratSlides'
    @params['process_mode'] = 'DATASET'
    @analysis_category = 'SingleCell'
    @description =<<-EOS
    Combine multiple slides from Visium/plates<br/>
    EOS
    @required_columns = ['Name', 'Species', 'refBuild', 'refFeatureFile', 'Static Report']
    @required_params = []
    # optional params
    @params['cores'] = '4'
    @params['ram'] = '30'
    @params['scratch'] = '50'
    @params['node'] = ''
    @params['process_mode'] = 'DATASET'
    @params['name'] = 'SpatialSeuratSlides'
    @params['refBuild'] = ref_selector
    @params['refFeatureFile'] = 'genes.gtf'
    @params['pcGenes'] = ''
    @params['pcGenes', 'description'] = 'The genes used in supvervised clustering'
    @params['npcs'] = '30'
    @params['npcs', 'description'] = 'Number of principal components to use for dimensionality reduction. Do not use more pcs than pcGenes (when used).'
    @params['resolution'] = '0.6'
    @params['resolution', 'description'] = 'Value between 0 and 1. A higher value will lead to larger communities.'
    @params['SCT.regress'] = ['none', 'CellCycle']
    @params['SCT.regress', 'description'] = "Variable to regress when processing the counts with the SCTransform method."
    @params['DE.method'] = ['wilcox', 'LR']
    @params['DE.method', 'description'] = "Method to be used when calculating gene cluster markers and differentially expressed genes between conditions."
    @params['DE.regress'] = ['Batch', 'CellCycle']
    @params['DE.regress','multi_selection'] = true
    @params['DE.regress', 'description'] = "Variables to regress when calculating gene cluster markers and differentially expressed genes. Only used with the LR method."
    @params['maxSamplesSupported'] = '5'
    @params['specialOptions'] = ''
    @params['mail'] = ""
    @params['Rversion'] = ["Dev/R/4.1.0", "Dev/R/4.0.4", "Dev/R/4.0.3"]
    @inherit_tags = ["Factor", "B-Fabric"]
  end
  def next_dataset
    report_file = File.join(@result_dir, @params['name'])
    report_link = File.join(report_file, '00index.html')
    {'Name'=>@params['name'],
     'Species'=>(dataset = @dataset.first and dataset['Species']),
     'Static Report [Link]'=>report_link,
     'Report [File]'=>report_file,
    }
  end
  def set_default_parameters
    @params['refBuild'] = @dataset[0]['refBuild']
    if dataset_has_column?('refFeatureFile')
      @params['refFeatureFile'] = @dataset[0]['refFeatureFile']
    end
  end
  def commands
    command = "module load #{@params["Rversion"]}\n"
    command << run_RApp("EzAppSpatialSeuratSlides")
  end
end

if __FILE__ == $0

end
