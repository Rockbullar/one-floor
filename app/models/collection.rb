class Collection < ApplicationRecord
  has_many :nfts, dependent: :destroy

  acts_as_favoritable
end
