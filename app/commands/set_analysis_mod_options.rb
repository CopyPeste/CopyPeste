module SetAnalysisModOptions
  def run
    if @core_state.analysisModule.nil?
      @graph_com.cmd_return(@cmd, "No analysis module load", true)
      return
    end

    if @opts.length == 2 && @core_state.analysisModule.options.key?(@opts[0]) \
      && @core_state.analysisModule.options[@opts[0]][:allowed].include?(@opts[1].to_i)
      @core_state.analysisModule.options[@opts[0]][:value] = @opts[1].to_i
      @graph_com.cmd_return(@cmd, "", false)
      return
    end
    @graph_com.cmd_return(@cmd, "invalid arguments.", true)
  end

  def init
  end

  def self.extended(mod)
    mod.type << :setAnalysisModOptions
  end
end