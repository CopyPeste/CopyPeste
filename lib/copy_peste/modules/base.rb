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
      end

    end

  end
end
