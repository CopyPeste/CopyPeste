require 'colorize'
require_relative '../../libs/app/dynamic_loading/module_loader.rb'
require_relative '../commands/command.rb'
require_relative './core_state.rb'
require_relative './tmp_logo'

class Core

  def initialize (conf)
    @core_state = CoreState.new
    @core_state.conf = conf
    @graphic_mod = load_module(conf['modules']['graphics']['dir'] \
      ,conf['modules']['graphics']['default'])
    @display_func = Proc.new do |msg|
      @graphic_mod.show msg
    end
  end

  def start
    ## fct to add in command.rb ##
    #@core_state.analysisModule.options.test = "-es"
    #@core_state.analysisModule.show = Proc.new do |msg|
    #  hash = {
    #    :code => 2,
    #    :data => {
    #      :msg => msg
    #      },
    #      :errors => []
    #    }
    #    @graphic_mod.show hash
    #  end
    ##############################

    puts LOGO.blue
    puts "[debug] Core is running !".green
    while @graphic_mod.running?
      cmd_hash = @graphic_mod.loop
      execute_command cmd_hash
    end
  end

  private

  def execute_command (cmd_hash)
    puts "[debug] Core execute the following command: #{cmd_hash}.".green
    cmd = Command.new(cmd_hash, @display_func, @core_state)
    cmd.init
    cmd.run
    @core_state = cmd.get_core_update if cmd.update_core_state?
  end

  def load_module (dir, file)
    path = dir + file
    loaded_mod = ModuleLoading::Loader.load path
    loaded_mod.__cp_init__
  end
end

