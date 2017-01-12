module CopyPeste
  module Modules

    class Base

      attr_accessor :type
      attr_accessor :authors
      attr_accessor :version
      attr_accessor :description

      def initialize
        @type = "module"
        @authors = ""
        @version = ""
        @description = ""
        @self_registered_graphics_modules = {}
        @self_registered_analysis_modules = {}
      end

      # @return [Hash] Hash containing all graphics modules classes
      def get_graphics_classes
        @self_registered_graphics_modules
      end

      # @return [Hash] Hash containing all analysis modules classes
      def get_analysis_classes
        @self_registered_analysis_modules
      end


      # @param [Class] constant to register
      # @return [Class] the received constant
      def register_analysis_mod(mod)
        mod_name = @self_registered_analysis_modules.key(nil)
        raise 'Unexpected analysis module registration' if mod.name.nil?
        @self_registered_analysis_modules[mod_name] = mod
      end

      # @param [Class] constant to register
      # @return [Class] the received constant
      def register_graphics_mod(mod)
        mod_name = @self_registered_graphics_modules.key(nil)
        raise 'Unexpected graphic module registration' if mod.name.nil?
        @self_registered_graphics_modules[mod_name] = mod
      end

      # Hook module superclass inheritance in order to load and customize modules
      def customize
        analysis_mod_files = Core::Utils.list_files_from_dir(Require::Path.analysis)
        graphics_mod_files = Core::Utils.list_files_from_dir(Require::Path.graphics)
        analysis_mod_files.each do |mod|
          mod_path = "#{Require::Path.analysis}/#{mod}/#{mod}.rb"
          load_module("Analysis", mod_path, mod)
        end

        graphics_mod_files.each do |mod|
          mod_path = "#{Require::Path.graphics}/#{mod}/#{mod}.rb"
          load_module("Graphics", mod_path, mod)
        end
      end

      private

      # Load a module from its filename
      #
      # @param name [String] filename
      # @return [Boolean] require succeed?
      def load_module(type, mod_path, mod_name)
        if type.eql? "Analysis"
          @self_registered_analysis_modules[mod_name] = nil
        elsif type.eql? "Graphics"
          @self_registered_graphics_modules[mod_name] = nil
        end
        require "#{mod_path}"
      end

    end

  end
end
