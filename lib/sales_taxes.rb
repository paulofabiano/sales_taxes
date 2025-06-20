# frozen_string_literal: true

require 'bigdecimal'
require 'bigdecimal/util'

require_relative 'sales_taxes/tax_calculator'
require_relative 'sales_taxes/product'
require_relative 'sales_taxes/basic_tax_rule'
require_relative 'sales_taxes/import_tax_rule'
require_relative 'sales_taxes/tax_rule'

module SalesTaxes
  VERSION = '0.1.0'
end
