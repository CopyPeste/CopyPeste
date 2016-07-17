module CopyPeste
  class Command
    module UseAnalysisModule
      def run
        available_analysis_mods = list_files_from_dir(Require::Path.analysis)
        if @opts.length != 1
          @graph_com.cmd_return(@cmd, "No analysis module loaded.", true)

        elsif (available_analysis_mods.include?(@opts[0]))
          begin
            @core_state.analysisModule = Core::Utils.load_module(
              Require::Path.analysis, File.join(@opts[0], @opts[0] + '.rb')
            )
            @graph_com.info(
              Core::GraphicCommunication.codes[:core],
              "Analysis mod loaded #{@core_state.analysisModule}."
            )
            @graph_com.cmd_return(@cmd, @opts[0], false)
          rescue LoadError => e
            @graph_com.cmd_return(@cmd, @opts[0], true)
          end

        else
          @graph_com.cmd_return(
            @cmd,
            "unknown analyse module (#{@opts[0]}).",
            true
          )
        end
      end

      def init; end

      private

      def list_files_from_dir(path)
        Dir[path + "/*/"].map { |file| File.basename(file) }
      end
    end
  end
end
