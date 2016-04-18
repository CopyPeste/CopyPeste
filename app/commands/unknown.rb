module Unknown
  def run
    @graph_com.cmd_return(@cmd, "Command not found !", true)
  end

  def init
  end

  def self.extended(mod)
    mod.type << :unknown
  end
end