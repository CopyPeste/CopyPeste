module CopyPeste
  class Core
    module Utils

      module_function

      def load_module (dir, file)
        loaded_mod = ModuleLoading::Loader.load File.join dir, file
        loaded_mod.__cp_init__
      end

    end
  end
end
