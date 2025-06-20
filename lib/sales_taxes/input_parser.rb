# frozen_string_literal: true

module SalesTaxes
  # Translates raw text (file or STDIN) into a populated Basket.
  class InputParser
    LINE_RE = /
      ^(?<qty>\d+)\s
      (?<imported>imported\s)?
      (?<name>.+?)\s
      at\s
      (?<price>\d+\.\d{2})
    /x # keep frozen

    def parse(io)
      basket = Basket.new
      io.each_line(chomp: true) do |line|
        md = LINE_RE.match(line) or raise ArgumentError, "Bad line: #{line}"
        basket << create_basket_item(md)
      end
      basket.freeze
    end

    private

    def create_basket_item(match_data)
      product = create_product(match_data)
      BasketItem.new(
        quantity: match_data[:qty].to_i,
        product: product
      )
    end

    def create_product(match_data)
      full_name = "#{match_data[:imported]}#{match_data[:name]}".strip
      imported = !match_data[:imported].nil?
      category = infer_category(match_data[:name])

      Product.new(
        name: full_name,
        net_price: match_data[:price],
        category: category,
        imported: imported
      )
    end

    # Naive keyword mapping is good enough for the kata rules
    def infer_category(name)
      case name
      when /book/i      then :book
      when /chocolate/i then :food
      when /pill/i      then :medical
      else                   :other
      end
    end
  end
end
