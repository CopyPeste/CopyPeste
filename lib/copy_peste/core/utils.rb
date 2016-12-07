module CopyPeste
  class Core
    module Utils

      module_function

      # Load a Ruby file which implements CopyPeste module standard
      #
      # @param dir [String] Absolute path of the module to be load.
      # @param file [String] File name of the module to be load.
      # @return [Object] Instance of the loaded module.
      def load_module (dir, file)
        if Module.constants.include?(:CopyPesteModule)
          Object.send(:remove_const, :CopyPesteModule)
        end
        load File.join dir, file
        CopyPesteModule.new
      end

    end
  end
end
