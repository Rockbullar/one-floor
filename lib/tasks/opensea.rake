namespace :opensea do
  desc "Retrieve NFT from opensea depending on the wallet_id (ignored if ald exist)"
  task retrieve_nfts: :environment do
    users = User.all
    users.each do |user|
      puts "Retrieving nfts for #{user.wallet_id}"
      wallet_id = user.wallet_id

      osea_service = Opensea.new(wallet_id)
      osea_service.retrieve_nfts
      puts "Done!"
    end
  end
end
