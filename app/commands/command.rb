require_relative './help.rb'
require_relative './exit.rb'
require_relative './unknown.rb'
require_relative './list_analysis_modules.rb'
require_relative './use_analysis_module.rb'
require_relative './run_analysis_module.rb'
require_relative './set_analysis_mod_options.rb'
require_relative './show_analysis_mod_options.rb'
CpRequire.app 'core/utils'

class Command
  attr_accessor :type

  @@available_cmd = {
    "help" => Help,
    "exit" => Exit,
    "list_analysis_modules" => ListAnalysisModules,
    "use_analysis_module" => UseAnalysisModule,
    "run_analysis_module" => RunAnalysisModule,
    "set_analysis_mod_options" => SetAnalysisModOptions,
    "show_analysis_mod_options" => ShowAnalysisModOptions
  }



  def initialize (cmd_hash, graph_com, core_state)
    @type = []
    @cmd = cmd_hash[:cmd]
    @opts = cmd_hash[:opts]
    @graph_com = graph_com
    @core_state = core_state
    @update_core_state = false

    if @@available_cmd[@cmd]
      cmd = @@available_cmd[@cmd]
    else
      cmd = Unknown
    end
    self.extend(cmd)
    @graph_com.info(GraphicCom.codes[:core], "Command is #{@cmd} with following opts #{@opts}")
  end


  def run
    #@exec.call "Error: please implement run command method."
  end

  def init
    #@exec.call "Error: please implement init command method."
  end

  def update_core_state?
    @update_core_state
  end

  def get_core_update
    @core_state
  end


end