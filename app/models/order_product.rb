class OrderProduct < ActiveRecord::Base
  include Concerns::ReportingRecord

  attr_accessible :order_id,
                  :product_id,
                  :time_tier,
                  :random_tier,
                  :place_in_line,
                  :created_ts,
                  :updated_ts,
                  :user_id,
                  :console_id

  belongs_to :order
  belongs_to :product

  def experience_level
    if self.product.is_active?
      start_of_tier = 1
      end_of_tier = 0
      level = 0
      self.product.discount_tiers.order('tier_number DESC').each do |discount_tier|
        if discount_tier.tier_number == 0
          tier_length = self.product.num_orders - end_of_tier
          place_in_tier = self.place_in_line - end_of_tier
          percent_to_level = 100 - (place_in_tier.to_f / tier_length.to_f * 100)
          return [level, percent_to_level]
        end
        end_of_tier += ((discount_tier.percent / 2) / 100 * self.product.num_orders).ceil
        if self.place_in_line > end_of_tier
          start_of_tier = end_of_tier
        else
          level = discount_tier.tier_number
          if level == 4
            return [level, 100.0]
          end
          tier_length = end_of_tier - start_of_tier
          place_in_tier = self.place_in_line - start_of_tier
          percent_to_level = 100 - (place_in_tier.to_f / tier_length.to_f * 100)
          return [level, percent_to_level]
        end
      end
    end
    return []
  end
end
