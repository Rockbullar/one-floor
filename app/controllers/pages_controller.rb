require "open-uri"
class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
    Opensea.update_single_collection('mutant-ape-yacht-club')
    Opensea.update_single_asset('0x60e4d786628fea6478f785a6d7e704777c86a7c6', '17107')
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

    if user_signed_in?
      @nfts = current_user.nfts
    else
      @nfts = Nft.all
    end


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
end
