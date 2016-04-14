module Exit
  def run
    puts "[debug] Command hash is #{@cmd_hash}".green
    graphic_cmd_return(1, "CopyPeste ended normally !", [])
  end

  def init
  end

  def self.extended(mod)
    mod.type << :exit
  end

end