require "aws"
class Api::V1::CartsController < ApplicationController
  include AWS

  before_action :authorized, except: [:create]
  after_action :export_report, except: [:index, :show]

  def index
    user = current_user
    
    if user.cart
      render json: user.cart.as_json(include: { cart_items: { include: :item } })
    else
      render json: { error: "User has no carts." }
    end
  end

  def create(user_id)
    @cart = Cart.new
    @cart.user_id = user.id
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
          render json: { error: "The cart item quantity is larger than the item stock" }
          return
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

      cart_item = CartItem.find_by(cart_id: user.cart.id, item_id: item.id)

      if cart_item
        cart_item.destroy
      else
        render json: { error: "Item not found"}
        return
      end

      render json: { message: "Successfuly removed item from cart" }
    rescue StandardError => e
      render json: { error: "Error removing item from cart" }
    end
  end

  def update_quantity
    begin
      user = current_user
      for item in params[:items]
        puts item[:id]
        cart_item = CartItem.find_by(cart_id: user.cart.id, item_id: item[:id])
        if cart_item && item[:quantity] <= cart_item.item.stock
          cart_item.quantity = item[:quantity]
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

      cart_items = CartItem.find_by(cart_id: user.cart.id)
      
      if cart_items
        cart_items.destroy_all
      else
        render json: { error: "Cart already empty"}
        return
      end
      CartItem.find_by(cart_id: user.cart.id).destroy_all
      render json: { messsage: "Successfuly cleared cart" }
    rescue StandardError => e
      render json: { error: "Error clearing cart" }
    end
  end
end
