module CopyPeste
  class Core
    class CoreState
      attr_accessor :analysisModule
      attr_accessor :conf
      attr_accessor :events_to_command
      attr_accessor :analysisModOpts

      def initialize
        @analysisModule = nil
        @conf = nil
        @analysisModOpts = {}
        @events_to_command = {}
      end
    end
  end
end
