class Api::V1::CartsController < ApplicationController
  before_action :authorized, except: [:create]
  # after_action :aws_user_cart_report, only: [:create, :update, :delete, :add_to_cart]

  def index
    user = current_user

    puts user.cart

    if user.cart
      render json: user.cart.as_json(include: { cart_items: { include: :item } })
    else
      render json: { error: "User has no carts." }
    end
  end

  def create
    @cart = Cart.new
    @cart.save
    @cart
  end

  def add_to_cart
    begin
      user = current_user

      item = Item.find_by_id(params[:item_id])

      @cart_items

      if CartItem.exists?(cart_id: user.cart.id, item_id: item.id)
        @cart_items = CartItem.find_by(cart_id: user.cart.id, item_id: item.id)
        if @cart_items.quantity + params[:quantity] <= item.stock
          @cart_items.quantity += params[:quantity]
        else
          render json: { error: "The quantity is larger than the item stock" }
          return true
        end
      else
        @cart_items = CartItem.new(cart_id: user.cart.id, item_id: item.id, quantity: params[:quantity])
      end

      @cart_items.save
      render json: { message: "Successfuly added item to cart" }
    rescue StandardError => e
      render json: { error: e }
    end
  end

  def remove_from_cart
    begin
      user = current_user
      item = Item.find_by_id(params[:item_id])

      CartItem.find_by(cart_id: user.cart.id, item_id: item.id).destroy

      render json: { message: "Successfuly removed item from cart" }
    rescue StandardError => e
      render json: { error: "Error adding item to cart" }
    end
  end

  def update_quantity
    begin
      user = current_user
      for item in params[:items]
        cart_item = CartItem.find_by(cart_id: user.cart.id, item_id: item.id)
        if item.quantity <= cart_item.item.stock
          cart_item.quantity = item.quantity
          cart_item.save
        end
      end
      render json: { message: "Successfuly updated cart." }
    rescue StandardError => e
      render json: { error: "Error updating cart." }
    end
  end

  def clear_cart
    begin
      user = current_user
      CartItem.find_by(cart_id: user.cart.id).destroy_all
      render json: { messsage: "Successfuly cleared cart" }
    rescue StandardError => e
      render json: { error: "Error clearing cart" }
    end
  end
end
