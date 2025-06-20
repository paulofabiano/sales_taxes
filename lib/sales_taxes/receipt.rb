# frozen_string_literal: true

module SalesTaxes
  # Renders a frozen Basket into the exact text required by the kata
  # (same line order, two-decimal prices).
  class Receipt
    def initialize(basket) = @basket = basket

    # Full receipt string, lines joined with \n (no trailing newline).
    #
    # @return [String]
    def to_s
      lines = @basket.map { |item| line_for(item) }
      lines << "Sales Taxes: #{fmt(sales_taxes)}"
      lines << "Total: #{fmt(total)}"
      lines.join("\n")
    end

    private

    def line_for(item)
      "#{item.quantity} #{item.product.name}: #{fmt(item.total_price)}"
    end

    def sales_taxes = sum(:sales_tax)
    def total       = sum(:total_price)

    def sum(attr)
      @basket.sum { |item| item.public_send(attr) }
    end

    def fmt(amount)
      format('%.2f', amount)
    end
  end
end
