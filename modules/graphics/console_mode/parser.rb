class Parser

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
    elsif cmd == "use"
      cmd_hash[:cmd] = "use_analysis_module"
    else
      cmd_hash[:cmd] = cmd
    end

    puts "[debug] Graphic says that your command is #{cmd_hash}.".green

    cmd_hash

  end
end