require 'readline'
require File.join(
  CopyPeste::Require::Path.graphics,
  'console_mode',
  'console_display'
)

class Parser < ConsoleDisplay

  def self.parse str
    str = str.squeeze(' ').strip()
    tokens = str.split(' ')
    cmd = tokens[0]
    if tokens.size > 1
      opts = tokens[1..-1]
    else
      opts = []
    end

    cmd_hash = {:cmd => "", :opts => opts}

    if @@events_to_command.has_key? cmd
      cmd_hash[:cmd] = @@events_to_command[cmd]
    else
      cmd_hash[:cmd] = cmd
    end

    if @@debug == true
      puts "[info][Graphic] Says that your command is #{cmd_hash}.".green
    end

    cmd_hash

  end

  def self.get_input prompt
    list_available_cmd = ConsoleDisplay.events_to_command.keys.sort
    comp = proc { |s| list_available_cmd.grep(/^#{Regexp.escape(s)}/) }

    Readline.completion_append_character = " "
    Readline.completion_proc = comp

    line = Readline.readline(prompt, true)
    if line == ""
      Readline::HISTORY.pop
    end
    line
  end

end
