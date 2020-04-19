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
    merchant = current_user.merchants.first
    @discount = merchant.discounts.create(discount_params)
    if @discount.save 
      flash[:success] = "Discount was successfully created!"
      redirect_to '/merchant/dashboard'
    else
      flash[:error] = @discount.errors.full_messages.to_sentence
      render :new
    end
  end

  def edit
    @discount = current_user.merchants.first.discounts.find(params[:id])
  end

  def update
    merchant = current_user.merchants.first
    discount = merchant.discounts.find(params[:id])
    discount.update(discount_params)
    if discount.save
      flash[:success] = "Discount successfully updated"
      redirect_to "/merchant/dashboard"
    else
      flash[:error] = discount.errors.full_messages.to_sentence
      redirect_to "/merchant/discounts/#{discount.id}/edit"
    end
  end

  def destroy
    merchant = current_user.merchants.first
    discount = merchant.discounts.find(params[:id])
    discount.delete
    flash[:success] = "Discount was successfully deleted!"
    redirect_to "/merchant/dashboard"
  end
  
  private
  def discount_params
    params.permit(:name, :percentage, :item_amount)
  end
end