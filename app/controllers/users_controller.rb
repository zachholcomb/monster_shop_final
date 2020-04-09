class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.create(user_params)
    if @user.save
      flash[:notice] = "You are successfully registered and logged in!"
      redirect_to "/profile"
    else
      flash[:notice] = @user.errors.full_messages.to_sentence
      render :new
    end
  end

  def show
    require_user
  end

  def edit
    @user = User.find(session[:user])
  end

  def update
    user = User.find(session[:user])
    user.update(user_params)
    if user.save
      flash[:notice] = "Your profile has been updated!"
      redirect_to "/profile"
    else
      flash[:notice] = user.errors.full_messages.to_sentence
      redirect_to "/profile/edit"
    end
  end

  private
  def user_params
    params.permit(:name, :address, :city, :state, :zip, :email, :password)
  end

  def require_user
    render file: "/public/404" unless current_user
  end
end
