require 'colorize'
#CpRequire.libs 'app/dynamic_loading/module_loader.rb'
require CopyPeste::Require::Path.public + '/tmp_logo'

module CopyPeste
  class Core
    def initialize(conf)
      @core_state = CoreState.new
      @core_state.conf = conf
      @graphic_mod = load_module(
        conf['modules']['graphics']['dir'],
        conf['modules']['graphics']['default']
      )
      exec_func = Proc.new do |msg|
        @graphic_mod.exec msg
      end

      @graph_com = GraphicCom.new exec_func
    end

    def start
      puts LOGO.blue
      @graph_com.info(GraphicCom.codes[:core], "Core is running !")
      while @graphic_mod.running?
        cmd_hash = @graphic_mod.loop
        execute_command cmd_hash
      end
    end

    private

    def execute_command(cmd_hash)
      @graph_com.info(
        GraphicCom.codes[:core],
        "Core execute the following command: #{cmd_hash}."
      )
      cmd = Command.new(cmd_hash, @graph_com, @core_state)
      cmd.init
      cmd.run
      @core_state = cmd.get_core_update if cmd.update_core_state?
    end
  end
end
