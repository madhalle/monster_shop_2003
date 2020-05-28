class ProfileController < ApplicationController
  def index
    render file: "/public/404" unless current_user
  end

  def show
    # code
  end
end
