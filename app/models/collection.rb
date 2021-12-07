class Collection < ApplicationRecord
  has_many :nfts
  
  acts_as_favoritable
end
