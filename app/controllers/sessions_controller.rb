class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email])
    if user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = "Welcome, #{user.name}!"
      if current_user?
        redirect_to "/profile/#{current_user.id}"
      elsif current_admin?
        redirect_to "/admin"
      elsif current_merchant?
        redirect_to "/merchant"
      end
    else
      flash[:error] = "Sorry, your credentials are bad."
      render :new
    end
  end

  def destroy
    session.delete(:user_id)
    session.delete(:cart)
    current_user = nil
    flash[:success] = "You have been logged out"

    redirect_to "/"
  end
end
