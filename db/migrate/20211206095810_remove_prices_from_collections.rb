class RemovePricesFromCollections < ActiveRecord::Migration[6.1]
  def change
    remove_column :collections, :one_day_average_price, :float
    remove_column :collections, :seven_day_average_price, :float
  end
end
