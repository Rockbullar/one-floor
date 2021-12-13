require "open-uri"
require "json"
require "typhoeus"
require "nokogiri"

class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home, :watchlist ]

  def home

    begin
      @gas_seller = opengasscraper[4][0].to_f
      @gas_buyer = opengasscraper[5][0].to_f
    rescue
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
  end

  def watchlist
    begin
      @gas_seller = opengasscraper[4][0].to_f
      @gas_buyer = opengasscraper[5][0].to_f
    rescue
      @gas_seller = 'error'
      @gas_buyer = 'error'
    end

    if user_signed_in?
      @watchlist_nfts = current_user.watchlist_nfts
      @collections = current_user.watchlist_collections
    else
      @watchlist_nfts = Nft.last(5)
      @collections = Collection.first(5)
    end
  end

  def add_collection_to_watchlist
    new_collection = Opensea.create_or_find_collection(params['slug'])
    unless new_collection.nil?
      current_user.add_to_watchlist(new_collection)
    end
    redirect_to root_path
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
