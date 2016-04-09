module Unknown
  def run
    puts "Command hash is #{@cmd_hash}"
    @show.call "Error: Command not found !"
  end

  def init
  end

  def self.extended(mod)
    mod.type << :unknown
  end
end