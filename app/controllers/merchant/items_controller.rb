class Merchant::ItemsController < ApplicationController
  before_action :require_merchant

  def new
  end
  
  def create
    item = find_merchant_from_user.items.create(item_params)
    item_check_creation(item)
  end

  def index
    @merchant = find_merchant_from_user
  end

  def update 
    merchant = find_merchant_from_user
    change_item_status(merchant)
    redirect_to '/merchant/items'
  end

  def destroy
    merchant = find_merchant_from_user
    flash[:notice] = "#{find_item(merchant).name} was successfully deleted"
    find_item(merchant).delete
    redirect_to '/merchant/items'
  end

  private

  def item_params
    params.permit(:name, :description, :price, :image, :inventory)
  end
  
  def find_item(merchant)
    merchant.items.find(params[:id])
  end

  def change_item_status(merchant)
    if params[:type] == 'deactivate'
      find_item(merchant).update(active?: false)
      flash[:notice] = "#{find_item(merchant).name} is no longer for sale!"
    elsif params[:type] == 'activate'
      find_item(merchant).update(active?: true)
      flash[:notice] = "#{find_item(merchant).name} is now for sale!"
    end
  end

  def find_merchant_from_user
    current_user.merchants[0]
  end

  def item_check_creation(item)
     if item.save
      flash[:notice] = "Your item was saved!"
      redirect_to '/merchant/items'
    else
      flash[:notice] = item.errors.full_messages.to_sentence
      render :new
    end
  end

  def require_merchant
    render file: "/public/404" unless current_merchant?
  end
end
