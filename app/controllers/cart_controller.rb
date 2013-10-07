class CartController < ApplicationController
  def show
    @cart_items = []
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
    product_id = params[:product_id].presence
    quantity = params[:quantity].presence
    console_id = params[:console_id].presence
    product = Product.where(:id => product_id).first
    console = Console.where(:id => console_id).first
    if product.present? && quantity.present? && console.present?
      if current_user
        cart = Cart.where(:user_id => current_user.id, :checked_out => false).first
        if cart.nil?
          cart = Cart.create(:user_id => current_user.id, :checked_out => false)
          cart.save
        end
        cart.cart_items.each do |cart_item|
          if cart_item.product_id == product.id.to_i && cart_item.console_id == console.id.to_i
            cart_item.quantity += quantity.to_i
            cart_item.save
            return render :json => "Saved"
          end
        end
        cart_item = CartItem.create(:cart_id => cart.id, :product_id => product.id, :quantity => quantity, :console_id => console.id)
        cart_item.save
        return render :json => "Saved"
      else
        session[:cart] ||= []
        max_id = 0
        session[:cart].each do |item|
          if item[:id] > max_id
            max_id = item[:id].to_i
          end
          if item[:product_id] == product.id.to_i && item[:console_id] == console.id.to_i
            item[:quantity] += quantity.to_i
            return render :json => "Saved"
          end
        end
        session[:cart].push({:id => (max_id + 1), :product_id => product_id.to_i, :quantity => quantity.to_i, :console_id => console.id.to_i})
        return render :json => "Saved"
      end
    end
  end

  def update
    cart_item_id = params[:cart_item_id].presence
    quantity = params[:quantity].presence
    console_id = params[:console_id].presence
    console = Console.where(:id => console_id).first
    if cart_item_id.present? && quantity.present? && console.present?
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
              cart_item.console_id = console.id
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
              cart_item[:console_id] = console.id
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
            if product.id.t0_i == ci.product_id.to_i
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
