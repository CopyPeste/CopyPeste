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

    %W{ parser console_display }.each do |file|
      require File.join(
        CopyPeste::Require::Path.graphics,
        'console_mode',
        file
      )
    end

    %W{ analysis_requests core_requests }.each do |file|
      require File.join(
        CopyPeste::Require::Path.graphics,
        'console_mode/requests',
        file
      )
    end

    class ConsoleMode

      def initialize
        @alive = true
        @core_req = CoreRequests.new
        @analysis_req = AnalysisRequests.new
      end

      def set_debug_mode(debug_mode)
        ConsoleDisplay.debug = debug_mode
      end

      def get_events
        ConsoleDisplay.events_to_command
      end

      def loop
        print ConsoleDisplay.prompt
        cmd = STDIN.gets
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
