class Merchant::DiscountsController < ApplicationController
  def index
    @discounts = current_user.merchants.first.discounts
  end

  def show
    @discount = Discount.find(params[:id])
  end

  def new
    @discount = Discount.new
  end

  def create
    merchant = find_merchant_from_user
    @discount = create_discount(merchant)
    discount_check_creation(@discount)
  end

  def edit
    @discount = current_user.merchants.first.discounts.find(params[:id])
  end

  def update
    merchant = find_merchant_from_user
    discount = get_discount_from_merchant(merchant)
    discount.update(discount_params)
    discount_check_update(discount)
  end

  def destroy
    merchant = find_merchant_from_user
    delete_discount(merchant)
  end
  
  private
  def discount_params
    params.permit(:name, :percentage, :item_amount)
  end

  def create_discount(merchant)
    merchant.discounts.create(discount_params)
  end
  

  def find_merchant_from_user
    current_user.merchants.first
  end

  def get_discount_from_merchant(merchant)
    merchant.discounts.find(params[:id])
  end

  def discount_update_success
    flash[:success] = "Discount successfully updated"
    redirect_to "/merchant/dashboard"
  end

  def discount_check_update(discount)
    if discount.save
      discount_update_success  
    else
      flash[:error] = discount.errors.full_messages.to_sentence
      redirect_to "/merchant/discounts/#{discount.id}/edit"
    end
  end
  
  def delete_discount(merchant)
    discount = get_discount_from_merchant(merchant)
    discount.delete
    flash[:success] = "Discount was successfully deleted!"
    redirect_to "/merchant/dashboard"
  end

  def discount_check_creation(discount)
    if discount.save 
      flash[:success] = "Discount was successfully created!"
      redirect_to '/merchant/dashboard'
    else
      flash[:error] = discount.errors.full_messages.to_sentence
      render :new
    end
  end
end