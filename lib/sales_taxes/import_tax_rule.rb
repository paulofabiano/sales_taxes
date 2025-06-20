# frozen_string_literal: true

require_relative 'tax_rule'

module SalesTaxes
  class ImportTaxRule < TaxRule
    def applicable?(product) = product.imported
    def rate = 0.05.to_d
  end
end
