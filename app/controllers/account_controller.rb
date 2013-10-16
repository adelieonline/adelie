class AccountController < ApplicationController
  def show
    return redirect_to :controller => "index", :action => "index" if not current_user
    @orders = {}
    current_user.orders.each do |order|
      products = {}
      current_user.order_products.where(:order => order).each do |op|
        product = op.product
        if products.include?(product)
          products[product].push(op)
        else
          products[product] = [op]
        end
      end
      @orders[order.id] = products
    end
    @orders.each_with_index do |(order_id, products), index|
      puts "order id: #{order_id}"
      puts "products: #{products}"
      puts "index: #{index}"
    end
  end
end
