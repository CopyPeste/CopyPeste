module CopyPeste
  class Command
    module ShowAnalysisModOptions

      # Display available options of the loaded analysis module with for
      # each of them their current values.
      # @return [Boolean] True if the cmd_return methods success otherwise False.
      def run
        if @core_state.analysisModule.nil?
          @graph_com.cmd_return(@cmd, "No analysis module load", true)
          return
        end

        options = @core_state.analysisModule.options
        @graph_com.cmd_return(@cmd, options, false)
      end

      def init; end

      module_function

      # Give a string used by the help command in order to explain the aim of
      # this command.
      # @return [String] a string containing the explaination of the command.
      def helper
        "Display all available options on the selected analysis module."
      end

    end
  end
end
