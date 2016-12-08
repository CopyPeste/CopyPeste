module CopyPeste
  class Command
    module ListAnalysisModules

      # List all available analysis module and return results to the loaded
      # graphical module in order to be displayed.
      #
      # @return [Boolean] True if the cmd_return methods succeeds, false otherwise
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

      # List all files from a given folder.
      #
      # @param path [String] absolute path of the folder to be examined.
      # @return [Array] all files in the specified folder.
      def list_files_from_dir(path)
        Dir[path + "/*/"].map { |file| File.basename(file) }
      end

      module_function

      # Method used by the help command in order to explain the aim of this module.
      #
      # @return [String] a string containing the command purpose.
      def helper
        "List all currently available analysis modules."
      end

    end
  end
end
