module DecimalCoin
  extend ActiveSupport::Concern

  included do
    include ActionView::Helpers::NumberHelper
  end

  private

  def format_to_decimal(value)
    "R$ #{number_with_precision(value, precision: 2, delimiter: '.', separator: ',')}"
  end
end
