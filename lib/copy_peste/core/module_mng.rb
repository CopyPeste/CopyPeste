module CopyPeste
  class Core

    class ModuleMng
      attr_accessor :modules_list

      def initialize
          @modules_list = { :graphics => {}, :analysis => {} }

          modules_base = Core::Modules::Base.new
          Core::Utils.hook_method(:inherited, on: Core::Modules::Analysis, to: modules_base, with: :register_analysis_mod)
          Core::Utils.hook_method(:inherited, on: Core::Modules::Graphics, to: modules_base, with: :register_graphics_mod)

          modules_base.customize

          @modules_list[:graphics] = modules_base.get_graphics_classes
          @modules_list[:analysis] = modules_base.get_analysis_classes
      end

      # Return a choosen instance of a specific module
      #
      # @param mod_name [string] module name to get
      def get mod_name
        if @modules_list[:analysis].has_key? mod_name
          return @modules_list[:analysis][mod_name]

        elsif @modules_list[:graphics].has_key? mod_name
          return @modules_list[:graphics][mod_name]
        end

        nil
      end

    end

  end
end
