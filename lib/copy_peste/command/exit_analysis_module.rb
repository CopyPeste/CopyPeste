module CopyPeste
  class Command
    module ExitAnalysisModule
      def run
        if @core_state.analysisModule.nil?
          @graph_com.cmd_return(@cmd, "No analysis module loaded.", true)
        else
          @core_state.analysisModule = nil
          @core_state.analysisModOpts = {}
          @graph_com.cmd_return(@cmd, "", false)          
        end
      end

      def init; end

      module_function

      def helper
        "This module leave the instance of the loaded analysis module."
      end

    end
  end
end
