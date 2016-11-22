module CopyPeste
  class Core
    module Utils

      module_function

      # Dynamically load a Ruby file which implements CopyPeste module standard
      #
      # @param dir [String] Absolute path of the module to be load.
      # @param file [String] File name of the module to be load.
      # @return [Object] Instance of the loaded module.
      def load_module (dir, file)
        loaded_mod = ModuleLoading::Loader.load File.join dir, file
        loaded_mod.__cp_init__
      end

    end
  end
end
