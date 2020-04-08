class SessionsController < ApplicationController
  def new
    if current_user
      flash[:notice] = "You are already logged in!"
      login_user(User.find(session[:user]))
    end
  end

  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      session[:user] = user.id
      flash[:notice] = "You are now logged in!"
      login_user(user)
    else
      flash[:notice] = "You entered incorrect credentials."
      render :new
    end
  end

  private

  def login_user(user)
    return redirect_to '/profile' if user.default?
    return redirect_to '/merchant/dashboard' if user.merchant?
    redirect_to '/admin/dashboard'
  end
end
