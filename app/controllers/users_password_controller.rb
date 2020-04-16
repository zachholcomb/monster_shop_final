class UsersPasswordController < ApplicationController
  def edit

  end

  def update
    return blank_password_path if params[:password] == ""
    if params[:password] == params[:password_confirmation]
      update_password
    elsif
      flash[:error] = "Password and password confirmation do not match!"
      redirect_to '/profile/password/edit'
    end
  end

  private

  def password_params
    params.permit(:password, :password_confirmation)
  end

  def update_password
    current_user.update(password: params[:password])
    flash[:success] = "Your password has been updated!"
    return redirect_to '/profile'
  end

  def blank_password_path
    flash[:error] = "Password can't be blank" 
    redirect_to '/profile/password/edit'
  end
end