class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, authentication_keys: [:wallet_id]
  has_many :nfts, through: :portfolio
  has_many :collections, through: :nfts

  acts_as_favoritor

  def watchlist
    favorites.where(scope: :watchlist).map(&:favoritable)
  end

  def watchlist_collections
    favorites.where(scope: :watchlist, favoritable_type: :Collection).map(&:favoritable)
  end

  def watchlist_nfts
    favorites.where(scope: :watchlist, favoritable_type: :Nft).map(&:favoritable)
  end

  def portfolio
    favorites.where(scope: :portfolio).map(&:favoritable)
  end

  def add_to_watchlist(nft_or_collection)
    favorite(nft_or_collection, scopes: :watchlist)
  end

  def add_to_portfolio(nft)
    favorite(nft, scopes: :portfolio)
  end
end
