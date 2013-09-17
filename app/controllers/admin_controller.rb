class AdminController < ApplicationController
  protect_from_forgery with: :null_session
  def add_product
    @products = Product.all
  end

  def show_product
    if request.method == "POST"
      product_id = params[:product_id].presence
      picture = params[:picture].presence
      caption = params[:caption].presence
      product = Product.where(:id => product_id).first
      picture = Picture.create caption: caption,
                               picture: picture,
                               product_id: product.id
    end
    product_id = params[:id].presence
    @product = Product.where(:id => product_id).first
    return redirect_to action: 'add_product' unless @product.present?
    @start_date = DateTime.parse(@product.start_time.to_s).strftime("%m/%d/%Y")
    @start_time = DateTime.parse(@product.start_time.to_s).strftime("%H:%M%p")
    @end_date = DateTime.parse(@product.end_time.to_s).strftime("%m/%d/%Y")
    @end_time = DateTime.parse(@product.end_time.to_s).strftime("%H:%M%p")
    @ship_date = DateTime.parse(@product.ship_date.to_s).strftime("%m/%d/%Y")
    @discount_tiers = DiscountTier.where(:product_id => @product.id)
    @product_pictures = Picture.where(:product_id => @product.id)
    @picture = Picture.new
  end

  def save_product
    tier_discounts = params[:tier_discounts].presence
    tier_percents = params[:tier_percents].presence
    name = params[:name].presence
    description = params[:desc].presence
    start_time = DateTime.strptime(params[:start].presence, "%m/%d/%Y %H:%M%p")
    end_time = DateTime.strptime(params[:end].presence, "%m/%d/%Y %H:%M%p")
    price = params[:price].presence
    ship_date = DateTime.strptime(params[:ship].presence, "%m/%d/%Y")
    tag_line = params[:tag_line].presence
    should_save = true
    should_save = false if tier_discounts.length != 11 || tier_percents.length != 11
    should_save = false if name == "" || description == "" || start_time == "" || end_time == "" || price == "" || ship_date == "" || tag_line == ""
    total_percent = 0
    for i in 0..11
      should_save = false if tier_discounts[i] == "" || tier_percents[i] == ""
      total_percent += tier_percents[i].to_f
    end
    should_save = false if total_percent != 100
    if should_save
      product = Product.create name: name,
                               description: description,
                               start_time: start_time,
                               price: price,
                               tag_line: tag_line,
                               end_time: end_time,
                               ship_date: ship_date
      if product.present?
        for i in 0..11
          DiscountTier.create discount: tier_discounts[i],
                              percent: tier_percents[i],
                              tier_number: i,
                              product_id: product.id
        end
      end
    end
    return render :json => product.id
  end

  def edit_product
    tier_discounts = params[:tier_discounts].presence
    tier_percents = params[:tier_percents].presence
    name = params[:name].presence
    description = params[:desc].presence
    start_time = DateTime.strptime(params[:start].presence, "%m/%d/%Y %H:%M%p")
    end_time = DateTime.strptime(params[:end].presence, "%m/%d/%Y %H:%M%p")
    price = params[:price].presence
    ship_date = DateTime.strptime(params[:ship].presence, "%m/%d/%Y")
    tag_line = params[:tag_line].presence
    product_id = params[:product_id].presence
    should_edit = true
    should_edit = false if tier_discounts.length != 11 || tier_percents.length != 11
    should_edit = false if name == "" || description == "" || start_time == "" || end_time == "" || price == "" || ship_date == "" || tag_line == ""
    total_percent = 0
    for i in 0..11
      should_edit = false if tier_discounts[i] == "" || tier_percents[i] == ""
      total_percent += tier_percents[i].to_f
    end
    should_edit = false if total_percent != 100
    product = Product.where(:id => product_id).first
    if should_edit && product
      product.update_attributes name: name,
                                description: description,
                                start_time: start_time,
                                end_time: end_time,
                                price: price,
                                ship_date: ship_date,
                                tag_line: tag_line
      for i in 0..11
        old_discount_tier = DiscountTier.where(:product_id => product.id, :tier_number => i).first
        if old_discount_tier
          old_discount_tier.update_attributes :discount => tier_discounts[i],
                                              :percent => tier_percents[i]
        end
      end
      return render :json => "True"
    end
    render :json => "False"
  end

  def delete_picture
    picture_id = params[:picture_id].presence
    picture = Picture.where(:id => picture_id).first
    picture.delete
    render :json => "deleted"
  end
end
