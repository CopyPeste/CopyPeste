require_relative './help.rb'
require_relative './exit.rb'
require_relative './unknown.rb'
require_relative './list_analysis_modules.rb'
require_relative './use_analysis_module.rb'

class Command
  attr_accessor :type

  @@available_cmd = {
    "help" => Help,
    "exit" => Exit,
    "list_analysis_modules" => ListAnalysisModules,
    "use_analysis_module" => UseAnalysisModule
  }

  def initialize (cmd_hash, display_func, core_state)
    @type = []
    @cmd = cmd_hash[:cmd]
    @opts = cmd_hash[:opts]
    @show = display_func
    @core_state = core_state
    @update_core_state = false

    if @@available_cmd[@cmd]
      cmd = @@available_cmd[@cmd]
    else
      cmd = Unknown
    end
    self.extend(cmd)
  end

  def graphic_cmd_return (code, output, errors)
    format_hash = {
      :code => code,
      :data => {
        :cmd => @cmd,
        :output => output},
        :errors => errors
      }
      @show.call format_hash
    end

    def run
      @show.call "Error: please implement run command method."
    end

    def init
      @show.call "Error: please implement init command method."
    end

    def update_core_state?
      @update_core_state
    end

    def get_core_update
      @core_state
    end

    private

    def load_module (dir, file)
      path = dir + file
      loaded_mod = ModuleLoading::Loader.load path
      loaded_mod.__cp_init__
    end


  end