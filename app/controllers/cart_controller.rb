class CartController < ApplicationController
  def show
    @cart_items = []
    @shipping_types = ShippingType.all
    if current_user
      cart = Cart.where(:user_id => current_user.id, :checked_out => false).first
      if cart
        cart.cart_items.each do |cart_item|
          product = Product.where(:id => cart_item.product_id).first
          console = Console.where(:id => cart_item.console_id).first
          @cart_items.push({:id => cart_item.id, :product => product, :quantity => cart_item.quantity, :console => console})
        end
      end
    else
      cart = session[:cart].presence
      if cart
        cart.each_with_index do |cart_item, index|
          product = Product.where(:id => cart_item[:product_id]).first
          console = Console.where(:id => cart_item[:console_id]).first
          @cart_items.push({:id => cart_item[:id], :product => product, :quantity => cart_item[:quantity], :console => console})
        end
      end
    end
  end

  def add
    new_cart_item = CartItem.new(params[:cart_item])
    if current_user
      cart = Cart.where(:user_id => current_user.id, :checked_out => false).first
      if cart.nil?
        cart = Cart.create(:user_id => current_user.id, :checked_out => false)
        cart.save
      end
      cart.cart_items.each do |cart_item|
        if cart_item.product_id == new_cart_item.product_id && cart_item.console_id == new_cart_item.console_id
          cart_item.quantity += new_cart_item.quantity
          if cart_item.save
            redirect_to cart_path and return
          else
          end
        end
      end
      new_cart_item.cart_id = cart.id
      if new_cart_item.save
        redirect_to cart_path and return
      else
      end
    else
      session[:cart] ||= []
      max_id = 0
      session[:cart].each do |item|
        if item[:id] > max_id
          max_id = item[:id].to_i
        end
        if item[:product_id] == new_cart_item.product_id && item[:console_id] == new_cart_item.console_id
          item[:quantity] += new_cart_item.quantity
          redirect_to cart_path and return
        end
      end
      session[:cart].push({:id => (max_id + 1), :product_id => new_cart_item.product_id, :quantity => new_cart_item.quantity, :console_id => new_cart_item.console.id})
      redirect_to cart_path and return
    end
  end

  def update
    cart_item_id = params[:cart_item_id].presence
    quantity = params[:quantity].presence
    if cart_item_id.present? && quantity.present?
      if current_user
        cart = Cart.where(:user_id => current_user.id, :checked_out => false).first
        if cart.nil?
          return render :json => "Not Updated"
        end
        cart.cart_items.each do |cart_item|
          if cart_item.id == cart_item_id.to_i
            if quantity.to_i == 0
              cart_item.delete
            else
              cart_item.quantity = quantity
              cart_item.save
            end
            return render :json => "Updated"
          end
        end
      else
        cart = session[:cart].presence
        if cart.nil?
          return render :json => "Not Updated"
        end
        cart.each do |cart_item|
          if cart_item[:id] == cart_item_id.to_i
            if quantity.to_i == 0
              session[:cart].delete(cart_item)
            else
              cart_item[:quantity] = quantity.to_i
            end
            return render :json => "Updated"
          end
        end
      end
    end
    return render :json => "Not Updated"
  end

  def switch_over
    if session[:cart].presence
      cart = Cart.where(:user_id => current_user.id, :checked_out => false).first
      if cart.blank?
        cart = Cart.create! :user_id => current_user.id,
                            :checked_out => false
      end
      session[:cart].each do |cart_item|
        product = Product.where(:id => cart_item[:product_id]).first
        if product
          found = false
          cart.cart_items.each do |ci|
            if product.id.to_i == ci.product_id.to_i && cart_item[:console_id].to_i == ci.console_id.to_i
              found = true
            end
          end
          if !found
            CartItem.create! :cart_id => cart.id,
                             :product_id => product.id,
                             :quantity => cart_item[:quantity].to_i,
                             :console_id => cart_item[:console_id].to_i
          end
        end
      end
    end
    return redirect_to :controller => "index", :action => "index"
  end
end
