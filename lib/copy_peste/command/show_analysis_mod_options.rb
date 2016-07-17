module CopyPeste
  class Command
    module ShowAnalysisModOptions
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

      def helper
        "Display all available options on the selected analysis module."
      end

    end
  end
end
