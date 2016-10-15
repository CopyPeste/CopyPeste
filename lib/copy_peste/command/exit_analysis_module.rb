module CopyPeste
  class Command
    module ExitAnalysisModule

      # Exit properly a loaded analysis module.
      # @return [Boolean] True if the cmd_return methods success otherwise False.
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

      # Give a string used by the help command in order to explain the aim of
      # this command.
      # @return [String] a string containing the explaination of the command.
      def helper
        "This module leave the instance of the loaded analysis module."
      end

    end
  end
end
