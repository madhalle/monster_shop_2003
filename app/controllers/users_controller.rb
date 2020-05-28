class UsersController < ApplicationController
  def new
  end

  def index
  end

  def show
    render file: "/public/404" unless current_user
  end
end
