module CopyPeste
  class Command
    module RunAnalysisModule

      # Run the loaded analysis module with configured parameters.
      #
      # @return [Boolean] True if the cmd_return method succeeds, false otherwise
      def run
        if @core_state.analysis_module.nil?
          @graph_com.cmd_return(@cmd, "No analysis module loaded.", true)
          return
        end

        @core_state.analysis_module.show = Proc.new do |msg|
          from = Core::GraphicCommunication.codes[:analysis]
          @graph_com.display(from, msg)
        end

        ar = AnalyseResult.new
        begin
          ret = @core_state.analysis_module.run ar
        rescue StandardError => e
          traceback = ""
          traceback = "(Traceback) #{e}" if !e.message.empty?
          @graph_com.cmd_return(@cmd,
            "Analysis module aborted.\n#{traceback} ", true)
        end
        ar.save! if ret
      end

      def init; end

      module_function

      # Method used by the help command in order to explain the aim of this module.
      #
      # @return [String] a string containing the command purpose.
      def helper
        "Run the selected analysis module."
      end

    end
  end
end
