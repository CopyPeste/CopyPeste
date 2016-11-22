module CopyPeste
  module ModuleLoading
    class Loader

      # Turns a source file of an analysis module into an usable object
      #
      # @param path [String] source file path
      # @return [LoadedModule] the module created from a source file
      def self.load(path)
        @@loading_module = LoadedModule.new
        self.instance_eval(File.read path)

        required_methods = DSLMethods.instance_methods
        implemented_methods = @@loading_module.singleton_methods
        raise NotImplementedError unless required_methods.all? { |rm|
          implemented_methods.include? self.naming_pattern(rm).to_sym
        }

        loaded_module = @@loading_module
        loaded_module
      end

      #
      #
      # @param meth [String]
      # @param args [Array]
      # @param blk [Block]
      def self.method_missing(meth, *args, &blk)
        self.new(meth).instance_eval &blk if block_given?
      end

      private

      #
      #
      # @param args [Array]
      def self.new(*args)
        super(*args)
      end

      #
      #
      # @param name [String]
      def initialize(name)
        set_name { name }
        self
      end

      #
      #
      # @param block [Block]
      def set_impl(&block)
        @@loading_module.extend Module.new(&block)
      end

      #
      #
      # @param basename [String]
      def self.naming_pattern(basename)
        "__cp_#{basename}__"
      end

      #
      #
      # @param meth
      # @param args [Array]
      # @param block [Block]
      def method_missing(meth, *args, &block)
        meth_basename = meth.to_s.match(/^set_(.*)/)
        return super(meth, *args, &block) if meth_basename.nil?
        meth_basename = meth_basename.captures.first
        @@loading_module.define_singleton_method(self.class.naming_pattern(meth_basename), &block)
      end

      module DSLMethods
        def usage(&block) set_usage(&block) end
        def author(&block) set_author(&block) end
        def init(&block) set_init(&block) end
        def description(&block) set_description(&block) end
      end # !DSLMethods

      module DSLBlocks
        def impl(&block) set_impl(&block) end
      end # !DSLBlocks

      include DSLMethods, DSLBlocks
    end

    class LoadedModule; end
  end
end
