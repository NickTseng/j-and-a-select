class OrdersController < ApplicationController
  before_action :authenticate_user!, only: [:create]

  # 產生訂單
  def create
    @order = Order.new(order_params)
    @order.user = current_user
    @order.total = current_cart.total_price

    if @order.save

      # 將購買車內容存入訂單
      current_cart.cart_items.each do |cart_item|
        order_item = OrderItem.new
        order_item.order = @order
        order_item.product_name = cart_item.product.name
        order_item.product_price = cart_item.product.price
        order_item.quantity = cart_item.quantity
        order_item.save
      end

      redirect_to order_path(@order)
    else
      render 'carts/checkout'
    end
  end

  # 訂單明細
  def show
    @order = Order.find(params[:id])
    @order_items = @order.order_items
  end

  private

  def order_params
    params.require(:order).permit(:billing_name, :billing_address, :shipping_name, :shipping_address, :shipping_phone)
  end


end
