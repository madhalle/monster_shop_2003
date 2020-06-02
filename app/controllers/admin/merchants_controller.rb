class Admin::MerchantsController < Admin::BaseController

  def index
    @merchants = Merchants.all
  end

end
