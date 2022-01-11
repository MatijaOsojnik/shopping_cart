class Api::V1::ItemsController < ApplicationController
  before_action :authorized, except: [:index, :show]

  def index
    @items = Item.all
    render json: @items
  end

  def create
  end
end
