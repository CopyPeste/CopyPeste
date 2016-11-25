module CopyPeste
  module Require
    module Path
      module_function

      # Generate root namespace
      #
      # @return [String] root namespace
      def root
        File.expand_path(File.dirname(__FILE__) + '/../../..')
      end

      # Generate base namespace
      #
      # @return [String] base namespace
      def base
        root + '/lib'
      end

      # Generate copy_peste namespace
      #
      # @return [String] copy_peste namespace
      def copy_peste
        base + '/copy_peste'
      end

      # Generate algorithms namespace
      #
      # @return [String] algorithms namespace
      def algorithms
        base + '/algorithms'
      end

      # Generate public namespace
      #
      # @return [String] public namespace
      def public
        root + '/public'
      end

      # Generate analysis namespace
      #
      # @return [String] analysis namespace
      def analysis
        public + '/modules/analysis'
      end

      # Generate graphic namespace
      #
      # @return [String] graphic namespace
      def graphics
        public + '/modules/graphics'
      end
    end
  end
end
