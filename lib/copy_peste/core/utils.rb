CpRequire.libs 'app/dynamic_loading/module_loader.rb'

def load_module (dir, file)
  path = CpRequire.base_path + dir + file
  loaded_mod = ModuleLoading::Loader.load path
  loaded_mod.__cp_init__
end

def list_files_from_dir path
  brut_files_list = Dir[path + "/*/"]
  files = []
  brut_files_list.each do |mod|
    files.push(File.basename(mod))
  end
  files
end