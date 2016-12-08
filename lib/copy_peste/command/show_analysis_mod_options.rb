module CopyPeste
  class Command
    module ShowAnalysisModOptions

      # Display available options of the loaded analysis module with their current values.
      #
      # @return [Boolean] True if the cmd_return methods succeeds, false otherwise
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

      # Method used by the help command in order to explain the aim of this module.
      #
      # @return [String] a string containing the command purpose.
      def helper
        "Display all available options on the selected analysis module."
      end

    end
  end
end
