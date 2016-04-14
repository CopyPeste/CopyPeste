module Help
  def run
    puts "[debug] Command hash is #{@cmd_hash}".green
    graphic_cmd_return(1, "Command help is running !", [])
    #@core_state.analysisModule.run
  end

  def init
    @update_core_state = true
  end

  def self.extended(mod)
    mod.type << :help
  end

end