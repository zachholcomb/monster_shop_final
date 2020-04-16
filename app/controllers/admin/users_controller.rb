class Admin::UsersController < Admin::BaseController

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:user_id])
  end

  def edit
    @user = User.find(params[:user_id])
  end

  def update
    user = User.find(params[:user_id])
    if user.update(user_params)
      flash[:notice] = "Profile has been updated!"
      redirect_to "/admin/users/#{user.id}"
    else
      flash[:notice] = user.errors.full_messages.to_sentence
      redirect_to "/admin/users/#{user.id}/edit"
    end
  end

  def user_params
    params.permit(:name, :address, :city, :state, :zip, :email, :password)
  end

end
