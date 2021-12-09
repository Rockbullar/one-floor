class Opensea
  def initialize(wallet_id)
    @base_url = 'https://api.opensea.io/api/v1'
    @wallet_id = wallet_id
  end

  # based on the wallet id, retrieve all the nfts associated with the wallet id
  # if the nft ald exist in the db, we'll just update if need to be updated
  def retrieve_nfts
    port_url = URI("#{@base_url}/assets?owner=#{@wallet_id}&order_direction=desc&offset=0&limit=20")
    port_http = Net::HTTP.new(port_url.host, port_url.port)
    port_http.use_ssl = true
    port_request = Net::HTTP::Get.new(port_url)
    port_response = port_http.request(port_request)
    port_parsed = JSON.parse(port_response.read_body)
    nft_array = port_parsed["assets"]

    nft_array.map do |api_nft|
      nft = Nft.find_or_create_by!(
        token_id: api_nft["token_id"],
        contract_id: api_nft["asset_contract"]["address"],
        collection: retrieve_collection(api_nft["asset_contract"]["address"])
      )

      nft.image_url ||= api_nft["image_url"]
      nft.name ||= api_nft["name"]
      nft.slug ||= api_nft["collection"]["slug"]
      nft.twitter_url ||= "https://twitter.com/#{api_nft['collection']['twitter_username']}"
      nft.discord_url ||= api_nft["collection"]["discord_url"]
      nft.permalink ||= api_nft["permalink"]

      if User.find_by(wallet_id: @wallet_id)
        nft.user ||= User.find_by(wallet_id: @wallet_id)
      end

      nft.last_sale_eth_price = api_nft["last_sale"].nil? ? 0 : api_nft["last_sale"]["total_price"]
      nft.highest_bid_eth_price = retrieve_highest_bid(nft)
      nft.save!
    end
  end

  def update_eth_price

  private

  def retrieve_highest_bid(nft)
    bid_url = URI("#{@base_url}/asset/#{nft.contract_id}/#{nft.token_id}/")
    bid_http = Net::HTTP.new(bid_url.host, bid_url.port)
    bid_http.use_ssl = true
    bid_request = Net::HTTP::Get.new(bid_url)
    bid_response = bid_http.request(bid_request)
    bid_parsed = JSON.parse(bid_response.read_body)
    highest_bid_eth_price = 0

    unless bid_parsed["orders"].empty?
      order_arr = bid_parsed["orders"]
      highest_bid = order_arr.max_by do |bid|
        bid["current_price"]
      end

      highest_bid_eth_price = highest_bid["current_price"].to_f
    end

    highest_bid_eth_price
  end

  def retrieve_collection(contract_id)
    url = URI("#{@base_url}/asset_contract/#{contract_id}")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    request = Net::HTTP::Get.new(url)
    response = http.request(request)
    collection = JSON.parse(response.read_body)
    project = Collection.find_or_create_by!(
      contract_id: contract_id
    )

    project.name ||= collection["collection"]["name"]
    project.description ||= collection["collection"]["description"]
    project.slug ||= collection["collection"]["slug"]
    project.twitter_username ||= collection["collection"]["twitter_username"]
    project.image_url ||= collection["collection"]["featured_image_url"]
    project.discord_url ||= collection["collection"]["discord_url"]

    project.save!
    return project
  end
end