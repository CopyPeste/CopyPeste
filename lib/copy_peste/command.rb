module CopyPeste
  class Command

    # Instantiate all needed information to correctly execute a command.
    #
    # @param cmd_hash [Hash] Contains command name and its options.
    # @param graph_com [Object] Instance of the GraphicCommunication class.
    # @param core_state [Object] Instance of the CoreState class.
    def initialize(cmd_hash, graph_com, core_state)
      @cmd = cmd_hash[:cmd]
      @opts = cmd_hash[:opts]
      @graph_com = graph_com
      @core_state = core_state

      specialize_into @cmd
      @graph_com.info(
        Core::GraphicCommunication.codes[:core],
        "Command is #{@cmd} with following opts #{@opts}"
      )
    end

    # Execute a given command. This method has to be overrided.
    def run
      #@exec.call "Error: please implement run command method."
    end

    # Initialize a given command before being run.
    # This method has to be overrided.
    def init
      #@exec.call "Error: please implement init command method."
    end

    private

    # Extend this Command class with a specific command that has to be
    # executed.
    #
    # @param command [String] Command name that has to be executed.
    def specialize_into(command)
      class_name = command.split('_').map(&:capitalize).join
      specialization = self.class.const_get class_name
      specialization = nil if specialization.instance_of? Class
    rescue NameError
    ensure
      self.extend specialization || Unknown
    end

  end
end
