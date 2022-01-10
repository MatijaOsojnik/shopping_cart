class Api::V1::CartsController < ApplicationController
  before_action :authorized, except: [:create]
  # after_action :aws_user_cart_report, only: [:create, :update, :delete, :add_to_cart]

  def show
    user = logged_in_user
    @cart = Cart.find_by(user_id: user.id)
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
    begin
      user = logged_in_user
      cart = Cart.find_by(user_id: user.id)
      item = Item.find_by_id(params[:item_id])

      @cart_items

      if CartItem.exists?(cart_id: cart.id, item_id: item.id)
        @cart_items = CartItem.find_by(cart_id: cart.id, item_id: item.id)
        @cart_items.quantity+=params[:quantity]
      else
        @cart_items = CartItem.new(cart_id: cart.id, item_id: item.id, quantity: params[:quantity])
      end
      
      @cart_items.save
      render json: {message: "Successfuly added item to cart"}
    rescue StandardError => e
      render json: {error: e}
    end
  end

  def remove_from_cart
    begin
      user = logged_in_user
      cart = Cart.find_by(user_id: user.id)
      item = Item.find_by_id(params[:item_id])
  
      CartItem.find_by(cart_id: cart.id, item_id: item.id).destroy
      
      render json: {message: "Successfuly removed item from cart"}
    rescue StandardError => e
      render json: {error: "Error adding item to cart"}
    end
  end

  def update_quantity
  end

  def clear_cart
    begin
      user = logged_in_user
      cart = Cart.find_by(user_id: user.id)
      CartItem.find_by(cart_id: cart.id).destroy_all
      render json: {messsage: "Successfuly cleared cart"}
    rescue StandardError => e
      render json: {error: "Error clearing cart"}
    end
  end
end
