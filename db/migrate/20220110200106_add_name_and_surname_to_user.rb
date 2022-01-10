class AddNameAndSurnameToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :email, :string
    add_column :users, :name, :string
    add_column :users, :surname, :string
    add_column :users, :phone, :string
  end
end
