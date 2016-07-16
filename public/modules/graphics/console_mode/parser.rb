require File.join(
  CopyPeste::Require::Path.graphics,
  'console_mode',
  'console_display'
)

class Parser < ConsoleDisplay

  def self.parse str
    str = str.delete!("\n")
    str = str.squeeze(' ').strip()
    tokens = str.split(' ')
    cmd = tokens[0]
    if tokens.size > 1
      opts = tokens[1..-1]
    else
      opts = []
    end

    cmd_hash = {:cmd => "", :opts => opts}
    if cmd == "exit"
      cmd_hash[:cmd] = "exit"
    elsif cmd == "lam"
      cmd_hash[:cmd] = "list_analysis_modules"
    elsif cmd == "set_opts"
      cmd_hash[:cmd] = "set_analysis_mod_options"
    elsif cmd == "show_opts"
      cmd_hash[:cmd] = "show_analysis_mod_options"
    elsif cmd == "use"
      cmd_hash[:cmd] = "use_analysis_module"
    elsif cmd == "run"
      cmd_hash[:cmd] = "run_analysis_module"
    else
      cmd_hash[:cmd] = cmd
    end

    if @@debug == true
      puts "[info][Graphic] Says that your command is #{cmd_hash}.".green
    end

    cmd_hash

  end
end
