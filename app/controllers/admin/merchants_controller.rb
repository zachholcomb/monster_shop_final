class Admin::MerchantsController < Admin::BaseController
  def index 
    @merchants = Merchant.all
  end

  def show 
    @merchant = Merchant.find(params[:id])
  end

  def update 
    merchant = Merchant.find(params[:id])
    if merchant.enabled?
      merchant.update(enabled?: false)
      merchant.deactivate_items
      flash[:notice] = "#{merchant.name} is now disabled."
      redirect_to admin_merchants_path
    else  
      merchant.update(enabled?: true)
      merchant.activate_items
      flash[:notice] = "#{merchant.name} is now enabled."
      redirect_to admin_merchants_path
    end
  end
end