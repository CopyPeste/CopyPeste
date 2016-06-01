require_relative 'mixin'

module CopyPeste
  module Require
    module Graphics
      include Mixin

      module_function

      # Gives the path of the namespace.
      # Implementing it overrides the behavior of [Mixin]
      # @return [String]
      #
      def namespace_path
        Path.graphics
      end
    end
  end
end
