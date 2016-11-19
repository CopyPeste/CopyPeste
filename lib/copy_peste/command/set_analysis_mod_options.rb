module CopyPeste
  class Command
    module SetAnalysisModOptions

      # Allows a user to configure available options of a loaded analysis module
      # before being executed.
      #
      # @return [Boolean] True if the cmd_return methods succeeds, false otherwise
      def run
        if @core_state.analysisModule.nil?
          @graph_com.cmd_return(@cmd, "No analysis module load", true)
          return
        end

        if @opts.length == 2 &&
          @core_state.analysisModule.options.key?(@opts[0]) &&
          @core_state.analysisModule.options[@opts[0]][:allowed].include?(@opts[1].to_i)

          @core_state.analysisModule.options[@opts[0]][:value] = @opts[1].to_i
          @graph_com.cmd_return(@cmd, "", false)
          return
        end

        @graph_com.cmd_return(@cmd, "invalid arguments.", true)
      end

      def init; end

      module_function

      # Method used by the help command in order to explain the aim of this module.
      #
      # @return [String] a string containing the command purpose.
      def helper
        "Set options on the selected analysis module."
      end

    end
  end
end
