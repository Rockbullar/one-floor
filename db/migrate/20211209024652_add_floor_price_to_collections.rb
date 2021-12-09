class AddFloorPriceToCollections < ActiveRecord::Migration[6.1]
  def change
    add_column :collections, :floor_price, :float
  end
end
