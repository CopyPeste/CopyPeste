module Help
  def run
    @core_state = 2
    puts "Command hash is #{@cmd_hash}"
    @show.call "Command help is running !"
  end

  def init
    @return = true
  end

  def self.extended(mod)
    mod.type << :help
  end

end