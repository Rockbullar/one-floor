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

    begin
      @portfolio = portfolio
    rescue
      @portfolio = 'xxx'
    end
    @nfts = Nft.all
  end

  def about
  end

  private

  def portfolio
    @wallet = current_user.wallet_id
    @nfts = []

    port_url = URI("https://api.opensea.io/api/v1/assets?owner=#{@wallet}&order_direction=desc&offset=0&limit=20")
    port_http = Net::HTTP.new(port_url.host, port_url.port)
    port_http.use_ssl = true
    port_request = Net::HTTP::Get.new(port_url)
    port_response = port_http.request(port_request)
    port_parsed = JSON.parse(port_response.read_body)
    nft_array = port_parsed["assets"]
    # iteration for each nfts in portfolio
    nft_array.map do |nft|
      nft = Nft.new({
        token_id: nft["token_id"],
        contract_id: nft["asset_contract"]["address"],
        last_sale_eth_price: nft["last_sale"].nil? ? 0 : nft["last_sale"]["total_price"],
        image_url: nft["image_url"],
        name: nft["name"],
        slug: nft["collection"]["slug"],
        twitter_url: "https://twitter.com/#{nft["collection"]["twitter_username"]}",
        discord_url: nft["collection"]["discord_url"],
        permalink: nft["permalink"]
      })
      # API retrieving-single-asset for highest bid price
      bid_url = URI("https://api.opensea.io/api/v1/asset/#{nft.contract_id}/#{nft.token_id}/")
      bid_http = Net::HTTP.new(bid_url.host, bid_url.port)
      bid_http.use_ssl = true
      bid_request = Net::HTTP::Get.new(bid_url)
      bid_response = bid_http.request(bid_request)
      bid_parsed = JSON.parse(bid_response.read_body)

      if bid_parsed["orders"].empty?
        nft["highest_bid_eth_price"] = 0
      else
        order_arr = bid_parsed["orders"]
        highest_bid = order_arr.max_by do |bid|
          bid["current_price"]
        end

        nft["highest_bid_eth_price"] = highest_bid["current_price"].to_f
      end

      stats_url = URI("https://api.opensea.io/api/v1/collection/#{nft.slug}/stats")
      stats_http = Net::HTTP.new(stats_url.host, stats_url.port)
      stats_http.use_ssl = true
      stats_request = Net::HTTP::Get.new(stats_url)
      stats_response = stats_http.request(stats_request)
      stats_collection = JSON.parse(stats_response.read_body)

      # To remove later as total supply should be part of API call
      nft["floor_price"] = stats_collection["stats"]["floor_price"].to_f
      @nfts << nft
    end
    return @nfts
  end
end
