require 'paypal-sdk-rest'
include PayPal::SDK::REST

namespace :refund do
  desc "Give all credits refunds"
  task :all => :environment do
    unrefunded_order_refunds = OrderRefund.where(:paypal_refund_id => nil)
    unrefunded_order_refunds.each do |order_refund|
      puts "Updating order refund: " + order_refund.id.to_s
      refund_amount = order_refund.refund_amount
      order = Order.where(:id => order_refund.order_id).first
      sale = Sale.find(order.paypal_payment_id)
      refund_json = {:amount => {:currency => "USD", :total => "%.2f" % refund_amount}}
      refund = sale.refund(refund_json)
      puts JSON.dump(refund)
      if refund.id.present?
        order_refund.update_attributes(:paypal_refund_id => refund.id)
      else
        puts "Error: refund did not go through"
      end
    end
  end
end
