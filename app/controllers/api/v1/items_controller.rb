class Api::V1::ItemsController < ApplicationController
  before_action :authorized, only: [:index]

  def index
    @items = Item.all
    render json: @items
  end

  def create
  end
end
