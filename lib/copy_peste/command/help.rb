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
      classes = self.class.constants.map { |c| to_underscored_name(c.to_s) }
    end

    def to_underscored_name(class_name)
      word = class_name.split('::').last
      word.gsub!(/([A-Z]+)([A-Z][a-z])/,'\1_\2')
      word.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
      word.tr!("-", "_")
      word.downcase!
      word
  end

  end
end
