class UsersPasswordController < ApplicationController
  def edit

  end

  def update
    return flash[:notice] = "Password can't be blank" if params[:password] == ""
    if params[:password] == params[:password_confirmation]
      update_password
    else
      flash[:notice] = "Password and password confirmation do not match!"
      redirect_to '/profile/password/edit'
    end
  end

  private

  def password_params
    params.permit(:password, :password_confirmation)
  end

  def update_password
    current_user.update(password: params[:password])
    flash[:notice] = "Your password has been updated!"
    return redirect_to '/profile'
  end
end