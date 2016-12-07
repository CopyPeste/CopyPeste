module CopyPeste
  class Command
    module CurrentModuleInfo

      # Display information of the current loaded module.
      #
      # @return [Boolean] True if the cmd_return methods success otherwise False.
      def run
        info = ""
        if @core_state.analysisModule.nil?
          info << "Authors: #{@core_state.graphic_mod.authors}\n"
          info << "Type: #{@core_state.graphic_mod.type}\n"
          info << "Version: #{@core_state.graphic_mod.version}\n"
          info << "Description: #{@core_state.graphic_mod.description}\n"
        else
          info = "Authors: #{@core_state.analysisModule.authors}\n"
          info << "Type: #{@core_state.analysisModule.type}\n"
          info << "Version: #{@core_state.analysisModule.version}\n"
          info << "Description: #{@core_state.analysisModule.description}\n"
        end
        @graph_com.cmd_return(@cmd, info, false)
      end

      def init; end

      module_function

      # Method used by the help command in order to explain the aim of this module.
      #
      # @return [String] a string containing the command purpose.
      def helper
        "Display information of the current loaded module."
      end

    end
  end
end
