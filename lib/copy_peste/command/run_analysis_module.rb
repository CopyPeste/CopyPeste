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

        @core_state.analysisModule.run
      end

      def init; end

      module_function

      def helper
        "Run the selected analysis module."
      end

    end
  end
end
