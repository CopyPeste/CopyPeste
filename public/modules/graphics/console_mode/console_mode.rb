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

    # Class accessible through the CopyPeste Core.
    class ConsoleMode
      def initialize
        @alive = true
        @core_req = CoreRequests.new
        @analysis_req = AnalysisRequests.new
      end

      # Set boolean variable used to define if CopyPeste has been run
      # with or without the debug parameter.
      def set_debug_mode(debug_mode)
        ConsoleDisplay.debug = debug_mode
      end

      # Get Hash containing translation between user event's name and CopyPeste
      # command's names.
      # @return [Hash] events_to_command hash.
      def get_events
        ConsoleDisplay.events_to_command
      end

      # This method is called by the core in order to get user events.
      # When a events is detected, the graphical module format a hash
      # and return it to the core in order to be executed.
      # @return [Hash] Hash containing commands informations.
      def loop
        cmd = Parser.get_input ConsoleDisplay.prompt
        cmd_hash = Parser.parse cmd
        @alive = false if cmd_hash[:cmd] == "exit"
        cmd_hash
      end

      # Return the alive boolean variable that define if the CopyPeste Framework
      # is still running or not.
      # @param [Boolean] True if CopyPeste Framework is running otherwise False.
      def running?
        @alive
      end

      # Parse and execute a Hash returned by the Core after executing a command
      # previously requested by the graphical module through the loop method.
      # @param [Hash] hash containing a task to be treated by graphical module.
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
