module CopyPeste
  class Command
    module Exit

      # Exit properly the CopyPeste Framework by notifing the loaded graphical
      # module. Indeed, this task is performed by calling the cmd_return method
      # from a GraphicCommunication instance.
      # @return [Boolean] True if the cmd_return methods success otherwise False.
      def run
        @graph_com.cmd_return(@cmd, "CopyPeste ended normally !", false)
      end

      def init; end

      module_function

      # Give a string used by the help command in order to explain the aim of
      # this command.
      # @return [String] a string containing the explaination of the command.
      def helper
        "Exit properly CopyPeste Framework."
      end

    end
  end
end
