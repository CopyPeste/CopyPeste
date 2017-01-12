module CopyPeste
  class Command
    module ListAnalysisModules

      # List all available analysis module and return results to the loaded
      # graphical module in order to be displayed.
      #
      # @return [Boolean] True if the cmd_return methods succeeds, false otherwise
      def run
        available_analysis_mods = []
        @core_state.module_mng.modules_list[:analysis].each do |mod|
          available_analysis_mods.push(mod.first)
        end

        @graph_com.cmd_return(@cmd, available_analysis_mods, false)
      end

      def init; end

      module_function

      # Method used by the help command in order to explain the aim of this module.
      #
      # @return [String] a string containing the command purpose.
      def helper
        "List all currently available analysis modules."
      end

    end
  end
end
