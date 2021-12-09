class RemoveFloorPriceFromNfts < ActiveRecord::Migration[6.1]
  def change
    remove_column :nfts, :floor_price, :float
  end
end
