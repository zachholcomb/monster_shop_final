class Merchant::ItemsController < ApplicationController
  before_action :require_merchant

  def index
    @merchant = user_to_merchant
  end

  def update 
    merchant = user_to_merchant
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
    end
  end

  def user_to_merchant
    current_user.merchants[0]
  end

  def require_merchant
    render file: "/public/404" unless current_merchant?
  end
end
