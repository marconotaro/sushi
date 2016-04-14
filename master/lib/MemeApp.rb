#!/usr/bin/env ruby
# encoding: utf-8

require 'sushi_fabric'
require_relative 'global_variables'
include GlobalVariables

class MemeApp <  SushiFabric::SushiApp
  def initialize
    super
    @name = 'MemeApp'
    @analysis_category = 'Motif'
    @description =<<-EOS
Perform motif discovery on DNA, RNA or protein datasets<br/>
<a href='http://meme-suite.org/tools/meme'>http://meme-suite.org/tools/meme</a>
    EOS
    @required_columns = ['Name','PeakSequences']
    @required_params = ['name']
    @params['cores'] = '1'
    @params['ram'] = '10'
    @params['scratch'] = '20'
    @params['name'] = 'MotifCheck_MEME'
    @params['motifDB'] = '-db /usr/local/ngseq/stow/meme_4.10.2/db/motif_databases/JASPAR/JASPAR_CORE_2014_vertebrates.meme -db /usr/local/ngseq/stow/meme_4.10.2/db/motif_databases_12.7/MULTI/jolma2013.meme -db /usr/local/ngseq/stow/meme_4.10.2/db/motif_databases/MOUSE/uniprobe_mouse.meme'
    @params['cmdOptions'] = '-meme-mod zoops -meme-minw 6 -meme-maxw 30 -meme-nmotifs 3 -dreme-e 0.05 -centrimo-score 5.0 -centrimo-ethresh 10.0'
    @params['mail'] = ''
  end
  def next_dataset
    meme_link = File.join(@result_dir, "#{@dataset['Name']}/#{@dataset['Name']}_meme-chip.html")
    {'Name'=>@dataset['Name'],
     'MEME Result [File]'=>File.join(@result_dir, "#{@dataset['Name']}"),
     'MEME Report [Link]'=>meme_link,
    }
  end
  def set_default_parameters
    end

  def commands
    run_RApp("EzAppMEME")
  end
end

if __FILE__ == $0

end
