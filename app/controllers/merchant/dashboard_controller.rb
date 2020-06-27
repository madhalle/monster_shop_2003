class Merchant::DashboardController < Merchant::BaseController

  def index
    @user= current_user
    #redundant, just use current_user
    @user_merchant = Merchant.find(@user.merchant_id)
    #current_user.merchant
    @pending_orders = Order.where(:status == "pending")
    #in relation to that merchant item, unused

  end
end
