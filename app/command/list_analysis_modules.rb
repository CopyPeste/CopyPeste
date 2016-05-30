class Command
  module ListAnalysisModules
    def run
      files = list_files_from_dir(
        CpRequire.base_path + @core_state.conf['modules']['analysis']['dir']
      )
      available_analysis_mods = []
      files.each do |mod|
        available_analysis_mods.push(File.basename(mod))
      end

      @graph_com.cmd_return(@cmd, available_analysis_mods, false)
    end

    def init; end
  end
end
