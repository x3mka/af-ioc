module Af
  module Ioc
    class Container

      DEFAULT_CONTAINER_NAME = :default
      DEFAULT_DEP_NAME = :default

      attr_accessor :name

      def initialize(name = DEFAULT_CONTAINER_NAME)
        raise DuplicateContainerError.new("Container '#{name}' already exists.") if self.class.containers.has_key? name
        self.name = name
        self.class.containers[name] = self
      end

      def configure(&block)
        self.instance_eval(&block)
      end

      def register(dependency, value = nil, name: nil, &block)
        name ||= DEFAULT_DEP_NAME
        registry_map[dependency] ||= {}
        registry_map[dependency][name] = ContainerItem.new(self, dependency, value || block)
        self
      end

      def registry_map
        @registry_map ||= {}
      end

      def resolve(dependency, name: nil)
        name ||= DEFAULT_DEP_NAME
        bucket = registry_map[dependency]
        raise ResolutionError.new("Dependency '#{dependency}' is not registered in '#{self.name}' container") if bucket.nil? || bucket.size == 0
        container_item = bucket[name]
        raise ResolutionError.new("Dependency '#{dependency}' with name #{name} is not registered in '#{self.name}' container") if container_item.nil?
        container_item.instance
      end

      def resolve_all(dependency)
        bucket = registry_map[dependency]
        raise ResolutionError.new("Dependency '#{dependency}' is not registered in '#{self.name}' container") if bucket.nil? || bucket.size == 0
        bucket.keys.map do |name|
          resolve dependency, name: name
        end
      end

      def clear
        registry_map.clear
      end

      class << self

        def containers
          @@containers ||= {}
        end

        def default_container
          self.containers[DEFAULT_CONTAINER_NAME]
        end

        def container(name)
          raise ContainerNotFound.new unless self.containers.has_key?(name)
          self.containers[name]
        end

        def [](name)
          self.containers[name]
        end

        def containers_count
          self.containers.size
        end

        def configure(options = {}, &block)
          container_name = options[:container] || DEFAULT_CONTAINER_NAME
          container(container_name).configure(&block)
        end

        def register(dependency, value = nil, options = {}, &block)
          container_name = options[:container] || DEFAULT_CONTAINER_NAME
          self.new(container_name) unless self.containers.has_key?(container_name)
          container(container_name).register(dependency, value, name: options[:name], &block)
        end

        def resolve(dependency, options = {})
          container_name = options[:container] || DEFAULT_CONTAINER_NAME
          container(container_name).resolve(dependency, name: options[:name])
        end

        def resolve_all(dependency, options = {})
          container_name = options[:container] || DEFAULT_CONTAINER_NAME
          container(container_name).resolve_all(dependency)
        end

        def clear(options = {})
          container_name = options[:container] || DEFAULT_CONTAINER_NAME
          container(container_name).clear
        end

        def reset
          self.containers.clear
        end

      end

    end
  end
end
