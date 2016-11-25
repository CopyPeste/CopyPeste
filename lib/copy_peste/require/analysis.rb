module CopyPeste
  module Require
    module Analysis
      include Mixin

      module_function

      # Get namespace path.
      # Implementing it overrides the behavior of [Mixin]
      #
      # @return [String] analysis path
      def namespace_path
        Path.analysis
      end
    end
  end
end
