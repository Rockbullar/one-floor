require "open-uri"
require "json"
require "typhoeus"
require "nokogiri"

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
      # @gas_price = JSON.parse(URI.open("https://api.etherscan.io/api?module=gastracker&action=gasoracle&apikey=#{etherscan_key}").read)["result"]["SafeGasPrice"]
      @gas_seller = opengasscraper[4][0].to_f
      @gas_buyer = opengasscraper[5][0].to_f
    rescue
      # @gas_price = 'error'
      @gas_seller = 'error'
      @gas_buyer = 'error'
    end

    if user_signed_in?
      @nfts = current_user.nfts
      @watchlist_nfts = current_user.watchlist_nfts
      @collections = current_user.watchlist_collections
    else
      @nfts = Nft.first(5)
      @watchlist_nfts = Nft.last(5)
      @collections = Collection.first(5)
    end

    articles_service = Articles.new
    @articles = articles_service.call

    # @nfts = Nft.all
    # @nfts = User.where(wallet_id: "0x241Af3d9a9959d0E78353Ff26f62A3eB7798202D").nfts

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

  private

  def opengasscraper
    html_content = URI.open('https://pumpmygas.xyz/').read
    doc = Nokogiri::HTML(html_content)
    doc.search('span.text-2xl.sm\:text-3xl.font-light.tracking-tight').map do |price|
      result = []
      result << price.text.strip
    end
  end

end
