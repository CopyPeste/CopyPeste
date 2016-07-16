class ConsoleDisplay

  @@prompt = "cp > "
  @@debug = false

  def self.prompt
    @@prompt
  end

  def self.debug=(debug_mode)
    @@debug = debug_mode
  end

end
