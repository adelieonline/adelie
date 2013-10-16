require 'stripe'

class CheckoutController < ApplicationController
  protect_from_forgery with: :null_session, except: [:checkout]
  TAX_PERCENT = 0.0625

  def show
    if current_user
      cart = Cart.where(:user_id => current_user.id, :checked_out => false).first
      if cart
        @price = 0.0
        @items = 0
        @cart_items = []
        cart.cart_items.each do |cart_item|
          product = Product.where(:id => cart_item.product_id).first
          if !product.is_active?
            cart_item.delete
          else
            @items += cart_item.quantity
            console = Console.where(:id => cart_item.console_id).first
            @cart_items.push({:id => cart_item.id, :product => product, :quantity => cart_item.quantity, :console => console})
            @price += product.price.to_f * cart_item.quantity.to_f
          end
        end
        @tax = @price * TAX_PERCENT
        @shipping_types = ShippingType.where(:active => true)
        @shipping = @shipping_types.first.price
        @subtotal = @price
        @error = params[:error].present?
        if @items == 0
          return redirect_to :controller => "index", :action => "index"
        end
      else
        return redirect_to :controller => "index", :action => "index"
      end
    else
      return redirect_to :controller => "devise/sessions", :action => "new"
    end
  end

  def checkout
    if current_user
      cart = Cart.where(:user_id => current_user.id, :checked_out => false).first
      return redirect_to :controller => "cart", :action => "show" if cart.blank?
      shipping_name = params[:shipping_name].presence
      shipping_address_one = params[:shipping_address_one].presence
      shipping_address_two = params[:shipping_address_two].presence
      shipping_city = params[:shipping_city].presence
      shipping_state = params[:shipping_state].presence
      shipping_zip = params[:shipping_zip].presence
      card_type = params[:stripe_card_type].presence
      last_four = params[:stripe_last_four].presence
      stripe_token = params[:stripe_token].presence
      shipping_type = ShippingType.where(id: params[:shipping_type_button].presence, :active => true).first
      should_checkout = true
      if shipping_name.blank? ||
         shipping_address_one.blank? ||
         shipping_city.blank? ||
         shipping_state.blank? ||
         shipping_zip.blank? ||
         card_type.blank? ||
         last_four.blank? ||
         stripe_token.blank? ||
         shipping_type.blank?
        should_checkout = false
      end
      subtotal = 0.0
      description = current_user.email
      cart.cart_items.each do |cart_item|
        product = Product.where(:id => cart_item.product_id).first
        if product.blank? || !product.is_active?
          should_checkout = false
        end

        description += "|" + product.name.to_s + "|" + cart_item.quantity.to_s
        subtotal += product.price.to_f * cart_item.quantity.to_i
      end
      if should_checkout
        if shipping_state == "MA"
          tax = subtotal * TAX_PERCENT
        else
          tax = 0
        end
        total = (tax + subtotal + shipping_type.price) * 100
        Stripe.api_key = Rails.application.config.stripe_api_key
        begin
          charge = Stripe::Charge.create(
            :amount => total.to_i,
            :currency => "usd",
            :card => stripe_token,
            :description => description
          )
        rescue Stripe::CardError => e
          return redirect_to :controller => "checkout", :action => "show", :error => "unknown"
        end
        shipping_address = ShipAddress.create :user_id => current_user.id,
                                              :name => shipping_name,
                                              :address_one => shipping_address_one,
                                              :address_two => shipping_address_two,
                                              :city => shipping_city,
                                              :state => shipping_state,
                                              :country => "US"
        order = Order.create :user_id => current_user.id,
                             :ship_address_id => shipping_address.id,
                             :stripe_charge_id => charge['id'],
                             :card_last_four => last_four,
                             :card_type => card_type,
                             :total_cents => total.to_i
        OrderShippingType.create! :order_id => order.id,
                                  :shipping_type_id => shipping_type.id
        cart.cart_items.each do |cart_item|
          product = Product.where(:id => cart_item.product_id).first
          num_orders = product.num_orders.to_i + cart_item.quantity.to_i
          product.update_attributes(:num_orders => num_orders)
          for x in 1..cart_item.quantity.to_i
            OrderProduct.create :order_id => order.id,
                                :product_id => cart_item.product_id,
                                :user_id => current_user.id,
                                :console_id => cart_item.console_id,
                                :place_in_line => product.order_products.count + 1
          end
        end
        cart.update_attributes(:checked_out => true)
        return redirect_to :controller => "checkout", :action => "receipt", :id => order.id
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
    @subtotal = 0.0
    @products = {}
    order_products.each do |op|
      product = Product.where(:id => op.product_id).first
      if @products.include?(product)
        @products[product] += 1
      else
        @products[product] = 1
      end
      @subtotal += product.price.to_f
    end
    shipping_type = ShippingType.where(:id => OrderShippingType.where(:order_id => order.id).first.shipping_type_id).first
    @shipping = shipping_type.price
    @tax = (order.total_cents / 100) - @subtotal - @shipping
    @total = @shipping + @tax + @subtotal
  end
end
