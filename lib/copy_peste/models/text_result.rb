require_relative './result'

class TextResult < Result
  include Mongoid::Document

  embedded_in :analyse_result, class_name: "AnalyseResult", inverse_of: :result

  field :text, type: String
end
