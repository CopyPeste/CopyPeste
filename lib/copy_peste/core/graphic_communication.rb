module CopyPeste
  class Core
    class GraphicCommunication

      attr_accessor :exec

      @@codes = {
        :core => 10,
        :analysis => 20,
        :display => 0,
        :info => 1,
        :error => 2,
        :cmd_return => 3
      }

      def initialize (exec_func)
        @exec = exec_func
      end

      # Get communication codes
      #
      # @return [Hash] communication codes
      def self.codes
        @@codes
      end

      # Return a formatted hash containing information resulting the execution
      # of a command by the Core to the loaded graphical module.
      #
      # @param cmd [String] Treated command's name
      # @param output [String] Output's string to be displayed by the graphical module.
      # @param isError [Boolean] Define if the command ended correctly or not.
      def cmd_return (cmd, output, isError)
        format_hash = {
          :code => @@codes[:core] + @@codes[:cmd_return],
          :data => {
            :cmd => cmd,
            :output => output,
            :isError => isError
            },
          }
        @exec.call format_hash
      end

      # Return a formatted hash containing information in case of an error to be
      # displayed by the loaded graphical module.
      #
      # @param from [Integer] Element of CopyPeste where the error occured.
      # @param error_code [Integer] Error code number depending of the error type.
      # @param error_msg [String] String to be displayed by the graphical module.
      def error (from, error_code, error_msg)
        format_hash = {
          :code => from + @@codes[:error],
          :data => {
            :error_code => error_code,
            :error_msg => error_msg
            },
          }
        @exec.call format_hash
      end

      # Return a formatted hash containing an informative message to be
      # displayed by the loaded graphical module. This message is supposed
      # to be displayed if the verbose option is set as a parameter when
      # CopyPeste has been executed.
      #
      # @param from [Integer] Element of CopyPeste which generate this message.
      # @param output [String] String to be displayed by the graphical module.
      def info (from, output)
        format_hash = {
          :code => from + @@codes[:info],
          :data => {
            :output => output
            },
          }
        @exec.call format_hash
      end

      # Return a formatted hash containing a message to be displayed by
      # the loaded graphical module.
      #
      # @param from [Integer] Element of CopyPeste which generates this message.
      # @param output [String] String to be displayed by the graphical module.
      def display (from, output)
        format_hash = {
          :code => from + @@codes[:display],
          :data => {
            :output => output
            },
          }
        @exec.call format_hash
      end


    end
  end
end
