require "open-uri"
require "pry-byebug"
class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
    etherscan_key = ENV["ETHERSCAN_KEY"]
    begin
      @eth_usd = JSON.parse(URI.open("https://api.etherscan.io/api?module=stats&action=ethprice&apikey=#{etherscan_key}").read)["result"]["ethusd"]
    rescue
      @eth_usd = 'error'
    end

    begin
      @gas_price = JSON.parse(URI.open("https://api.etherscan.io/api?module=gastracker&action=gasoracle&apikey=#{etherscan_key}").read)["result"]["SafeGasPrice"]
    rescue
      @gas_price = 'error'
    end

    # @watchlist_nfts = current_user.watchlist_nfts
    # @watchlist_nfts = current_user.watchlist_nfts.map do |nft|
    #   updated_nft(nft)
    # end

    # get watchlist_collections
    @watchlist_collections = current_user.watchlist_collections
    @watchlist_collections_addresses = @watchlist_collections.map(&:contract_id)
    # get collections from watchlist_nfts
    @watchlist_nfts = current_user.watchlist_nfts
    @watchlist_nfts_list = []
    current_user.watchlist_nfts.each do |nft|
      @watchlist_nfts_list.push([nft.collection.contract_id, nft.token_id])
    end

    @watchlist_nfts_list.each do |nft|
      unless @watchlist_collections_addresses.include?(nft[0])
        @watchlist_collections_addresses.push(nft[0])
      end
    end
    # call method to run api to update each collection
    @watchlist_collections_addresses.each do |collection_address|
      update_collection(collection_address)
      # update_collection function not written
    end

    # call method to run batch api to update each nft
    update_nfts(@watchlist_nfts_list)


    @watchlist_nfts_list = []
    current_user.watchlist_nfts.each do |nft|
      @watchlist_nfts_list.push([nft.collection.contract_id, nft.token_id])
    end
    @watchlist_nfts = current_user.watchlist_nfts
  end

  def about

  end

  private

  def update_collection(collection_address)

  end

  def update_nfts(nft_list)

  end

  def updated_nft(nft)
    nft_url = URI("https://api.opensea.io/api/v1/asset/#{nft.collection.contract_id}/#{nft.token_id}/")
    nft_http = Net::HTTP.new(nft_url.host, nft_url.port)
    nft_http.use_ssl = true
    nft_parsed = JSON.parse(nft_http.request(Net::HTTP::Get.new(nft_url)).read_body)

    nft.update! ({
      last_sale_eth_price: nft_parsed["last_sale"].nil? ? 0 : nft_parsed["last_sale"]["total_price"],
      highest_bid_eth_price: nft_parsed["orders"].empty? ? 0 : nft_parsed["orders"].max_by { |bid| bid["current_price"] }["current_price"].to_f,
    })

    nft
  end
end
