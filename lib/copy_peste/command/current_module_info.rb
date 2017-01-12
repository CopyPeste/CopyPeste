module CopyPeste
  class Command
    module CurrentModuleInfo

      # Display information of the current loaded module.
      #
      # @return [Boolean] True if the cmd_return methods success otherwise False.
      def run
        mod = @core_state.analysis_module || @core_state.graphic_mod
        info = "Authors: #{mod.authors}\n"
        info << "Type: #{mod.type}\n"
        info << "Version: #{mod.version}\n"
        info << "Description: #{mod.description}\n"
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
