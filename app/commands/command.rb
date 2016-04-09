require_relative './help.rb'
require_relative './exit.rb'
require_relative './unknown.rb'

class Command
  attr_accessor :type

  def initialize (cmd_hash, display_func, core_state)
    @type = []
    @cmd_hash = cmd_hash
    @show = display_func
    @core_state = core_state
    @return = false
  end

  def run
    @show.call "Error: please implement run command method."
  end

  def init
    @show.call "Error: please implement init command method."
  end

  def return?
    @return
  end

  def get_return
    @core_state
  end

end