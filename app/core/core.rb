require 'colorize'
require_relative '../../libs/app/dynamic_loading/module_loader.rb'
require_relative '../commands/command.rb'
require_relative './tmp_logo'

class Core

  def initialize (conf)
    @graphic_mod = load_module(conf['modules']['graphics']['dir'] \
      ,conf['modules']['graphics']['default'])
    @display_func = Proc.new do |msg|
      @graphic_mod.show msg
    end
    @core_state = {}
  end

  def start
   # load_module("./modules/analysis/", "fdf.rb")

   puts LOGO.blue
   puts "Core is running !"
   while @graphic_mod.running?
    cmd_hash = @graphic_mod.loop
    execute_command cmd_hash
  end
end

private

def execute_command (cmd_hash)
  puts "Core execute the following command: #{cmd_hash}."
  begin
    cmd = Command.new(cmd_hash, @display_func, @core_state).extend(cmd_hash[:cmd])
  rescue
    @graphic_mod.show "Error: Command not found."
  end
  cmd.init
  cmd.run
  @core_state = cmd.get_return if cmd.return?
end

def load_module (dir, file)
  path = dir + file
  loaded_mod = ModuleLoading::Loader.load path
  loaded_mod.__cp_init__
end

end

