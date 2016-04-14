module ListAnalysisModules
  def run
    puts "[debug] Command hash is #{@cmd_hash}".green
    files = Dir[@core_state.conf['modules']['analysis']['dir'] + "/*/"]
    available_analysis_mods = []
    files.each do |mod|
      available_analysis_mods.push(File.basename(mod))
    end
    #puts available_analysis_mods
    graphic_cmd_return(1, available_analysis_mods, [])
  end

  def init
  end

  def self.extended(mod)
    mod.type << :ListAnalysisModules
  end
end