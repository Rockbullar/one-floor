class Nft < ApplicationRecord
  belongs_to :collection, optional: true
  belongs_to :user, optional: true

  acts_as_favoritable
end
