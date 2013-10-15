Time::DATE_FORMATS[:cenzo] = lambda { |date| date.strftime("%B #{date.day.ordinalize}, %Y - %I:%M %p") }
Date::DATE_FORMATS[:cenzo] = lambda { |date| date.strftime("%B #{date.day.ordinalize}, %Y - %I:%M %p") }
