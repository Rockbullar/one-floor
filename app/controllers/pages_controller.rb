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
    @watchlist_collections = current_user.watchlist_collections.to_a
    # @watchlist_collections_addresses = @watchlist_collections.map(&:contract_id)
    # get collections from watchlist_nfts
    @watchlist_nfts = current_user.watchlist_nfts

    @watchlist_nfts.each do |nft|
      unless @watchlist_collections.include?(nft)
        @watchlist_collections.push(nft)
      end
    end

    @watchlist_nfts_list = []
    current_user.watchlist_nfts.each do |nft|
      @watchlist_nfts_list.push([nft.collection.contract_id, nft.token_id])
    end

    # call method to run api to update each collection
    @watchlist_collections.each do |collection|
      update_collection(collection)
      # update_collection function not written
    end

    # call method to run batch api to update each nft
    update_nfts(@watchlist_nfts_list)


    @watchlist_nfts_list = []
    current_user.watchlist_nfts.each do |nft|
      @watchlist_nfts_list.push([nft.collection.contract_id, nft.token_id])
    end
    @watchlist_nfts = current_user.watchlist_nfts
    begin
      @portfolio = portfolio
    rescue
      @portfolio = 'xxx'
    end
    @nfts = current_user.nfts
    # begin
    #   @nfts = current_user.nfts
    #   raise

    #   #   # stats_url = URI("https://api.opensea.io/api/v1/collection/#{nft.slug}/stats")
    #   #   # stats_http = Net::HTTP.new(stats_url.host, stats_url.port)
    #   #   # stats_http.use_ssl = true
    #   #   # stats_request = Net::HTTP::Get.new(stats_url)
    #   #   # stats_response = stats_http.request(stats_request)
    #   #   # stats_collection = JSON.parse(stats_response.read_body)

    #   #   # # To remove later as total supply should be part of API call
    #   #   # nft["floor_price"] = stats_collection["stats"]["floor_price"].to_f
    #   #   # @nfts << nft
    #   # end
    #   # @portfolio = @nfts
    # rescue
    #   raise
    #   @portfolio = 'xxx'
    # end
  end

  def about
  end

  private

  def portfolio
    raise

  end

  def update_collection(collection)
    url = URI("https://api.opensea.io/api/v1/asset_contract/#{collection.contract_id}")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    request = Net::HTTP::Get.new(url)
    response = http.request(request)
    collection_update = JSON.parse(response.read_body)

    collection.update!({

    })
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
