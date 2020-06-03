class Merchant::DashboardController < Merchant::BaseController

  def index
    @user= current_user
    @user_merchant = Merchant.find(@user.merchant_id)
    require "pry"; binding.pry
  end
end
