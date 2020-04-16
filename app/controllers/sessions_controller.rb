class SessionsController < ApplicationController
  def new
    if current_user
      flash[:error] = "You are already logged in!"
      login_user(User.find(session[:user]))
    end
  end

  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      session[:user] = user.id
      flash[:success] = "You are now logged in!"
      login_user(user)
    else
      flash[:error] = "You entered incorrect credentials."
      render :new
    end
  end

  def destroy
    session.delete(:cart)
    session.delete(:user)
    flash[:success] = "You have been sucessfully logged out. Bye!"
    redirect_to "/"
  end
  private

  def login_user(user)
    return redirect_to '/profile' if user.default?
    return redirect_to '/merchant/dashboard' if user.merchant?
    redirect_to '/admin/dashboard'
  end
end
