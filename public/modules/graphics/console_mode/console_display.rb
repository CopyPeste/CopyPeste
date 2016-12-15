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
    "exit_mod" => "exit_analysis_module",
    "generate_result" => "generate_result",
    "list_result" => "list_result",
    "init_bdd" => "init_bdd"
    }

  # Retreive CopyPeste current prompt
  #
  # @return [String] current prompt
  def self.prompt
    @@prompt
  end

  # Initialise debug mode
  #
  # @param [Bool] whether the debug mode has to be activated
  def self.debug=(debug_mode)
    @@debug = debug_mode
  end

  # Retreive all available commands
  #
  # @return [Hash] List of all available commands
  def self.events_to_command
    @@events_to_command
  end

end
