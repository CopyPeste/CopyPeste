module CopyPeste
  class Core
    module Utils

      module_function

      # Trigger the call of method defined by 'with' on defined object 'on'
      # with parameter the child that inherited defined 'baseclass'.
      #
      # @param callback [Symbol] callback triggering
      # @param on [Class] baseclass to watch callback on
      # @param to [Object] target object
      # @param with [Symbol] target object's method name
      def hook_method(callback, on:, to:, with:)
        hook = Module.new
        hook.send(:define_method, callback) { |child|
          super child
          to.send with, child
        }

        on.extend hook
        nil
      end

      # List all files from a given folder.
      #
      # @param path [String] absolute path of the folder to be examined.
      # @return [Array] all files in the specified folder.
      def list_files_from_dir(path)
        Dir[path + "/*/"].map { |file| File.basename(file) }
      end

    end
  end
end
