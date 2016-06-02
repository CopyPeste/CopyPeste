module CopyPeste
  class Command
    module Unknown
      def run
        @graph_com.cmd_return(@cmd, "Command not found !", true)
      end

      def init; end
    end
  end
end
