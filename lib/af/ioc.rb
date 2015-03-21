require "af/ioc/version"

require 'active_support/core_ext/hash/slice'

require_relative 'ioc/container_item'
require_relative 'ioc/container'
require_relative 'ioc/injectable'

module Af
  module Ioc

    class ContainerNotFound < StandardError; end
    class DuplicateContainerError < StandardError; end
    class ResolutionError < StandardError; end

    class << self
      extend ::Forwardable

      def_delegators Container, :configure, :register, :resolve, :resolve_all, :clear, :reset
    end

  end
end


