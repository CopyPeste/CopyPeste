module CopyPeste
  class Command
    module ListAnalysisModules
      def run
        files = list_files_from_dir(Require::Path.analysis)
        available_analysis_mods = []
        files.each do |mod|
          available_analysis_mods.push(File.basename(mod))
        end

        @graph_com.cmd_return(@cmd, available_analysis_mods, false)
      end

      def init; end

      private

      def list_files_from_dir(path)
        Dir[path + "/*/"].map { |file| File.basename(file) }
      end

      module_function

      def helper
        "List all currently available analysis modules."
      end

    end
  end
end
