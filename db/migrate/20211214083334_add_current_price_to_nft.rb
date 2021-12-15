class AddCurrentPriceToNft < ActiveRecord::Migration[6.1]
  def change
    add_column :nfts, :current_sale_price, :float
  end
end
