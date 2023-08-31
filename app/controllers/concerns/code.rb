module Code
  extend ActiveSupport::Concern

  private

  def generate_unique_code
    loop do 
      timestamp = Time.now.strftime('%Y%m%d%H%M%S')
      random_number = SecureRandom.random_number(10000)
      unique_code = "#{timestamp}-#{random_number}"

      return unique_code unless InvoiceProduct.exists?(code: unique_code)
    end
  end
end