class AddColumnsToCollections < ActiveRecord::Migration[6.1]
  def change
    add_column :collections, :floor_price, :float
    add_column :collections, :num_owners, :integer
    add_column :collections, :twitter_url, :string
    add_column :collections, :permalink, :string
  end
end
