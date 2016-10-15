module CopyPeste
  class Core
    module Utils

      module_function

      # Load dynamically a Ruby file formatted that implements standards of a
      # CopyPeste module.
      # @param [String] Absolute path of the module to be load.
      # @param [String] File name of the module to be load.
      # @return [Object] Instance of the loaded module.
      def load_module (dir, file)
        loaded_mod = ModuleLoading::Loader.load File.join dir, file
        loaded_mod.__cp_init__
      end

    end
  end
end
