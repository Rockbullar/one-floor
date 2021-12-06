class CreateNfts < ActiveRecord::Migration[6.1]
  def change
    create_table :nfts do |t|
      t.string :token_id
      t.string :contract_id
      t.float :last_sale_eth_price
      t.float :highest_bid_eth_price
      t.references :collection, null: false, foreign_key: true

      t.timestamps
    end
  end
end
