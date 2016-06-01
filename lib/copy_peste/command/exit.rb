class Command
  module Exit
    def run
      @graph_com.cmd_return(@cmd, "CopyPeste ended normally !", false)
    end

    def init; end
  end
end
