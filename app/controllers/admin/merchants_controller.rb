class Admin::MerchantsController < Admin::BaseController

  def index
    @merchants = Merchant.all
  end

  def update
    @merchant = Merchant.find(merchant_params[:merchant_id])
    if merchant_params[:type] == "disable"
      @merchant.items.each do |item|
        item.update(:active? => false)
      end
    end
    flash[:update] = "#{@merchant.name}'s account has been disabled."
    redirect_to "/admin/merchants"
  end

  private
    def merchant_params
      params.permit(:type, :merchant_id)
    end
end
