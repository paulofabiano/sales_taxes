require_relative "../lib/sales_taxes/tax_calculator"

RSpec.describe SalesTaxes::TaxCalculator do
  subject(:calc) { described_class.new }

  it "rounds up to the nearest 0.05" do
    expect(calc.send(:round_up, BigDecimal("1.13"))).to eq(BigDecimal("1.15"))
    expect(calc.send(:round_up, BigDecimal("1.10"))).to eq(BigDecimal("1.10"))
  end
end
