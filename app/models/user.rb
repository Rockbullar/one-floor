class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, authentication_keys: [:wallet_id]
  has_many :nfts, through: :portfolio
  has_many :collections, through: :nfts

  # def self.find_for_database_authentication(warden_conditions)
  #   conditions = warden_conditions.dup
  #   if login = conditions.delete(:login)
  #     where(conditions.to_h).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
  #   elsif conditions.has_key?(:wallet_id)
  #     where(conditions.to_h).first
  #   end
  # end
end
