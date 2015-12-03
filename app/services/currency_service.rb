module CurrencyService
  
  require 'thread'
  
  def self.aud_to_gbp
    @aud_gbp_conversion
  end
  
  def self.gbp_to_aud
    @gbp_aud_conversion
  end
  
  private 

  def self.update from_currency_code, to_currency_code
    Nokogiri::HTML(open("https://www.google.com/finance/converter?a=1&from=#{from_currency_code}&to=#{to_currency_code}")).css('#currency_converter_result').text
  end
  
  mutex = Mutex.new
  
  Thread.new do
    loop do
      mutex.synchronize do
        @gbp_aud_conversion = self.update("GBP", "AUD")
        @aud_gbp_conversion = self.update("AUD", "GBP")
        sleep 30
      end
    end
  end
  
  @gbp_aud_conversion = self.update("GBP", "AUD")
  @aud_gbp_conversion = self.update("AUD", "GBP")
  
end