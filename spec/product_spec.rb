# frozen_string_literal: true

require 'sales_taxes'

RSpec.describe SalesTaxes::Product do
  let(:product) do
    described_class.new(
      name: 'imported bottle of perfume',
      net_price: '27.99',
      category: :other,
      imported: true
    )
  end

  describe 'attributes' do
    it 'exposes the data exactly as given' do
      expect(product.name).to        eq('imported bottle of perfume')
      expect(product.net_price).to   eq(BigDecimal('27.99'))
      expect(product.category).to    eq(:other)
      expect(product.imported).to    be true
    end

    it 'stores price as BigDecimal (two-decimal precision preserved)' do
      expect(product.net_price).to be_a(BigDecimal)
      expect(product.net_price.to_s('F')).to eq('27.99')
    end
  end

  describe 'immutability' do
    it 'is frozen' do
      expect(product).to be_frozen
    end

    it 'freezes individual attributes too' do
      expect(product.name).to     be_frozen
      expect(product.category).to be_frozen
    end

    it 'raises when you try to mutate' do
      expect { product.instance_variable_set(:@name, 'hack') }
        .to raise_error(FrozenError)
    end
  end
end
