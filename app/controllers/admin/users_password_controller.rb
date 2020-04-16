class Admin::UsersPasswordController < Admin::BaseController

  def edit
    @user = User.find(params[:user_id])
  end

  def update
    user = User.find(params[:user_id])
    return blank_password_path if params[:password] == ""
    if params[:password] == params[:password_confirmation]
      update_password
    elsif
      flash[:notice] = "Password and password confirmation do not match!"
      redirect_to "/admin/users/#{user.id}/password/edit"
    end
  end

  private

  def password_params
    params.permit(:password, :password_confirmation)
  end

  def update_password
    user = User.find(params[:user_id])
    user.update(password: params[:password])
    flash[:notice] = "Password has been updated!"
    return redirect_to "/admin/users/#{user.id}"
  end

  def blank_password_path
    user = User.find(params[:user_id])
    flash[:notice] = "Password can't be blank"
    redirect_to "/admin/users/#{user.id}/password/edit"
  end

end
