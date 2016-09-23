module CopyPeste
  class Command
    module RunAnalysisModule
      def run
        puts @core_state.analysisModule
        if @core_state.analysisModule.nil?
          @graph_com.cmd_return(@cmd, "No analysis module loaded.", true)
          return
        end

        @core_state.analysisModule.show = Proc.new do |msg|
          from = Core::GraphicCommunication.codes[:analysis]
          @graph_com.display(from, msg)
        end

        ar = AnalyseResult.new Time.now
        begin
          @core_state.analysisModule.run ar
        rescue Exception => e
          traceback = ""
          traceback = "(Traceback) #{e}" if !e.message.empty?
          @graph_com.cmd_return(@cmd,
            "Analysis module aborted.\n#{traceback}", true)
        end
        ar.save!
      end

      def init; end

      module_function

      def helper
        "Run the selected analysis module."
      end

    end
  end
end
