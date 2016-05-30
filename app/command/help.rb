class Command
  module Help
    def run
      @graph_com.cmd_return(@cmd, "Command help is running !", false)
    end

    def init
      @update_core_state = true
    end
  end
end
