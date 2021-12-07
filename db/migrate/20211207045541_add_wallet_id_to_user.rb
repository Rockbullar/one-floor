class AddWalletIdToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :wallet_id, :string
  end
end
