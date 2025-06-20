# frozen_string_literal: true

require 'spec_helper'
require 'sales_taxes'

RSpec.describe SalesTaxes::ImportTaxRule do
  subject(:tax_rule) { described_class.new }

  describe '#applicable?' do
    context 'with imported products' do
      it 'returns true for imported books' do
        product = SalesTaxes::Product.new(
          name: 'imported book',
          net_price: BigDecimal('12.49'),
          category: :book,
          imported: true
        )

        expect(tax_rule.applicable?(product)).to be true
      end

      it 'returns true for imported food' do
        product = SalesTaxes::Product.new(
          name: 'imported box of chocolates',
          net_price: BigDecimal('10.00'),
          category: :food,
          imported: true
        )

        expect(tax_rule.applicable?(product)).to be true
      end

      it 'returns true for imported medical products' do
        product = SalesTaxes::Product.new(
          name: 'imported headache pills',
          net_price: BigDecimal('9.75'),
          category: :medical,
          imported: true
        )

        expect(tax_rule.applicable?(product)).to be true
      end

      it 'returns true for imported other products' do
        product = SalesTaxes::Product.new(
          name: 'imported bottle of perfume',
          net_price: BigDecimal('47.50'),
          category: :other,
          imported: true
        )

        expect(tax_rule.applicable?(product)).to be true
      end
    end

    context 'with domestic products' do
      it 'returns false for domestic books' do
        product = SalesTaxes::Product.new(
          name: 'book',
          net_price: BigDecimal('12.49'),
          category: :book,
          imported: false
        )

        expect(tax_rule.applicable?(product)).to be false
      end

      it 'returns false for domestic food' do
        product = SalesTaxes::Product.new(
          name: 'chocolate bar',
          net_price: BigDecimal('0.85'),
          category: :food,
          imported: false
        )

        expect(tax_rule.applicable?(product)).to be false
      end

      it 'returns false for domestic medical products' do
        product = SalesTaxes::Product.new(
          name: 'packet of headache pills',
          net_price: BigDecimal('9.75'),
          category: :medical,
          imported: false
        )

        expect(tax_rule.applicable?(product)).to be false
      end

      it 'returns false for domestic other products' do
        product = SalesTaxes::Product.new(
          name: 'music CD',
          net_price: BigDecimal('14.99'),
          category: :other,
          imported: false
        )

        expect(tax_rule.applicable?(product)).to be false
      end
    end
  end

  describe '#rate' do
    it 'returns 5% as BigDecimal' do
      expect(tax_rule.rate).to eq(BigDecimal('0.05'))
    end
  end
end