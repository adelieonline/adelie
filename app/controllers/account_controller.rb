class AccountController < ApplicationController
  def show
    return redirect_to :controller => "index", :action => "index" if not current_user
    @orders = {}
    Order.where(:user_id => current_user.id).each do |order|
      products = {}
      OrderProduct.where(:order_id => order).each do |op|
        product = Product.where(:id => op.product_id).first
        if products.include?(product)
          products[product].push(op)
        else
          products[product] = [op]
        end
      end
      @orders[order.id] = products
    end
  end
end
