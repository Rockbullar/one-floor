class AddSlugToCollections < ActiveRecord::Migration[6.1]
  def change
    add_column :collections, :slug, :string
    add_column :collections, :contract_id, :string
    add_column :collections, :description, :text
    add_column :collections, :name, :string
    add_column :collections, :total_supply, :integer
  end
end
