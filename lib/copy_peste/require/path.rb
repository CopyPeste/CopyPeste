module CopyPeste
  module Require
    module Path
      module_function

      def root
        File.expand_path(File.dirname(__FILE__) + '/../../..')
      end

      def base
        root + '/lib'
      end

      def public
        root + '/public'
      end

      def analysis
        public + '/modules/analysis'
      end

      def graphics
        public + '/modules/graphics'
      end
    end
  end
end
