class CreateItems < ActiveRecord::Migration[7.0]
  def change
    create_table :items do |t|
      t.string :name
      t.text :description
      t.string :slug
      t.decimal :price
      t.integer :stock

      t.timestamps
    end
  end
end
