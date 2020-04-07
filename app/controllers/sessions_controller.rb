class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email])
    if user.authenticate(params[:password])
      session[:user] = user.id
      flash[:notice] = "You are now logged in!"
      login_user(user)
    else
    end
  end

  private

  def login_user(user)
    return redirect_to '/profile' if user.default?
    return redirect_to '/merchant/dashboard' if user.merchant?
    redirect_to '/admin/dashboard'
  end
end
