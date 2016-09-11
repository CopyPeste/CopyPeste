class AnalyseResult
  include Mongoid::Document

  field :execution_time
  field :execution_duration

  def initialize(tstart)
    execution_time = tstart
  end

end
