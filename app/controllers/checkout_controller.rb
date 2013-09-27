require 'paypal-sdk-rest'
include PayPal::SDK::REST

class CheckoutController < ApplicationController
  protect_from_forgery with: :null_session
  TAX_PERCENT = 0.0625

  def show
    if current_user
      cart = Cart.where(:user_id => current_user.id, :checked_out => false).first
      if cart
        @price = 0.0
        @items = 0
        @cart_items = []
        cart.cart_items.each do |cart_item|
          @items += cart_item.quantity
          product = Product.where(:id => cart_item.product_id).first
          @cart_items.push({:product => product, :quantity => cart_item.quantity})
          @price += product.price.to_f * cart_item.quantity.to_f
        end
        @tax = @price * TAX_PERCENT
        @total = @price + @tax
      else
        return redirect_to :controller => "index", :action => "index"
      end
    else
      return redirect_to :controller => "devise/sessions", :action => "new"
    end
  end

  def checkout
    if current_user
      cart = Cart.where(:user_id => current_user.id).first
      return redirect_to :controller => "cart", :action => "show" if cart.blank?
      shipping_name = params[:shipping_name].presence
      shipping_address_one = params[:shipping_address_one].presence
      shipping_address_two = params[:shipping_address_two].presence
      shipping_city = params[:shipping_city].presence
      shipping_state = params[:shipping_state].presence
      shipping_zip = params[:shipping_zip].presence
      same_as_shipping = params[:same_as_shipping].presence || false
      billing_name = same_as_shipping ? shipping_name : params[:billing_name].presence
      billing_address_one = same_as_shipping ? shipping_address_one : params[:billing_address_one].presence
      billing_address_two = same_as_shipping ? shipping_address_two : params[:billing_address_two].presence
      billing_city = same_as_shipping ? shipping_city : params[:billing_city].presence
      billing_state = same_as_shipping ? shipping_state : params[:billing_state].presence
      billing_zip = same_as_shipping ? shipping_zip : params[:billing_zip].presence
      payment_name = params[:payment_name].presence
      payment_card = params[:payment_card].presence
      payment_month = params[:payment_month].presence
      payment_year = params[:payment_year].presence
      payment_code = params[:payment_code].presence
      card_type = params[:card_type].presence
      shipping = true
      billing = true
      payment = true
      if shipping_name.blank? || shipping_address_one.blank? || shipping_city.blank? || shipping_state.blank? || shipping_zip.blank?
        shipping = false
      end
      if not same_as_shipping
        if billing_name.blank? || billing_address_one.blank? || billing_city.blank? || billing_state.blank? || billing_zip.blank?
          billing = false
        end
      end
      if payment_name.blank? || payment_card.blank? || payment_month.blank? || payment_year.blank? || payment_code.blank? || card_type.blank? || card_type == "none"
        payment = false
      end
      if shipping && billing && payment
        first_name = payment_name.split(" ")[0]
        last_name = payment_name.split(" ").drop(1).join(" ")
        total = 0.0
        items = []
        cart.cart_items.each do |cart_item|
          item = {}
          product = Product.where(:id => cart_item.product_id).first
          item[:quantity] = cart_item.quantity
          item[:name] = product.name
          item[:price] = "%.2f" % product.price
          item[:currency] = "USD"
          items.push(item)
          total += product.price.to_f * cart_item.quantity.to_i
        end
        tax = total * TAX_PERCENT
        transactions = [{
                         :item_list => {
                           :items => items
                         },
                         :amount => {
                           :total => "%.2f" % (total + tax),
                           :currency => "USD",
                           :details => {
                             :subtotal => "%.2f" % total,
                             :tax => "%.2f" % tax
                           }
                         },
                         :description => "Sample Description"
                       }]
        payer = {:payment_method => "credit_card",
                 :funding_instruments => [{
                   :credit_card => {
                     :type => card_type,
                     :number => payment_card,
                     :expire_month => payment_month.to_i,
                     :expire_year => payment_year.to_i,
                     :payer_id => current_user.id,
                     :cvv2 => payment_code,
                     :first_name => first_name,
                     :last_name => last_name,
                     :billing_address => {
                       :line1 => billing_address_one,
                       :line2 => billing_address_two,
                       :city => billing_city,
                       :state => billing_state,
                       :postal_code => billing_zip,
                       :country_code => "US"
                     }
                   }
                 }]}
        payment = Payment.new({:intent => "sale",
                                :payer => payer,
                                :transactions => transactions})
        if payment.create
          shipping_address = ShipAddress.create :user_id => current_user.id,
                                                    :name => shipping_name,
                                                    :address_one => shipping_address_one,
                                                    :address_two => shipping_address_two,
                                                    :city => shipping_city,
                                                    :state => shipping_state,
                                                    :country => "US"
          order = Order.create :user_id => current_user.id,
                               :ship_address_id => shipping_address.id,
                               :paypal_payment_id => payment.id
          cart.cart_items.each do |cart_item|
            for x in 1..cart_item.quantity.to_i
              OrderProduct.create :order_id => order.id,
                                  :product_id => cart_item.product_id
            end
          end
          return render :json => {:status => "success", :order_id => order.id}
        else
           return render :json => {:status => "error", :details => payment.error['details']}
        end
      else
        return render :json => {:status => "error"}
      end
    else
      return redirect_to :controller => "devise/sessions", :action => "new"
    end
  end

  def receipt
    return redirect_to :controller => 'index', :action => 'index' if not current_user
    order_id = params[:id].presence
    order = Order.where(:id => order_id, :user_id => current_user.id).first
    return redirect_to :controller => 'index', :action => 'index' if order.blank?
    order_products = OrderProduct.where(:order_id => order.id)
    @total = 0.0
    @products = {}
    order_products.each do |op|
      product = Product.where(:id => op.product_id).first
      if @products.include?(product)
        @products[product] += 1
      else
        @products[product] = 1
      end
      @total += product.price.to_f
    end
    @tax = @total * 0.0625
  end
end
