require 'mongoid'

# load database configuration
Mongoid.load!("../../../config/database/mongoid.yml", :development)

# load models
require '../../../models/file'
