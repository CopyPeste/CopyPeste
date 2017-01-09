module CopyPeste
  class Core

    # This class is used to store data between each execution of commands.
    class CoreState
      attr_accessor :analysisModule
      attr_accessor :conf
      attr_accessor :events_to_command
      attr_accessor :analysisModOpts
      attr_accessor :graphic_mod
      attr_accessor :module_mng

      def initialize
        @graphic_mod = nil
        @analysisModule = nil
        @conf = nil
        @module_mng = nil
        @analysisModOpts = {}
        @events_to_command = {}
      end
    end
  end
end
