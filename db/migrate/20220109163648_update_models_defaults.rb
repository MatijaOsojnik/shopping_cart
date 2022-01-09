class UpdateModelsDefaults < ActiveRecord::Migration[7.0]
  def change
    change_column :items, :stock, :integer, default: 0
    change_column :carts, :total_price, :decimal, default: 0.0
    change_column :cart_items, :quantity, :integer, default: 0
  end
end
