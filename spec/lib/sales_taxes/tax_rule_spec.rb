# frozen_string_literal: true

require 'spec_helper'
require 'sales_taxes'

RSpec.describe SalesTaxes::TaxRule do
  subject(:tax_rule) { described_class.new }

  describe '#applicable?' do
    it 'raises NotImplementedError when called directly' do
      product = double('product')

      expect { tax_rule.applicable?(product) }
        .to raise_error(NotImplementedError)
    end
  end

  describe '#rate' do
    it 'raises NotImplementedError when called directly' do
      expect { tax_rule.rate }
        .to raise_error(NotImplementedError)
    end
  end
end
