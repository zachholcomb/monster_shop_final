class Admin::MerchantsController < Admin::BaseController
  def new
    
  end
  
  def index
    @merchants = Merchant.all
  end

  def show
    @merchant = Merchant.find(params[:id])
  end

  def edit
    @merchant = Merchant.find(params[:id])
  end

  def update
    merchant = Merchant.find(params[:id])
    if params[:type]
      change_merchant_status(merchant)
    else
      update_merchant(merchant)
    end
  end

  private 

  def merchant_params
    params.permit(:name, :address, :city, :state, :zip)
  end

  def change_merchant_status(merchant)
    if merchant.enabled?
      merchant.update(enabled?: false)
      merchant.deactivate_items
      flash[:success] = "#{merchant.name} is now disabled."
      redirect_to admin_merchants_path
    else
      merchant.update(enabled?: true)
      merchant.activate_items
      flash[:success] = "#{merchant.name} is now enabled."
      redirect_to admin_merchants_path
    end
  end

  def update_merchant(merchant) 
    merchant.update(merchant_params)
    if merchant.save
      redirect_to "/admin/merchants/#{merchant.id}"
      flash[:success] = "Merchant successfully updated!"
    else
      flash[:error] = merchant.errors.full_messages.to_sentence
      render :edit
    end
  end
end
