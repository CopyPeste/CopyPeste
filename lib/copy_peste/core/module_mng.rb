require_relative '../modules.rb'

module CopyPeste
  class Core

    class ModuleMng
      attr_accessor :modules_list

      def initialize
          @modules_list = { :graphics => {}, :analysis => {} }

          modules_base = Core::Modules::Base.new
          Core::Utils.hook_method(:inherited, on: Core::Modules::Analysis, to: modules_base, with: :register_mod_type)
          Core::Utils.hook_method(:inherited, on: Core::Modules::Graphics, to: modules_base, with: :register_mod_type)

          modules_base.customize

          graphics_mod_classes = modules_base.get_graphics_classes
          graphics_mod_classes.each do |mod|
            begin
              @modules_list[:graphics][mod.first] = mod.last.new
            rescue
              puts "Badly formatted"
            end
          end

          analysis_mod_classes = modules_base.get_analysis_classes
          analysis_mod_classes.each do |mod|
            begin
              @modules_list[:analysis][mod.first] = mod.last.new
            rescue
              puts "Badly formatted"
            end
          end
      end

      def get name
        if @modules_list[:analysis].has_key? name
          return @modules_list[:analysis][name]
        elsif @modules_list[:graphics].has_key? name
          return @modules_list[:graphics][name]
        end
        nil
      end

    end

  end
end
