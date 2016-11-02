class Extension
  include Mongoid::Document

  field :name, type: String
  field :files, type: Array
  field :sim, type: Array
end
