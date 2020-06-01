class User::UsersController < User::BaseController

  def index
  end

  def show
    @user = User.find(session[:user_id])
  end
end
