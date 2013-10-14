namespace :refund do

  desc "Give credit for product. USAGE rake refund:create PRODUCT_ID='2'"
  task :create => :environment do
    product = Product.where(:id => ENV['PRODUCT_ID']).first
    if product
      if !product.credited
        tiers = product.discount_tiers.all(:order => 'tier_number DESC')
        order_products = product.order_products.all(:order => 'created_ts')
        tier_product_discounts = []
        products_discounted = 0
        tiers.each do |tier|
          tier_discounts = ((tier.percent / 100.0 * order_products.length).ceil / 2.0).ceil * 2
          if tier.tier_number == 0 || tier_discounts + products_discounted > order_products.length
            tier_discounts = order_products.length - products_discounted
          end
          products_discounted += tier_discounts
          tier_product_discounts.push(tier_discounts)
        end
        on_tier = 0
        games_up_to_tier = tier_product_discounts[0] / 2
        products_discounted = 0
        all_discounted = 0
        credits_created = 0
        total_credited = 0
        order_products.each do |order_product|
          if products_discounted >= games_up_to_tier
            random_discount = tier_product_discounts[on_tier] / 2
            while random_discount > 0 && all_discounted < order_products.length
              op = order_products.sample
              if op.time_tier == 0 && op.random_tier == 0
                op.update_attributes(:random_tier => (4 - on_tier))
                if tiers[on_tier].discount > 0
                  Credit.create :user_id => op.user_id,
                                :order_id => op.order_id,
                                :order_product_id => op.id,
                                :product_id => op.product_id,
                                :credit => tiers[on_tier].discount
                  credits_created += 1
                  total_credited += tiers[on_tier].discount
                end
                random_discount -= 1
                all_discounted += 1
              end
            end
            on_tier += 1
            on_tier = 4 if on_tier > 4
            games_up_to_tier += (tier_product_discounts[on_tier] / 2)
          end
          if order_product.random_tier == 0
            order_product.update_attributes(:time_tier => (4 - on_tier))
            if tiers[on_tier].discount > 0
              Credit.create :user_id => order_product.user_id,
                            :order_id => order_product.order_id,
                            :order_product_id => order_product.id,
                            :product_id => order_product.product_id,
                            :credit => tiers[on_tier].discount
              credits_created += 1
              total_credited += tiers[on_tier].discount
            end
            products_discounted += 1
            all_discounted += 1
          end
        end
        puts "Total games credited: " + credits_created.to_s
        puts "Credit given: " + total_credited.to_s
        credits = product.credits
        credits.each do |credit|
          order = credit.order
          order_refund = OrderRefund.where(:order_id => order.id, :product_id => product.id).first
          if order_refund
            refund_amount_cents = order_refund.refund_amount_cents
            refund_amount_cents += (credit.credit * 100)
            order_refund.update_attributes(:refund_amount_cents => refund_amount_cents)
          else
            OrderRefund.create! :order_id => order.id,
                                :product_id => product.id,
                                :refund_amount_cents => (credit.credit * 100)
          end
          product.update_attributes(:credited => true)
        end
      else
        puts "Product is already credited"
      end
    else
      puts "No product with that id"
    end
  end

  desc "Give refunds for product. USAGE rake refund:refund PRODUCT_ID=2"
  task :refund => :environment do
    unrefunded_order_refunds = OrderRefund.where(:product_id => ENV['PRODUCT_ID'], :refunded => false)
    unrefunded_order_refunds.each do |order_refund|
      puts "Updating order refund: " + order_refund.id.to_s
      refund_amount_cents = order_refund.refund_amount_cents
      order = Order.where(:id => order_refund.order_id).first
      Stripe.api_key = Rails.application.config.stripe_api_key
      ch = Stripe::Charge.retrieve(order.stripe_charge_id)
      begin
        ch.refund(:amount => refund_amount_cents.to_i)
        order_refund.update_attributes(:refunded => true)
      rescue
        puts "Error: refund did not go through"
      end
    end
  end
end
