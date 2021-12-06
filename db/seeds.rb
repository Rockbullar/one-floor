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

def asset_stats

    wallet = 0x759c5f293edc487aa02186f0099864ebc53191c1

    url = URI("https://api.opensea.io/api/v1/collections?asset_owner=#{wallet}")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(url)

    response = http.request(request)
    user_serialized = response.read_body
    user = JSON.parse(user_serialized)

    user.each_with_index do |arr, index|
        if arr["primary_asset_contracts"].empty?
            puts "no name"
        else
            puts arr["primary_asset_contracts"][0]["name"]
        end
        puts floor(arr["slug"])
    end
end

def floor(slug)
    require 'uri'
    require 'net/http'
    require 'openssl'

    url = URI("https://api.opensea.io/api/v1/collection/#{slug}/stats")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(url)
    request["Accept"] = 'application/json'

    response = http.request(request)
    user_serialized = response.read_body
    user = JSON.parse(user_serialized)

    user["stats"]["floor_price"]
end

asset_stats
