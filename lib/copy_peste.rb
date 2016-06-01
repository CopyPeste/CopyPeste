require 'yaml'
require 'class_loader'
require_relative 'ext/string'
require_relative 'copy_peste/require'

module CopyPeste

  module_function

  def run(dir: '/', file: 'copy_peste.yml')
    config = YAML::load_file(File.join(dir, file)) if File.exists? (dir+file)
    puts !!config
    # core = Core.new config
    # core.start
    self
  end
end

CopyPeste.run
