# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'uri'
require 'net/http'
require 'openssl'
require 'json'

contract_arr = ["0x2bd60f290060451e3644a7559d520c2e9b32c7e9","0xbc4ca0eda7647a8ab7c2061c2e118a18a936f13d","0xb47e3cd837ddf8e4c57f05d70ab865de6e193bbb","0x50f5474724e0ee42d9a4e711ccfb275809fd6d4a","0x60e4d786628fea6478f785a6d7e704777c86a7c6","0xf87e31492faf9a91b02ee0deaad50d51d56d5d4d","0x999e88075692bcee3dbc07e7e64cd32f39a1d3ab","0x469823c7b84264d1bafbcd6010e9cdf1cac305a3","0x9bf252f97891b907f002f2887eff9246e3054080","0xd4e4078ca3495de5b1d4db434bebc5a986197782"]

contract_arr.each do |contract|
  url = URI("https://api.opensea.io/api/v1/asset_contract/#{contract}")

  http = Net::HTTP.new(url.host, url.port)
  http.use_ssl = true
  request = Net::HTTP::Get.new(url)
  response = http.request(request)
  collection = JSON.parse(response.read_body)
  Collection.new({
    name: collection["collection"]["name"],
    description: collection["collection"]["description"],
    slug: collection["collection"]["slug"],
    twitter: collection["collection"]["twitter_username"],
    image_url: collection["collection"]["featured_image_url"],
    discord_url: collection["collection"]["discord_url"],
    total_supply: collection["collection"]["total_supply"],
    contract_id: contract
  })
end
