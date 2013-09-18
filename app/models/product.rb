class Product < ActiveRecord::Base
  include Concerns::ReportingRecord
  attr_accessible :name,
                    :price,
                    :description,
                    :tag_line,
                    :start_time,
                    :end_time,
                    :ship_date,
                    :credited,
                    :video_url,
                    :created_ts,
                    :updated_ts

  def ready?
    return true
  end

  def active?
    return true
  end
end
