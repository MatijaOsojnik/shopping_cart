class Api::V1::CartsController < ApplicationController
  before_action :authorized, except: [:create]
  after_action :aws_user_cart_report, only: [:create, :update, :delete]

  def show
    @cart = Cart.find_by(user_id: params[:user_id])
    if @cart
      render json: @cart.as_json(include: {cart_items: {include: :item}})
    else
      render json: {error: "User has no carts."}
    end
  end
  
  def create
    @cart = Cart.new
    @cart.save
    @cart
  end

  def add_to_cart
    cart = Cart.find_by(user_id: params[:user_id])
    item = Item.find_by_id(params[:item_id])

    @cart_items = CartItem.new(cart_id: cart.id, item_id: item.id)

    if @cart_items.save
      render json: {message: "Successfuly added item to cart"}
    else
      render json: {error: "Error adding item to cart"}
    end
  end
end
