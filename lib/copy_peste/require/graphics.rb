module CopyPeste
  module Require
    module Graphics
      include Mixin

      module_function

      # Get namespace path
      # Implementing it overrides the behavior of [Mixin]
      #
      # @return [String] graphic namespace path
      def namespace_path
        Path.graphics
      end
    end
  end
end
