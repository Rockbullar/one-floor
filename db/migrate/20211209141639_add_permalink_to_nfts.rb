class AddPermalinkToNfts < ActiveRecord::Migration[6.1]
  def change
    add_column :nfts, :permalink, :string
  end
end
