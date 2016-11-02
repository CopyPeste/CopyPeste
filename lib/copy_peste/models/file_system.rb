class FileSystem
  include Mongoid::Document

  field :name, type: String
  field :path, type: String
  field :ext, type: BSON::ObjectId
  field :size, type: Integer

end
