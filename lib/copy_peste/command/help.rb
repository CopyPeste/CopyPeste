module CopyPeste
  class Command
    module Help
      def run
        @graph_com.cmd_return(@cmd, "Command help is running !", false)
      end

      def init
        @update_core_state = true
      end

      private

      def available_commands
        classes = self.class.constants.map do |constant|
          constant = constant.to_s.split('::').last
          constant.underscore
        end
      end
    end
  end
end
