class AddUserToNft < ActiveRecord::Migration[6.1]
  def change
    add_reference :nfts, :user, foreign_key: true
  end
end
