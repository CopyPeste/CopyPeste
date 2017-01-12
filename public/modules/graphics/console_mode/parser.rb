require 'readline'
require File.join(
  CopyPeste::Require::Path.graphics,
  'console_mode',
  'console_display'
)

class Parser < ConsoleDisplay

  # Parse a user entry.
  #
  # @param str [String] string that has to be parsed.
  # @return [Hash] a hash containing the command to be executed with its parameters.
  def self.parse(str)
    cmd_hash = {:cmd => "", :opts => []}

    puts "\n" if str.nil?
    str = '' if str.nil?

    str = str.squeeze(' ').strip()
    tokens = str.split(' ')
    cmd = tokens[0]
    if tokens.size > 1
      cmd_hash[:opts] = tokens[1..-1]
    end

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

  # Get a user entry string and/or execute a specific event such has Up or down
  # to browse the command history. All implemented shortcuts are EMACS like.
  #
  # @param prompt [String] prompt to be displayed before waiting for a user entry.
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
