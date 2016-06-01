CpRequire.modules 'graphics/console_mode/console_display'

class AnalysisRequests < ConsoleDisplay

  def initialize
  end

  def exec hash
    if hash[:code] % 10 == 1
      puts "[info][Analysis] #{hash[:data][:output]}".green
    elsif hash[:code] % 10 == 0
      puts "[Analysis] #{hash[:data][:output]}"
    end
  end

end