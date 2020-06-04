class Admin::MerchantsController < Admin::BaseController

  def index
    @merchants = Merchant.all
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
  end

  def update
    @merchant = Merchant.find(merchant_params[:merchant_id])
    @merchant.toggle!(:active?)
    @merchant.items.each do |item|
      item.toggle!(:active?)
    end
    flash[:update] = "#{@merchant.name}'s account has been #{merchant_params[:type]}d."
    redirect_to "/admin/merchants"
  end


  private
    def merchant_params
      params.permit(:type, :merchant_id)
    end
end
