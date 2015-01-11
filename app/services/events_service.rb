module EventsService

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

end
