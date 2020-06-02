class Admin::MerchantsController < Admin::BaseController

  def index
    @merchants = Merchant.all
  end

  def update
    flash[:update] = "#{@merchant.name}'s account has been disabled."
    redirect_to "/admin/merchants"
  end
end
