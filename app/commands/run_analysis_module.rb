module RunAnalysisModule

  def run
    puts @core_state.analysisModule
    if @core_state.analysisModule.nil?
      @graph_com.cmd_return(@cmd, "No analysis module loaded.", true)
      return
    end
    @core_state.analysisModule.show = Proc.new do |msg|
      from = GraphicCom.codes[:analysis]
      @graph_com.display(from, msg)
    end
    @core_state.analysisModule.run
  end

  def init
  end

  def self.extended(mod)
    mod.type << :runAnalysisModule
  end

end