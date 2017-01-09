require_relative '../modules.rb'

module CopyPeste
  module Modules

    class Graphics < CopyPeste::Modules::Base

      def initialize
        super()
        @alive = true
        @@type = "graphic"
      end

      # Return the alive boolean variable that define if the CopyPeste Framework
      # is still running or not.
      # @param [Boolean] True if CopyPeste Framework is running otherwise False.
      def running?
        @alive
      end

      # Set boolean variable used to define if CopyPeste has been run
      # with or without the debug parameter.
      def set_debug_mode(debug_mode)
        false
      end

      # Get Hash containing translation between user event's name and CopyPeste
      # command's names.
      # @return [Hash] events_to_command hash.
      def get_events
        {}
      end

      # This method is called by the core in order to get user events.
      # When a events is detected, the graphical module format a hash
      # and return it to the core in order to be executed.
      # @return [Hash] Hash containing commands informations.
      def loop
        {}
      end

      # Parse and execute a Hash returned by the Core after executing a command
      # previously requested by the graphical module through the loop method.
      # @param [Hash] hash containing a task to be treated by graphical module.
      def exec(hash)
        {}
      end

    end

  end
end
