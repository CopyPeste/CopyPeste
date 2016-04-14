module UseAnalysisModule

  def run
    puts "[debug] Command hash is #{@cmd_hash}".green
    files = Dir[@core_state.conf['modules']['analysis']['dir'] + "/*/"]
    available_analysis_mods = []
    files.each do |mod|
      available_analysis_mods.push(File.basename(mod))
    end
    if (available_analysis_mods.include?(@opts[0]))
      graphic_cmd_return(1, @opts[0], [])
      @core_state.analysisModule = load_module("./modules/analysis/", "fdf.rb")
      puts "[debug] analysis mod loaded #{@core_state.analysisModule}.".green
    else
      graphic_cmd_return(3, "unknown analyse module (#{@opts[0]}).", [])
    end
  end

  def init
  end

  def self.extended(mod)
    mod.type << :useAnalysisModule
  end

end