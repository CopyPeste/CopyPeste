module CopyPeste
  class Command
    module Help
      def run
        helpers = get_helpers
        @graph_com.cmd_return(@cmd, helpers, false)
      end

      def init
        @update_core_state = true
      end

      private

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
          load(path_cmd + cmd_name)
          cmd_name = cmd_name.chomp(".rb")

          if @core_state.events_to_command.has_value?(cmd_name)
            event = @core_state.events_to_command.key(cmd_name)
            cmd_name = cmd_name.split('_')
                               .map(&:capitalize)
                               .join("")
            cmd_module = Command.const_get cmd_name
            helpers.store(event, cmd_module.helper)
          else
            next
          end
        end

        helpers

      end

      def available_commands
        classes = self.class.constants.map do |constant|
          constant = constant.to_s.split('::').last
          constant.underscore
        end
      end

      module_function

      def helper
        "Display this helper message."
      end

    end
  end
end
