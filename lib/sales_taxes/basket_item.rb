# frozen_string_literal: true

module SalesTaxes
  class BasketItem
    attr_reader :quantity, :product, :sales_tax, :total_price

    def initialize(quantity:, product:, calculator: TaxCalculator.new)
      @quantity    = quantity
      @product     = product
      @sales_tax   = calculator.tax_for(product) * quantity
      @total_price = (product.net_price * quantity) + @sales_tax
      freeze
    end
  end
end
