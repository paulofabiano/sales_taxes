# frozen_string_literal: true

module SalesTaxes
  class Product
    attr_reader :name, :net_price, :category, :imported

    def initialize(name:, net_price:, category:, imported: false)
      @name      = name.freeze
      @net_price = BigDecimal(net_price, 4).freeze
      @category  = category.freeze
      @imported  = imported.freeze
      freeze
    end
  end
end