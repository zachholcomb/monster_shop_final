class Admin::UsersOrdersController < Admin::BaseController

  def index
    @user = User.find(params[:user_id])
  end

end
