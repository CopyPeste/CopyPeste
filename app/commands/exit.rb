module Exit
  def run
    puts "Command hash is #{@cmd_hash}"
    @show.call "CopyPeste ended normally !"
  end

  def init
  end

  def self.extended(mod)
    mod.type << :exit
  end

end