require_relative './command/help.rb'
require_relative './command/exit.rb'
require_relative './command/unknown.rb'
require_relative './command/list_analysis_modules.rb'
require_relative './command/use_analysis_module.rb'
require_relative './command/run_analysis_module.rb'
require_relative './command/set_analysis_mod_options.rb'
require_relative './command/show_analysis_mod_options.rb'

CpRequire.app 'core/utils'

class Command
  attr_accessor :type

  def initialize (cmd_hash, graph_com, core_state)
    @type = []
    @cmd = cmd_hash[:cmd]
    @opts = cmd_hash[:opts]
    @graph_com = graph_com
    @core_state = core_state
    @update_core_state = false

    specialize_into @cmd
    @graph_com.info(
      GraphicCom.codes[:core],
      "Command is #{@cmd} with following opts #{@opts}"
    )
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

  private

  def specialize_into(command)
    class_name = command.split('_').map(&:capitalize).join
    specialization = self.class.const_get class_name
  rescue NameError
  ensure
    self.extend specialization || Unknown
  end

end