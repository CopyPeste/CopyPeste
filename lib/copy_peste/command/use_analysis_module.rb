module CopyPeste
  class Command
    module UseAnalysisModule

      # Dynamically load a specific analysis module in order to be executed.
      #
      # @return [Boolean] True if the cmd_return methods succeeds, false otherwise
      def run
        mod = @core_state.module_mng.get @opts[0]
        if mod.nil?
          @graph_com.cmd_return(@cmd, "Unknown module (#{@opts[0]}).", true)
          return
        end

        begin
          mod = mod.new

        rescue StandardError => emsg
          @graph_com.cmd_return(@cmd, "Module is badly formatted. Loading aborted.\n(Traceback) #{emsg}", true)

        else
          @core_state.analysis_module = mod
          @graph_com.info(
            Core::GraphicCommunication.codes[:core],
            "Analysis mod loaded #{@core_state.analysis_module}."
          )
          @graph_com.cmd_return(@cmd, @opts[0], false)
        end
      end

      def init; end

      module_function

      # Method used by the help command in order to explain the aim of this module.
      #
      # @return [String] a string containing the command purpose.
      def helper
        "Load a specific analysis module to be used."
      end

    end
  end
end
