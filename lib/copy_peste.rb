require 'yaml'

require_relative 'ext/string'
require_relative 'copy_peste/require'

module CopyPeste
  include Require::Mixin

  @@debug_mode = false

  module_function

  # Load the CopyPeste configuration file and run the CopyPeste  Core part.
  #
  # @param dir [String] path of the folder containing the configuration file.
  # @param file [String] Configuration's filename.
  def run(dir: '/', file: 'copy_peste.yml')
    ["INT"].each do | sig |
      trap(sig) do
        puts ""
        exit
      end
    end

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

  # Return if the CopyPeste framework is runnning in debug mode or not.
  #
  # @return [Boolean] True if the debug mode is set otherwise False.
  def debug_mode
    @@debug_mode
  end

  # Gives the path of the namespace.
  # Implementing it overrides the behavior of [Require::Mixin]
  #
  # @return [String] namespace path
  def namespace_path
    Require::Path.copy_peste
  end
end

CopyPeste.run
