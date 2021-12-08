class AddAttribToNfts < ActiveRecord::Migration[6.1]
  def change
    add_column :nfts, :image_url, :string
    add_column :nfts, :name, :string
    add_column :nfts, :slug, :string
    add_column :nfts, :twitter_url, :text
    add_column :nfts, :discord_url, :text
    add_column :nfts, :permalink, :text
    add_column :nfts, :floor_price, :float
  end
end
