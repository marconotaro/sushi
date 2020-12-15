#!/usr/bin/env ruby
# encoding: utf-8
Version = '20171109-095604'

require 'sushi_fabric'
require_relative 'global_variables'
include GlobalVariables

class MetagenomeAnnotationQCApp < SushiFabric::SushiApp
def initialize
super
@name = 'MetagenomeAnnotationQC'
@analysis_category = 'Metagenomics'
@description =<<-EOS
Quality control of metagenome assembly and annotation. 
  EOS
@params['process_mode'] = 'DATASET'
@required_columns = ['Name', 'contigFile', 'prodigalPredictionFile','interproscanFile']
@required_params = ['numberOfTopNCategories','grouping', 'sampleGroup', 'refGroup']
@params['cores'] = '1'
@params['ram'] = '7'
@params['scratch'] = '10'
@params['numberOfTopNCategories'] = '30'
@params['numberOfTopNCategories', 'description'] = 'Number of top most represented GO and protein categories to report.'
@params['grouping'] = '' 
@params['sampleGroup'] = '' 
@params['sampleGroup', 'description'] = 'sampleGroup should be different from refGroup'
@params['refGroup'] = '' 
@params['refGroup', 'description'] = 'refGroup should be different from sampleGroup'
@params['mail'] = ""
@inherit_tags = ["Factor", "B-Fabric", "Characteristic"]
@modules = ["Dev/R"]
end

def next_dataset
@params['name'] = "MetagenomeAnnotationQC"
    report_file = File.join(@result_dir, @params['name'])
    report_link = File.join(report_file, '00index.html')
{'Name'=>@params['name'],
  'Report [File]'=>report_file,
  'Static Report [Link]'=>report_link,
}
end
def commands
run_RApp("EzAppMetagenomeAnnotationQC")
end
end

if __FILE__ == $0
end
