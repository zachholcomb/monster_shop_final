class Admin::MerchantDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @discounts = @merchant.discounts
  end

  def show
    @discount = Discount.find(params[:discount_id])
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
    @discount = Discount.new
  end

  def create
    merchant = Merchant.find(params[:merchant_id])
    @discount = create_discount(merchant)
    discount_check_creation(@discount, merchant)
  end

  def edit
    @discount = Discount.find(params[:discount_id])
  end

  def update
    merchant = Merchant.find(params[:merchant_id])
    discount = get_discount_from_merchant(merchant)
    discount.update(discount_params)
    discount_check_update(discount, merchant)
  end

  def destroy
    merchant = Merchant.find(params[:merchant_id])
    delete_discount(merchant)
  end
  
  private
  def discount_params
    params.permit(:name, :percentage, :item_amount)
  end

  def create_discount(merchant)
    merchant.discounts.create(discount_params)
  end

  def get_discount_from_merchant(merchant)
    merchant.discounts.find(params[:discount_id])
  end

  def discount_update_success(merchant)
    flash[:success] = "Discount successfully updated"
    redirect_to "/admin/merchants/#{merchant.id}/discounts"
  end

  def discount_check_update(discount, merchant)
    if discount.save
      discount_update_success(merchant)  
    else
      flash[:error] = discount.errors.full_messages.to_sentence
      redirect_to "/admin/merchants/#{merchant.id}/discounts/#{discount.id}/edit"
    end
  end
  
  def delete_discount(merchant)
    discount = get_discount_from_merchant(merchant)
    discount.delete
    flash[:success] = "Discount was successfully deleted!"
    redirect_to "/admin/merchants/#{merchant.id}/discounts"
  end

  def discount_check_creation(discount, merchant)
    if discount.save 
      flash[:success] = "Discount was successfully created!"
      redirect_to "/admin/merchants/#{merchant.id}/discounts"
    else
      flash[:error] = discount.errors.full_messages.to_sentence
      redirect_to "/admin/merchants/#{merchant.id}/discounts/new"
    end
  end
end