# frozen_string_literal: true

require 'spec_helper'
require 'sales_taxes'

RSpec.describe SalesTaxes::BasicTaxRule do
  subject(:tax_rule) { described_class.new }

  describe '#applicable?' do
    context 'with exempt categories' do
      it 'returns false for books' do
        product = SalesTaxes::Product.new(
          name: 'book',
          net_price: BigDecimal('12.49'),
          category: :book,
          imported: false
        )

        expect(tax_rule.applicable?(product)).to be false
      end

      it 'returns false for food' do
        product = SalesTaxes::Product.new(
          name: 'chocolate bar',
          net_price: BigDecimal('0.85'),
          category: :food,
          imported: false
        )

        expect(tax_rule.applicable?(product)).to be false
      end

      it 'returns false for medical products' do
        product = SalesTaxes::Product.new(
          name: 'packet of headache pills',
          net_price: BigDecimal('9.75'),
          category: :medical,
          imported: false
        )

        expect(tax_rule.applicable?(product)).to be false
      end
    end

    context 'with non-exempt categories' do
      it 'returns true for other products' do
        product = SalesTaxes::Product.new(
          name: 'music CD',
          net_price: BigDecimal('14.99'),
          category: :other,
          imported: false
        )

        expect(tax_rule.applicable?(product)).to be true
      end

      it 'returns true for perfume' do
        product = SalesTaxes::Product.new(
          name: 'bottle of perfume',
          net_price: BigDecimal('18.99'),
          category: :other,
          imported: false
        )

        expect(tax_rule.applicable?(product)).to be true
      end
    end

    context 'with imported products' do
      it 'still exempts books even if imported' do
        product = SalesTaxes::Product.new(
          name: 'imported book',
          net_price: BigDecimal('12.49'),
          category: :book,
          imported: true
        )

        expect(tax_rule.applicable?(product)).to be false
      end

      it 'still applies to non-exempt imported products' do
        product = SalesTaxes::Product.new(
          name: 'imported bottle of perfume',
          net_price: BigDecimal('47.50'),
          category: :other,
          imported: true
        )

        expect(tax_rule.applicable?(product)).to be true
      end
    end
  end

  describe '#rate' do
    it 'returns 10% as BigDecimal' do
      expect(tax_rule.rate).to eq(BigDecimal('0.10'))
    end
  end

  describe 'constants' do
    it 'defines exempt categories' do
      expect(described_class::EXEMPT).to eq(%i[book food medical])
    end
  end
end