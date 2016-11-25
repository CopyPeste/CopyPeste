module CopyPeste
  class Command
    module Help

      # List all available commands and provides an explanation of what they do.
      #
      # @return [Boolean] True if the cmd_return methods succeeds, False otherwise.
      def run
        helpers = get_helpers
        @graph_com.cmd_return(@cmd, helpers, false)
      end

      def init
        @update_core_state = true
      end

      private

      # Get all help strings from each command objects located in the current
      # folder.
      #
      # @return [Hash] a formated hash containing all help strings.
      def get_helpers
        path_cmd = File.join(
          CopyPeste::Require::Path.copy_peste,
          "command/"
          )

        list_cmd = Dir.entries(path_cmd)
        list_cmd.delete(".")
        list_cmd.delete("..")
        list_cmd.delete("unknown.rb")
        list_cmd.delete("help.rb")

        helpers = {}
        list_cmd.each do | cmd_name |
          cmd_name = cmd_name.chomp(".rb")

          if @core_state.events_to_command.has_value?(cmd_name)
            event = @core_state.events_to_command.key(cmd_name)
            cmd_name = cmd_name.split('_')
                               .map(&:capitalize)
                               .join("")
            cmd_module = Command.const_get cmd_name
            helpers.store(event, cmd_module.helper)
          else next
          end
        end

        helpers
      end

      # List all available commands provided by the framework
      def available_commands
        classes = self.class.constants.map do |constant|
          constant = constant.to_s.split('::').last
          constant.underscore
        end
      end

      module_function

      # Method used by the help command in order to explain the aim of this module.
      #
      # @return [String] a string containing the command purpose.
      def helper
        "Display this helper message."
      end

    end
  end
end
