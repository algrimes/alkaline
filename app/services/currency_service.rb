module CurrencyService
  
  def self.aud_to_gbp
    self.convert("AUD", "GBP")
  end
  
  def self.gbp_to_aud
    self.convert("GBP", "AUD")
  end
  
  private 
  
  def self.convert from_currency_code, to_currency_code
    Nokogiri::HTML(open("https://www.google.com/finance/converter?a=1&from=#{from_currency_code}&to=#{to_currency_code}")).css('#currency_converter_result').text
  end
  
end