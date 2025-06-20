# frozen_string_literal: true

require 'sales_taxes'

RSpec.describe 'Thread safety smoke test' do
  let(:input)  { File.open('spec/fixtures/input_3.txt') }
  let(:parser) { SalesTaxes::InputParser.new }

  it 'produces identical receipts from multiple threads' do
    expected = parser.parse(input).tap(&:freeze)
    threads  = 10.times.map do
      Thread.new do
        basket = parser.parse(File.open('spec/fixtures/input_3.txt'))
        SalesTaxes::Receipt.new(basket).to_s
      end
    end
    outputs = threads.map(&:value).uniq
    expect(outputs.size).to eq(1) # all threads produced the same string
    expect(outputs.first).to eq(SalesTaxes::Receipt.new(expected).to_s)
  end
end
