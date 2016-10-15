module CopyPeste
  class Command
    module Unknown

      # In case of an unknown called command, this method notify it to the
      # loaded graphical module.
      # @return [Boolean] True if the cmd_return methods success otherwise False.
      def run
        @graph_com.cmd_return(@cmd, "Command not found !", true)
      end

      def init; end
    end
  end
end
