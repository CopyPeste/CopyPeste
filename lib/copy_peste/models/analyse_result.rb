class AnalyseResult
  include Mongoid::Document

  field :module_name, type: String
  field :options, type: Hash

  embeds_many :results

  def add_array(header:, rows:, title: nil)
    self.results << ArrayResult.new(header: header, rows: rows, title: title)
  end

  def add_text(text:)
    self.results << TextResult.new(text: text)
  end

end
