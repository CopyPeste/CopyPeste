class ConsoleDisplay

  @@prompt = "cp > "
  @@debug = false
  @@events_to_command = {
    "exit" => "exit",
    "help" => "help",
    "lam" => "list_analysis_modules",
    "set_opts" => "set_analysis_mod_options",
    "show_opts" => "show_analysis_mod_options",
    "use" => "use_analysis_module",
    "run" => "run_analysis_module",
    "exit_mod" => "exit_analysis_module"
    }

  def self.prompt
    @@prompt
  end

  def self.debug=(debug_mode)
    @@debug = debug_mode
  end

  def self.events_to_command
    @@events_to_command
  end

end
