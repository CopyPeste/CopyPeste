require_relative '../modules.rb'

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

          module_instantiation(modules_base.get_graphics_classes, :graphics)
          module_instantiation(modules_base.get_analysis_classes, :analysis)
      end

      # Instantiate a given module
      #
      # @param mod_classes [hash] hash containing modules classes
      # @param type [symbol] module type
      def module_instantiation(mod_classes, type)
        mod_classes.each do |mod|
          begin
            @modules_list[type][mod.first] = mod.last.new
          rescue
            puts "[Warning] Module not loaded. #{mod.first} is badly formatted. ".yellow
          end
        end
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
