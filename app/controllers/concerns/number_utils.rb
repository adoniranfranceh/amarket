module NumberUtils
  extend ActiveSupport::Concern

  private

  def format_decimal(value)
    value.gsub('.','').gsub(',','.').to_f
  end

  def format_decimal_value(model, attribute)
    model[attribute] = format_decimal(model[attribute])
  end
end
