# frozen_string_literal: true

module SalesTaxes
  # TaxRule interface
  class TaxRule
    # Returns true if this rule applies to the given product
    def applicable?(_product) = raise NotImplementedError

    # Returns a decimal rate, e.g. 0.10 == 10 %
    def rate = raise NotImplementedError
  end
end
