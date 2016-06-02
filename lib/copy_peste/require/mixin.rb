module CopyPeste
  module Require
    module Mixin
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods

        # @note
        #   - Only the first call of a namespace will require the
        #   associated file.
        #   - If there is not a file named as the folder, it is not working.
        # @example
        #   Directory structure:
        #     |- a
        #       |- b
        #       | |- c
        #       | | |-d
        #       | | | `- e.rb
        #       | | `- d.rb
        #       | |- c.rb
        #       `- g.rb
        #
        #   Code:
        #     module A
        #       include CopyPeste::Require::Mixin
        #     end
        #
        #     A::B
        #     # will require the file /a/b.rb on the first call only
        #
        #     A::B::C::D::E
        #     # will require the files /a/b/c.rb, /a/b/c/d.rb, /a/b/c/d/e.rb
        #
        def const_missing(constant)
          constant_name = constant.to_s.underscore
          constant_declaration_path = File.expand_path(
            File.join namespace_path, constant_name
          )

          # If the file is available in the folder of the namespace,
          # it means it belongs to it.
          if File.exists? constant_declaration_path + '.rb'
            require constant_declaration_path
            if self.const_defined? constant
              constant = self.const_get constant
              constant.include Require::Mixin
              constant

            else super
            end

          # If there isn't a file matching, the constant might belong to
          # one namespace over it.
          elsif outer = Module.nesting.find { |n| name.include_different? n.name }
            outer.const_get constant

          # Otherwise, that's not our concern.
          else
            super
          end
        end

        # Generate the path of the namespace, called recursively
        # over each outer namespace
        # @return [String]
        #
        def namespace_path
          local_namespace, outer_namespace =
            self.name.reverse.split('::', 2).map(&:reverse)

          outer_constant = Kernel.const_get outer_namespace
          outer_path = outer_constant.namespace_path

          local_path = '/' + local_namespace.underscore

          outer_path + local_path
        end
      end # !ClassMethods
    end # !Mixin
  end
end
