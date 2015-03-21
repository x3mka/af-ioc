module Af
  module Ioc
    class ContainerItem

      attr_reader :container, :key, :value

      def initialize(container, key, value)
        @container = container
        @key = key
        @value = value
      end

      def instance
        if value.is_a? Proc
          if value.arity == 1
            value.call(container)
          else
            value.call
          end
        else
          value
        end
      end

    end
  end
end