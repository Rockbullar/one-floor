require "open-uri"
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
  end

  def about

  end

  private

  def create_nft(collection, contract_id)
  #Adding 10 items to each collection using API: retrieving-assets
    nft_url = URI("https://api.opensea.io/api/v1/assets?asset_contract_address=#{contract_id}&order_by=sale_count&limit=10")
    nft_http = Net::HTTP.new(nft_url.host, nft_url.port)
    nft_http.use_ssl = true
    nft_request = Net::HTTP::Get.new(nft_url)
    nft_response = nft_http.request(nft_request)
    nft_parsed = JSON.parse(nft_response.read_body)
    nft_array = nft_parsed["assets"]

    # API is set to fetch 10 assets already, can amend as required
    nft_array.each do |nft|
      nft = Nft.new ({
        token_id: nft["token_id"],
        contract_id: contract_id,
        last_sale_eth_price: nft["last_sale"].nil? ? 0 : nft["last_sale"]["total_price"],
      })
      nft.collection = collection
      nft.save!

      # API retrieving-single-asset for highest big price
      bid_url = URI("https://api.opensea.io/api/v1/asset/#{nft.contract_id}/#{nft.token_id}/")
      bid_http = Net::HTTP.new(bid_url.host, bid_url.port)
      bid_http.use_ssl = true
      bid_request = Net::HTTP::Get.new(bid_url)
      bid_response = bid_http.request(bid_request)
      bid_parsed = JSON.parse(bid_response.read_body)

      nft.highest_bid_eth_price = bid_parsed["orders"].empty? ? 0 : bid_parsed["orders"][0]["current_price"].to_f #to update the itiration to compare largest bid later
      nft.save!
    end
  end
end
