module CopyPeste
  class Command
    module UseAnalysisModule
      def run
        available_analysis_mods = list_files_from_dir(Require::Path.analysis)
        if @opts.length != 1
          @graph_com.cmd_return(@cmd, "No analysis module loaded.", true)

        elsif (available_analysis_mods.include?(@opts[0]))
          @graph_com.cmd_return(@cmd, @opts[0], false)
          @core_state.analysisModule = load_module(
            @core_state.conf['modules']['analysis']['dir'] + @opts[0] + "/",
            @opts[0] + ".rb"
          )
          @graph_com.info(
            GraphicCommunication.codes[:core],
            "Analysis mod loaded #{@core_state.analysisModule}."
          )

        else
          @graph_com.cmd_return(
            @cmd,
            "unknown analyse module (#{@opts[0]}).",
            true
          )
        end
      end

      def init; end
    end
  end
end
