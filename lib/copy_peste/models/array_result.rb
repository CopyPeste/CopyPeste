require_relative './result'

class ArrayResult < Result
  include Mongoid::Document

  embedded_in :analyse_result, class_name: "AnalyseResult", inverse_of: :result

  field :header, type: Array
  field :rows, type: Array
  field :title, type: String
end
