class Admin::MerchantsController < Admin::BaseController

  def index
    @merchants = Merchant.all
  end

  def update
    @merchant = Merchant.find(merchant_params[:merchant_id])
    if merchant_params[:type]
      update_active_status = merchant_params[:type] == "enable" ? true : false
      # this looks at the current merchant/items type, which we update based on the
      # buttons that should appear in the view, which are linked to the active status
      # that we expect a merchant/item to have within our test
      # if the type is enabled, then the active status is turned to true, else it is false
      # for this, we must pass in the type param using a private method below
      @merchant.update(:active? => update_active_status)
      @merchant.items.each do |item|
        item.update(:active? => update_active_status)
      end
      flash[:update] = "#{@merchant.name}'s account has been #{merchant_params[:type]}d."
      redirect_to "/admin/merchants"
    end
  end

  private
    def merchant_params
      params.permit(:type, :merchant_id)
    end
end
