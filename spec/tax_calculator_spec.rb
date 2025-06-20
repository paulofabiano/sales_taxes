# frozen_string_literal: true

require 'sales_taxes'

RSpec.describe SalesTaxes::TaxCalculator do
  let(:calculator) { described_class.new }

  def product(price:, category:, imported: false)
    SalesTaxes::Product.new(
      name: 'stub',
      net_price: price,
      category: category,
      imported: imported
    )
  end

  context 'with exempt goods (book, food, medical) with no import duty' do
    it 'returns zero tax' do
      %i[book food medical].each do |cat|
        tax = calculator.tax_for(product(price: '12.00', category: cat))
        expect(tax).to eq(BigDecimal('0.00'))
      end
    end
  end

  context 'with non-exempt, domestic good' do
    it 'applies the 10 % basic tax and rounds up to nearest 0.05' do
      camera = product(price: '14.99', category: :other)
      expect(calculator.tax_for(camera)).to eq(BigDecimal('1.50'))
    end
  end

  context 'with exempt but imported good' do
    it 'applies the 5 % import duty only' do
      chocs = product(price: '10.00', category: :food, imported: true)
      expect(calculator.tax_for(chocs)).to eq(BigDecimal('0.50'))
    end
  end

  context 'with non-exempt and imported good' do
    it 'adds basic (10 %) + import (5 %) and rounds up' do
      perfume = product(price: '47.50', category: :other, imported: true)
      expect(calculator.tax_for(perfume)).to eq(BigDecimal('7.15'))
    end
  end

  context 'with rounding edge case' do
    it 'when rounds 1.13 to 1.15 after tax calculation' do
      dummy = product(price: '11.30', category: :other)
      expect(calculator.tax_for(dummy)).to eq(BigDecimal('1.15'))
    end
  end

  context 'when an empty rule set injected' do
    it 'returns zero regardless of product' do
      blank_calc = described_class.new([])
      item       = product(price: '99.99', category: :other, imported: true)
      expect(blank_calc.tax_for(item)).to eq(BigDecimal('0.00'))
    end
  end
end
