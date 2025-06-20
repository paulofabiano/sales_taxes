# frozen_string_literal: true

require 'forwardable'

module SalesTaxes
  class Basket
    include Enumerable
    extend Forwardable

    def_delegators :@items, :each, :empty?

    def initialize
      @items  = []
      @sealed = false
    end

    def <<(item)
      raise FrozenError, 'Basket already finalised' if @sealed

      @items << item
    end

    def freeze
      return self if frozen?

      @sealed = true
      @items.freeze
      super
    end
  end
end
