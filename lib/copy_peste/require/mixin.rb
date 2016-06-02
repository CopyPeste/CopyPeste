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
        #   - There's one caveat: (cf. @example) if /a/b doesn't exist,
        #   /a/b.rb won't be required and the call will result into an error.
        #   This has been made on purpose but it might change in the future.
        # @example
        #   Directory structure:
        #     |- a
        #       |- b
        #       | |- c.rb
        #       | `- d.rb
        #       `- b.rb
        #
        #   Code:
        #     module A
        #       include CopyPeste::Require::Mixin
        #     end
        #
        #     CopyPeste::Require::A::B
        #     # will require the file /a/b.rb on the first call only
        #
        #     CopyPeste::Require::A::B('c')
        #     # will require the file /a/b/c.rb
        #     # if the namespace B wasn't defined, it also requires /a/b.rb
        #
        #     CopyPeste::Require::A::B('c', 'd')
        #     # will require the file /a/b/c.rb and /a/b/d.rb
        #     # if the namespace B wasn't defined, it also requires /a/b.rb
        #
        def const_missing(constant)
          constant_name = constant.to_s.underscore
          dir_path = File.expand_path(namespace_path + '/' + constant_name)

          # if the directory exists, we can do something
          if Dir.exists? dir_path

            # We create the constant, before even checking/requiring if there's
            # a file that could be the entry point of the namespace to avoid
            # diamond dependancies.
            constant = self.const_set constant, Module.new.include(Mixin)

            # Let's require the entry point of the namespace if it exist.
            require dir_path if File.exists? dir_path + '.rb'

            # And then return the new fresh constant
            constant

          else super
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

        # @see .const_missing example
        #
        def method_missing(meth, *args, &blk)

          # if we have a constant matching the method name,
          # we have a directory representing an existing namespace.
          # Let's work with it so.
          constant = self.const_get meth
          args.map do |file|
            require File.expand_path(constant.namespace_path + '/' + file)
          end

          # Otherwise, not our concern :)
        rescue NameError
          super
        end
      end # !ClassMethods
    end # !Mixin
  end
end
