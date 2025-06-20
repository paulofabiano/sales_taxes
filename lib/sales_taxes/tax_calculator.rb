# frozen_string_literal: true

require 'bigdecimal'
require 'bigdecimal/util'

module SalesTaxes
  class TaxCalculator
    ROUND_FACTOR = 0.05.to_d.freeze

    def initialize(rules = [BasicTaxRule.new, ImportTaxRule.new])
      @rules = rules.freeze
    end

    def tax_for(product)
      sum = @rules
            .select { |rule| rule.applicable?(product) }
            .sum    { |rule| product.net_price * rule.rate }
      round_up(sum)
    end

    private

    # Ceil to next 0.05, keep 2 decimals
    def round_up(amount)
      ((amount / ROUND_FACTOR).ceil * ROUND_FACTOR).truncate(2)
    end
  end
end
