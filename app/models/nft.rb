class Nft < ApplicationRecord
  belongs_to :collection
  
  acts_as_favoritable
end
