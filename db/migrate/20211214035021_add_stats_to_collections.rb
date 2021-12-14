class AddStatsToCollections < ActiveRecord::Migration[6.1]
  def change
    add_column :collections, :one_day_volume, :float
    add_column :collections, :one_day_change, :float
    add_column :collections, :one_day_sales, :float
    add_column :collections, :one_day_average_price, :float
    add_column :collections, :seven_day_volume, :float
    add_column :collections, :seven_day_change, :float
    add_column :collections, :seven_day_sales, :float
    add_column :collections, :seven_day_average_price, :float
    add_column :collections, :thirty_day_volume, :float
    add_column :collections, :thirty_day_change, :float
    add_column :collections, :thirty_day_sales, :float
    add_column :collections, :thirty_day_average_price, :float
    add_column :collections, :total_sales, :float
    add_column :collections, :listed, :float
  end
end
