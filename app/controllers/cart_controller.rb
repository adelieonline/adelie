class CartController < ApplicationController
  def show
    @cart_items = []
    if current_user
      cart = Cart.where(:user_id => current_user.id, :checked_out => false).first || []
      cart.cart_items.each do |cart_item|
        product = Product.where(:id => cart_item.product_id).first
        @cart_items.push({:product => product, :quantity => cart_item.quantity})
      end
    else
      cart = session[:cart].presence || []
      cart.each do |cart_item|
        product = Product.where(:id => cart_item[:product_id]).first
        @cart_items.push({:product => product, :quantity => cart_item[:quantity]})
      end
    end
  end

  def add
    product_id = params[:product_id].presence
    quantity = params[:quantity].presence
    if product_id && quantity
      if current_user
        cart = Cart.where(:user_id => current_user.id, :checked_out => false).first
        if cart.nil?
          cart = Cart.create(:user_id => current_user.id, :checked_out => false)
          cart.save
        end
        cart.cart_items.each do |cart_item|
          if cart_item.product_id == product_id.to_i
            cart_item.quantity += quantity.to_i
            cart_item.save
            return render :json => "Saved"
          end
        end
        cart_item = CartItem.create(:cart_id => cart.id, :product_id => product_id, :quantity => quantity)
        cart_item.save
        return render :json => "Saved"
      else
        session[:cart] ||= []
        session[:cart].each do |item|
          if item[:product_id] == product_id.to_i
            item[:quantity] += quantity.to_i
            return render :json => "Saved"
          end
        end
        session[:cart].push({:product_id => product_id.to_i, :quantity => quantity.to_i})
        return render :json => "Saved"
      end
    end
  end

  def update
    product_id = params[:product_id].presence
    quantity = params[:quantity].presence
    if product_id and quantity
      if current_user
        cart = Cart.where(:user_id => current_user.id, :checked_out => false).first || []
        cart.cart_items.each do |cart_item|
          if cart_item.product_id == product_id.to_i
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
        cart = session[:cart].presence || []
        cart.each do |cart_item|
          if cart_item[:product_id] == product_id.to_i
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
end
