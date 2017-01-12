module CopyPeste
  class Core

    # This class is used to store data between each execution of commands.
    class CoreState
      attr_accessor :analysis_module
      attr_accessor :conf
      attr_accessor :events_to_command
      attr_accessor :graphic_mod
      attr_accessor :module_mng

      def initialize
        @graphic_mod = nil
        @analysis_module = nil
        @conf = nil
        @module_mng = nil
        @events_to_command = {}
      end
    end
  end
end
