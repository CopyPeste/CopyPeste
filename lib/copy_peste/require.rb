require_relative 'require/mixin'
require_relative 'require/path'
require_relative 'require/analysis'
require_relative 'require/graphics'

module CopyPeste
  module Require
    include Mixin

    module_function

    # Gives the path of the namespace.
    # Implementing it overrides the behavior of [Mixin]
    # @return [String]
    #
    def namespace_path
      Path.copy_peste
    end
  end
end
