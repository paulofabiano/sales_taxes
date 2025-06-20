# frozen_string_literal: true

require_relative 'tax_rule'

module SalesTaxes
  class BasicTaxRule < TaxRule
    EXEMPT = %i[book food medical].freeze
    def applicable?(product) = !EXEMPT.include?(product.category)
    def rate = 0.10.to_d
  end
end
