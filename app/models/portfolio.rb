class Portfolio < ApplicationRecord
  belongs_to :nft
  belongs_to :user
end
