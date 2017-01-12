require 'colorize'

module CopyPeste
  class Core

    attr_accessor :core_state

    # CopyPeste core creation. Initialize it according to the current configuration.
    #
    # @param conf [Hash] configuration to apply.
    def initialize(conf)
      @core_state = CoreState.new
      @core_state.conf = conf

      @core_state.module_mng = ModuleMng.new
      @core_state.graphic_mod = (@core_state.module_mng.get conf['modules']['graphics']['default']).new

      @core_state.graphic_mod.debug_mode = CopyPeste.debug_mode
      @core_state.events_to_command = @core_state.graphic_mod.get_events
      exec_func = Proc.new do |msg|
        @core_state.graphic_mod.exec msg
      end

      @graph_com = GraphicCommunication.new exec_func
    end

    # Execution of CopyPeste's core. This method implements
    # the main Framework's loop. It basically consists of getting
    # an event from the loaded graphical module and then executing it.
    def start
      @graph_com.info(GraphicCommunication.codes[:core], "Core is running !")
      while @core_state.graphic_mod.running?
        cmd_hash = @core_state.graphic_mod.loop
        execute_command cmd_hash
      end
    end

    private

    # Execute a command based on the formatted hash returned by
    # the loaded graphical module.
    #
    # @param cmd_hash [Hash] Next command to treat, received from a graphical module
    def execute_command(cmd_hash)
      @graph_com.info(
        GraphicCommunication.codes[:core],
        "Core execute the following command: #{cmd_hash}."
      )
      return if cmd_hash[:cmd] == nil
      cmd = Command.new(cmd_hash, @graph_com, @core_state)
      cmd.init
      cmd.run
    end
  end
end
