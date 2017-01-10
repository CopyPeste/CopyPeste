require 'main'
require 'yaml'

require_relative 'ext/string'
require_relative 'copy_peste/require'

module CopyPeste
  include Require::Mixin

  @@debug_mode = false

  module_function

  # Load the CopyPeste configuration file and run the CopyPeste Core part.
  #
  # @param configuration [Hash]
  def run(configuration)
    # Catching signals
    ["INT"].each do | sig |
      trap(sig) do
        puts ""
        exit
      end
    end

    # Definning debugging behavior
    @@debug_mode = configuration['debug']

    # Initializing dependancies of the framework
    require File.join(Require::Path.root, 'initializers.rb')
    Initializers(configuration)

    # Launching CopyPeste
    core = Core.new configuration
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

Main {
  config_path File.join(CopyPeste::Require::Path.root, 'copy_peste.yml')

  option('environment', 'e') {
    description 'Set the environment to use. Overrides configuration file value.'
    arity 1
    argument :required
  }

  option('ports_tree_path', 't') {
    description 'Path to the directory of the ports tree. Overrides configuration file value.'
    argument :required
    arity 1
    validate { |path| File.directory? path }
  }

  option('debug') {
    description 'Display debugging outputs.'
    cast :bool
    default false
  }

  def run
    # Retrieving appropriate configuration
    configuration_defined = config.to_h
    environment_defined = params['environment'].value || configuration_defined['environment']

    unless configuration_defined.has_key? environment_defined
      puts "Undefined configuration for environment '#{environment_defined}'."
      exit
    end

    # Merging everything: defaults, config file, prompt line
    configuration_to_use = params
      .select { |p| !p.given && !p.defaults.empty? }
      .map { |p| [p.names.first, p.default] }
      .to_h
      .merge configuration_defined[environment_defined]
      .merge params
        .select { |p| p.given }
        .map { |p| [p.names.first, p.value] }
        .to_h
      .merge Hash['environment', environment_defined]

    # Good to go
    CopyPeste.run(configuration_to_use)
  end
}
