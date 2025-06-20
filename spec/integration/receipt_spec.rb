# frozen_string_literal: true

require 'sales_taxes'

RSpec.describe 'End-to-end receipt' do
  let(:parser) { SalesTaxes::InputParser.new }

  def run_fixture(file_id)
    input  = File.open("spec/fixtures/input_#{file_id}.txt")
    basket = parser.parse(input)
    SalesTaxes::Receipt.new(basket).to_s
  end

  [1, 2, 3].each do |idx|
    it "matches sample basket #{idx}" do
      expected = File.read("spec/fixtures/output_#{idx}.txt")
      expect(run_fixture(idx)).to eq(expected.chomp)
    end
  end
end
