module Unknown
  def run
    puts "[debug] Command hash is #{@cmd_hash}".green
    graphic_cmd_return(1, "Error: Command not found !", [])
  end

  def init
  end

  def self.extended(mod)
    mod.type << :unknown
  end
end