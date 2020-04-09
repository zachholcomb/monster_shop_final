class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
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
    @user = current_user
  end

  def edit_password 
  end

  def update
    if current_user.update(user_params)
      if params[:user][:password]
        flash[:notice] = "Your password has been updated!"
        return redirect_to '/profile'
      end
    else
      flash[:error] = current_user.errors.full_messages.to_sentence
      redirect_to "/profile/edit"
    end
  end

  def edit
    @user = User.find(session[:user])
  end

  def update
    if current_user.update(user_params)
      if params[:password]
        flash[:notice] = "Your password has been updated!"
        return redirect_to '/profile'
      end
      flash[:notice] = "Your profile has been updated!"
      redirect_to "/profile"
    else
      flash[:notice] = current_user.errors.full_messages.to_sentence
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
