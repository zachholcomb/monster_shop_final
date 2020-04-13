class Merchant::ItemsController < ApplicationController
  before_action :require_merchant

  def index
    @merchant = find_merchant_from_user
  end

  def update 
    merchant = find_merchant_from_user
    change_item_status(merchant)
    redirect_to '/merchant/items'
  end

  private
  
  def find_item(merchant)
    merchant.items.find(params[:item_id])
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

  def require_merchant
    render file: "/public/404" unless current_merchant?
  end
end
