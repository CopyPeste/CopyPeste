require 'mongoid'

# load database configuration
mongoid_conf_path = File.join(
  CopyPeste::Require::Path.root,
  'mongoid.yml'
)
Mongoid.load!(mongoid_conf_path, :development)

# load models
models_path = File.join CopyPeste::Require::Path.copy_peste, 'models/*.rb'
Dir[models_path].each { |fp| require fp }
