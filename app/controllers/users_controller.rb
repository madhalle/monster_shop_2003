class UsersController < ApplicationController
  def new
  end

  def index
    render file: "/public/404" unless current_admin?
  end

  def show
    render file: "/public/404" unless current_user
  end

  def create
    user = User.new(user_params)
    if user.save
      session[:user_id] = user.id
      flash[:notice] = 'Success! You are now registered and logged in as a User!'
      redirect_to '/profile'
    else
      flash[:notice] = user.errors.full_messages.to_sentence
      render "new"
    end
  end

  def update
  user = User.find(params[:id])
    if user.authenticate(params[:password])
      if user.update(user_params)
        flash[:notice] = "Your profile has been updated"
      end
    end
    redirect_to "/profile"
  end
  private

  def user_params
    params.permit(:name, :address, :city, :state, :zip, :email, :password, :password_confirmation, :role)
  end
end
