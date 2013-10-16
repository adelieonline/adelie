Time::DATE_FORMATS[:cenzo] = lambda { |date| date.strftime("%B #{date.day.ordinalize}, %Y - %I:%M %p") }
Date::DATE_FORMATS[:cenzo] = lambda { |date| date.strftime("%B #{date.day.ordinalize}, %Y - %I:%M %p") }

Time::DATE_FORMATS[:cenzo_no_time] = lambda { |date| date.strftime("%B #{date.day.ordinalize}, %Y") }
Date::DATE_FORMATS[:cenzo_no_time] = lambda { |date| date.strftime("%B #{date.day.ordinalize}, %Y") }
