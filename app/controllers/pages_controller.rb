require "open-uri"
require "json"
require "typhoeus"
require "nokogiri"

class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home, :watchlist, :landing ]

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
    @all_collections = Collection.all
    articles_service = Articles.new
    @articles = articles_service.call

    @slugs = Collection.select(:slug).map(&:slug)
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

    @watchlist_nfts = Nft.last(5) #remove when watchlist adding is complete
  end

  def landing
    begin
      @gas_seller = opengasscraper[4][0].to_f
      @gas_buyer = opengasscraper[5][0].to_f
    rescue
      @gas_seller = 'error'
      @gas_buyer = 'error'
    end

    @nfts = Nft.first(5)
    @watchlist_nfts = Nft.last(5)
    @collections = Collection.first(5)
  end

  def add_collection_to_watchlist
    new_collection = Opensea.create_or_find_collection(params['slug'])
    if new_collection.nil?
      flash.alert = "Invalid collection"
    else
      current_user.add_to_watchlist(new_collection)
    end
    redirect_to root_path(anchor: "watchlist-form")
  end

  def portfolio
    begin
      @gas_seller = opengasscraper[4][0].to_f
      @gas_buyer = opengasscraper[5][0].to_f
    rescue
      @gas_seller = 'error'
      @gas_buyer = 'error'
    end

    if user_signed_in?
      @nfts = current_user.nfts
    else
      @nfts = Nft.first(5)
    end
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
