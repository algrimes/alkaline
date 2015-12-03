module EventsService
  
  require 'thread'

  def self.today
    TimeoutMelTodayPage.new(Nokogiri::HTML(open("http://www.au.timeout.com/melbourne/events?date=today"))).events
  end
  
  class TimeoutMelTodayPage
    def initialize page
      @page = page
    end
    
    def events
      @page.css('#mainContent article')
    end
    
  end
  
  private 
  
  def self.update
    latest = TimeoutMelTodayPage.new(Nokogiri::HTML(open("http://www.au.timeout.com/melbourne/events?date=today"))).events
  end
  
  mutex = Mutex.new
  
  Thread.new do
    loop do
      mutex.synchronize do
        latest = self.update
        sleep 400
      end
    end
  end
  
  latest = self.update

end
