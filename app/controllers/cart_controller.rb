class CartController < ApplicationController
  def add_item
    item = Item.find(params[:item_id])
    cart.add_item(item.id.to_s)
    flash[:success] = "#{item.name} was successfully added to your cart"
    redirect_to "/items"
  end

  def show
    @items = cart.items
  end

  def empty
    session.delete(:cart)
    redirect_to '/cart'
  end

  def remove_item
    session[:cart].delete(params[:item_id])
    redirect_to '/cart'
  end

  def increase_quantity
    item = Item.find(params[:item_id])
    if cart.contents["#{item.id}"] < item.inventory
      cart.contents["#{item.id}"] += 1
      redirect_to '/cart'
    else
      flash[:notice] = "No More Can Be Ordered At This Time"
      redirect_to '/cart'
    end
  end

  def decrease_quantity
    cart.contents["#{params[:item_id]}"] -= 1
    if cart.contents["#{params[:item_id]}"] == 0
      remove_item
    else
      redirect_to '/cart'
    end
  end


end
