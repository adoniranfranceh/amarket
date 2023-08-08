module NumberUtils
  extend ActiveSupport::Concern

  private

  def format_decimal(value)
    value.to_s.gsub(',', '.').to_f
  end

  def format_decimal_value(model, attribute)
    value = params[model][attribute]
    params[model][attribute] = format_decimal(value)
  end
end
