module CopyPeste
  class Command
    module UseAnalysisModule

      # Dynamically load a specific analysis module in order to be executed.
      #
      # @return [Boolean] True if the cmd_return methods succeeds, false otherwise
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

      # List all files from a given folder.
      #
      # @param path [String] absolute path of the folder to be examined.
      # @return [List] all files in the specified folder.
      def list_files_from_dir(path)
        Dir[path + "/*/"].map { |file| File.basename(file) }
      end

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
