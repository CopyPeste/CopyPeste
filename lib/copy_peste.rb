require 'yaml'

require_relative 'ext/string'
require_relative 'copy_peste/require'

module CopyPeste
  include Require::Mixin

  @@debug_mode = false

  module_function

  def run(dir: '/', file: 'copy_peste.yml')
    if ARGV.length == 1 && (ARGV[0] == "--debug" || ARGV[0] == "-d")
      @@debug_mode = true
    end

    config_path = File.join(Require::Path.root, dir, file)
    config_path = File.expand_path config_path
    config = YAML::load_file(config_path) if File.exists? config_path

    require File.join(Require::Path.root, 'initializers.rb')

    core = Core.new config
    core.start
    self
  end

  def debug_mode
    @@debug_mode
  end

  # Gives the path of the namespace.
  # Implementing it overrides the behavior of [Require::Mixin]
  # @return [String]
  #
  def namespace_path
    Require::Path.copy_peste
  end
end

CopyPeste.run
