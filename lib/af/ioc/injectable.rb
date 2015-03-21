module Af
  module Ioc
    module Injectable

      def self.included(base)
        base.class_eval do
          class << self
            attr_accessor :__injectable_dependencies
          end
        end
        base.__injectable_dependencies ||= {}

        base.extend ClassMethods


      end

      module ClassMethods

        def inherited(subclass) # :nodoc:
          attribute = :__injectable_dependencies
          instance_var = "@#{attribute}"
          subclass.instance_variable_set(instance_var, instance_variable_get(instance_var))
          super
        end



        def attr_resolve(attr, dependency, options = {})
          generate_writer attr
          generate_resolve_reader(attr, dependency, options)
        end

        def attr_resolve_all(attr, dependency, options = {})
          generate_writer attr
          generate_resolve_all_reader(attr, dependency, options)
        end

        private

        def generate_writer(attr)
          define_method("#{attr}=") do |value|
            self.class.__injectable_dependencies[attr] = value
          end
        end

        def generate_resolve_reader(attr, dependency, options = {})
          opts = options.slice :container, :name

          define_method(attr) do
            self.class.__injectable_dependencies[attr] ||= Af::Ioc.resolve(dependency, opts)
          end
        end

        def generate_resolve_all_reader(attr, dependency, options = {})
          opts = options.slice :container, :name

          define_method(attr) do
            self.class.__injectable_dependencies[attr] ||= Af::Ioc.resolve_all(dependency, opts)
          end
        end


      end

    end
  end
end
