require 'stripe'

class AdminController < ApplicationController
  protect_from_forgery
  def add_product
    is_authorized_user
    @products = Product.all
    @consoles = Console.all
  end

  def show_product
    if request.method == "POST"
      product_id = params[:product_id].presence
      picture = params[:picture].presence
      caption = params[:caption].presence
      product = Product.where(:id => product_id).first
      if product.present? && picture.present?
        picture = Picture.create! caption: caption,
                                  picture: picture,
                                  product_id: product.id
      end
    end
    product_id = params[:id].presence
    @product = Product.where(:id => product_id).first
    return redirect_to action: 'add_product' unless @product.present?
    @start_date = DateTime.parse(@product.start_time.to_s).strftime("%m/%d/%Y")
    @start_time = DateTime.parse(@product.start_time.to_s).strftime("%H:%M%p")
    @end_date = DateTime.parse(@product.end_time.to_s).strftime("%m/%d/%Y")
    @end_time = DateTime.parse(@product.end_time.to_s).strftime("%H:%M%p")
    @release_date = DateTime.parse(@product.release_date.to_s).strftime("%m/%d/%Y")
    @discount_tiers = DiscountTier.where(:product_id => @product.id)
    @product_pictures = Picture.where(:product_id => @product.id)
    @picture = Picture.new
    @consoles = Console.all
  end

  def save_product
    is_authorized_user
    tier_discounts = params[:tier_discounts].presence
    tier_percents = params[:tier_percents].presence
    name = params[:name].presence
    description = params[:desc].presence
    start_time = DateTime.strptime(params[:start].presence, "%m/%d/%Y %H:%M%p")
    end_time = DateTime.strptime(params[:end].presence, "%m/%d/%Y %H:%M%p")
    price = params[:price].presence
    release_date = DateTime.strptime(params[:release].presence, "%m/%d/%Y")
    tag_line = params[:tag_line].presence
    video_url = params[:video_url].presence
    consoles = params[:consoles].presence
    should_save = true
    should_save = false if tier_discounts.length != 5 || tier_percents.length != 5
    should_save = false if name.blank? || description.blank? || start_time.blank? || end_time.blank? || price.blank? || release_date.blank? || tag_line.blank? || consoles.blank?
    total_percent = 0
    for i in 0..4
      should_save = false if tier_discounts[i].blank? || tier_percents[i].blank?
      total_percent += tier_percents[i].to_f
    end
    should_save = false if total_percent != 100
    if should_save
      product = Product.create! name: name,
                                description: description,
                                start_time: start_time,
                                price: price,
                                tag_line: tag_line,
                                end_time: end_time,
                                release_date: release_date,
                                video_url: video_url
      if product.present?
        for i in 0..4
          DiscountTier.create! discount: tier_discounts[i],
                               percent: tier_percents[i],
                               tier_number: i,
                               product_id: product.id
        end
        consoles.each do |console_name|
          console = Console.where(name: console_name).first
          ProductConsole.create! product_id: product.id,
                                 console_id: console.id
        end
      end
      return render :json => product.id
    end
    return render :json => "False"
  end

  def edit_product
    is_authorized_user
    tier_discounts = params[:tier_discounts].presence
    tier_percents = params[:tier_percents].presence
    name = params[:name].presence
    description = params[:desc].presence
    start_time = DateTime.strptime(params[:start].presence, "%m/%d/%Y %H:%M%p")
    end_time = DateTime.strptime(params[:end].presence, "%m/%d/%Y %H:%M%p")
    price = params[:price].presence
    release_date = DateTime.strptime(params[:release].presence, "%m/%d/%Y")
    tag_line = params[:tag_line].presence
    product_id = params[:product_id].presence
    video_url = params[:video_url].presence
    consoles = params[:consoles].presence
    should_edit = true
    should_edit = false if tier_discounts.length != 5 || tier_percents.length != 5
    should_edit = false if name.blank? || description.blank? || start_time.blank? || end_time.blank? || price.blank? || release_date.blank? || tag_line.blank? || consoles.blank?
    total_percent = 0
    for i in 0..4
      should_edit = false if tier_discounts[i].blank? || tier_percents[i].blank?
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
                                release_date: release_date,
                                tag_line: tag_line,
                                video_url: video_url
      for i in 0..4
        old_discount_tier = DiscountTier.where(:product_id => product.id, :tier_number => i).first
        if old_discount_tier
          old_discount_tier.update_attributes :discount => tier_discounts[i],
                                              :percent => tier_percents[i]
        end
      end
      ProductConsole.where(product_id: product.id).each do |pc|
        pc.delete
      end
      consoles.each do |console_name|
        console = Console.where(name: console_name).first
        ProductConsole.create! product_id: product.id,
                               console_id: console.id
      end
      return render :json => "True"
    end
    render :json => "False"
  end

  def delete_picture
    is_authorized_user
    picture_id = params[:picture_id].presence
    picture = Picture.where(:id => picture_id).first
    picture.delete
    render :json => "deleted"
  end

  def save_tiers
    product_id = params[:product_id].presence
    product = Product.where(:id => product_id).first
    tier_discounts = params[:tier_discounts].presence
    tier_percents = params[:tier_percents].presence
    return redirect_to :controller => "admin", :action => "add_product" if product.blank? || tier_discounts.blank? || tier_percents.blank?
    save_tiers = false if tier_discounts.length != 5 || tier_percents.length != 5
    total_percent = 0
    for i in 0..5
      save_tiers = false if tier_discounts[i] == "" || tier_percents[i] == ""
      total_percent += tier_percents[i].to_f
    end
    if save_tiers
      for i in 0..5
        old_discount_tier = DiscountTier.where(:product_id => product.id, :tier_number => i).first
        if old_discount_tier
          old_discount_tier.update_attributes :discount => tier_discounts[i],
                                              :percent => tier_percents[i]
        end
      end
    end
    return render :json => "ok"
  end

  private
    AUTHORIZED_USERS = ["skier2k5@gmail.com", "adelieonline@gmail.com"]
    def is_authorized_user
      return redirect_to :controller => "index", :action => "index" if ((not current_user) || (not AUTHORIZED_USERS.include?(current_user.email)))
    end
end
