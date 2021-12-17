require "open-uri"
require "json"
require "typhoeus"
require "nokogiri"

class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home, :watchlist, :landing, :portfolio]

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
      @watchlist_nfts = current_user.watchlist_nfts.reverse
      @collections = current_user.watchlist_collections.reverse
    else
      @nfts = Nft.first(10)
      @watchlist_nfts = Nft.last(10)
      @collections = Collection.first(5)
    end
    @all_collections = Collection.all
    articles_service = Articles.new
    @articles = articles_service.call
    @slugs = Collection.all.map(&:slug)
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
      @watchlist_nfts = current_user.watchlist_nfts.reverse
      @collections = current_user.watchlist_collections.reverse
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
      flash.alert = "Added to watchlist!"
    end
    redirect_back fallback_location: root_path
    # redirect_to root_path
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

  def update_search
    @collections = Collection.where("slug ILIKE ?", "%#{params['query']}%")
    respond_to do |format|
      format.text { render partial: 'shared/dashboard_grouped_collection_cards', locals: { collections: @collections }, formats: [:html] }
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
