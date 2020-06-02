class Merchant::ItemsController < Merchant::BaseController

  def index
    @merchant = Merchant.find(current_user.merchant_id)
  end

  def update
    item = Item.find(params[:id])
    if params[:active] == "true"
      item.update({"active?" => "true"})
      item.save
      flash[:notice] = "The #{item.name} is now available for sale"
      redirect_to "/merchant/items"
    elsif params[:active] == "false"
      item.update({"active?" => "false"})
      item.save
      flash[:notice] = "The #{item.name} is no longer for sale"
      redirect_to "/merchant/items"
    end
  end
end
