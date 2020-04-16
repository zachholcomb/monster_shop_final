class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      register_user(@user)
    else
     reload_register(@user)
    end
  end

  def show
    require_user
    @user = current_user
  end

  def edit
    @user = User.find(session[:user])
  end

  def update
    if current_user.update(user_params)
      flash[:success] = "Your profile has been updated!"
      redirect_to "/profile"
    else
      flash[:error] = current_user.errors.full_messages.to_sentence
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

  def register_user(user)
    session[:user] = user.id
    flash[:success] = "You are successfully registered and logged in!"
    redirect_to "/profile"
  end

  def reload_register(user)
    flash[:error] = user.errors.full_messages.to_sentence
    render :new
  end
end
