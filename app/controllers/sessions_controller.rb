class SessionsController < ApplicationController
  def new
    if logged_in?
      flash[:error] = "I am already logged in"
      redirect_to_path
      # require "pry"; binding.pry
    end
  end

  def create
    user = User.find_by(email: params[:email])
    if user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = "Welcome, #{user.name}!"
      if current_user?
        redirect_to "/profile"
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

  private

  def redirect_to_path
    redirect_to "/profile/#{current_user.id}" if current_user?
    redirect_to '/merchant' if current_merchant?
    redirect_to '/admin' if current_admin?
  end

end
