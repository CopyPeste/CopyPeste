module CopyPeste
  class Command
    module Exit
      def run
        @graph_com.cmd_return(@cmd, "CopyPeste ended normally !", false)
      end

      def init; end

      module_function

      def helper
        "Exit properly CopyPeste Framework."
      end

    end
  end
end
