class RemovePermalinkFromCollections < ActiveRecord::Migration[6.1]
  def change
    remove_column :collections, :permalink, :string
  end
end
