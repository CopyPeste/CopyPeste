consoleGraphicalModule  do
  description {
    "This is a console mode graphical module for CopyPeste."
  }

  author { "Team Framework" }

  usage { 'Just run it!' }

  init {
    ConsoleMode.new()
  }


  impl {
    require 'tty'
    CpRequire.modules 'graphics/console_mode/parser'
    CpRequire.modules 'graphics/console_mode/requests/analysis_requests'
    CpRequire.modules 'graphics/console_mode/requests/core_requests'

    class ConsoleMode


      def initialize
        @alive = true
        @core_req = CoreRequests.new
        @analysis_req = AnalysisRequests.new
      end

      def loop
        print ConsoleDisplay.prompt
        cmd = gets
        cmd_hash = Parser.parse cmd
        @alive = false if cmd_hash[:cmd] == "exit"
        cmd_hash
      end

      def running?
        @alive
      end

      def exec(hash)
        if hash[:code] < 20
          @core_req.exec hash
        elsif hash[:code] > 19 && hash[:code] < 30
          @analysis_req.exec hash
        end
      end

    end
  }

end
