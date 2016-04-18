module UseAnalysisModule

  def run
    available_analysis_mods = list_files_from_dir(CpRequire.base_path \
      + @core_state.conf['modules']['analysis']['dir'])
    if @opts.length != 1
      @graph_com.cmd_return(@cmd, "No analysis module loaded.", true)
    elsif (available_analysis_mods.include?(@opts[0]))
      @graph_com.cmd_return(@cmd, @opts[0], false)
      @core_state.analysisModule = load_module( \
        @core_state.conf['modules']['analysis']['dir'] + @opts[0] + "/" \
        , @opts[0] + ".rb")
      @graph_com.info(GraphicCom.codes[:core], "Analysis mod loaded #{@core_state.analysisModule}.")
    else
      @graph_com.cmd_return(@cmd, "unknown analyse module (#{@opts[0]}).", true)
    end
  end

  def init
  end

  def self.extended(mod)
    mod.type << :useAnalysisModule
  end

end