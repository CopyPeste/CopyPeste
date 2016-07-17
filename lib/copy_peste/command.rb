module CopyPeste
  class Command
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

    def run
      #@exec.call "Error: please implement run command method."
    end

    def init
      #@exec.call "Error: please implement init command method."
    end

    private

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
