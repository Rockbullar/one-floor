class RemoveColumnsFromNfts < ActiveRecord::Migration[6.1]
  def change
    remove_column :nfts, :twitter_url, :string
    remove_column :nfts, :discord_url, :string
    remove_column :nfts, :permalink, :string
  end

end
