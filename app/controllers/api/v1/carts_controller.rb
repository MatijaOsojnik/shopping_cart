class Api::V1::CartsController < ApplicationController
  def show
    
  end
  def create
    @cart = Cart.new
    @cart.save
    @cart
  end
end
