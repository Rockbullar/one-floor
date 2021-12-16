class Opensea
  def initialize(wallet_id)
    @base_url = 'https://api.opensea.io/api/v1'
    @wallet_id = wallet_id.downcase
  end

  # based on the wallet id, retrieve all the nfts associated with the wallet id
  # if the nft ald exist in the db, we'll just update if need to be updated
  def retrieve_nfts
    puts "From wallet #{@wallet_id}"
    port_url = URI("#{@base_url}/assets?owner=#{@wallet_id}&order_direction=desc&offset=0&limit=20")
    port_http = Net::HTTP.new(port_url.host, port_url.port)
    port_http.use_ssl = true
    port_request = Net::HTTP::Get.new(port_url)
    port_response = port_http.request(port_request)
    port_parsed = JSON.parse(port_response.read_body)
    nft_array = port_parsed["assets"]

    nft_array.map do |api_nft|
      x = retrieve_collection(api_nft["collection"]["slug"])
      unless x.nil?
        puts "Saving nft collection #{api_nft["collection"]["slug"]}"
        nft = Nft.find_or_create_by!(
          token_id: api_nft["token_id"],
          contract_id: api_nft["asset_contract"]["address"],
          collection: x
        )

        nft.image_url ||= api_nft["image_url"]
        nft.name ||= api_nft["name"]
        nft.slug ||= api_nft["collection"]["slug"]
        nft.permalink ||= api_nft["permalink"]
        # nft.twitter_url ||= "https://twitter.com/#{api_nft['collection']['twitter_username']}"
        # nft.discord_url ||= api_nft["collection"]["discord_url"]
        # binding.pry
        nft.user ||= User.find_by(wallet_id: @wallet_id)
        nft.last_sale_eth_price = api_nft["last_sale"].nil? ? 0 : api_nft["last_sale"]["total_price"]
        nft.highest_bid_eth_price = retrieve_highestbid_currentprice(nft)[:bid].nil? ? 0 : retrieve_highestbid_currentprice(nft)[:bid]
        nft.current_sale_price = retrieve_highestbid_currentprice(nft)[:price]
        nft.save!
      end
    end
  end

  def self.create_or_find_collection(slug)
    url = URI("https://api.opensea.io/api/v1/collection/#{slug}")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    request = Net::HTTP::Get.new(url)
    response = http.request(request)
    collection = JSON.parse(response.read_body)
    project = Collection.find_or_create_by!(
      slug: slug
    )
    begin
      project.name ||= collection["collection"]["primary_asset_contracts"][0]["name"]
      project.description ||= collection["collection"]["primary_asset_contracts"][0]["description"]
      project.contract_id ||= collection["collection"]["primary_asset_contracts"][0]["address"]
      project.twitter_username ||= collection["collection"]["twitter_username"]
      project.image_url ||= collection["collection"]["featured_image_url"]
      project.discord_url ||= collection["collection"]["discord_url"]
      project.twitter_url ||= "https://twitter.com/#{collection['collection']['twitter_username']}"
      project.floor_price = collection["collection"]["stats"]["floor_price"].to_f
      project.num_owners = collection["collection"]["stats"]["num_owners"].to_f
      project.total_supply = collection["collection"]["stats"]["total_supply"].to_f
      project.one_day_volume = collection["collection"]["stats"]["one_day_volume"].to_f
      project.one_day_change = collection["collection"]["stats"]["one_day_change"].to_f
      project.one_day_sales = collection["collection"]["stats"]["one_day_sales"].to_f
      project.one_day_average_price = collection["collection"]["stats"]["one_day_average_price"].to_f
      project.seven_day_volume = collection["collection"]["stats"]["seven_day_volume"].to_f
      project.seven_day_change = collection["collection"]["stats"]["seven_day_change"].to_f
      project.seven_day_sales = collection["collection"]["stats"]["seven_day_sales"].to_f
      project.seven_day_average_price = collection["collection"]["stats"]["seven_day_average_price"].to_f
      project.thirty_day_volume = collection["collection"]["stats"]["thirty_day_volume"].to_f
      project.thirty_day_change = collection["collection"]["stats"]["thirty_day_change"].to_f
      project.thirty_day_sales = collection["collection"]["stats"]["thirty_day_sales"].to_f
      project.thirty_day_average_price = collection["collection"]["stats"]["thirty_day_average_price"].to_f
      project.total_sales = collection["collection"]["stats"]["total_sales"].to_f
      # project.listed = self.listedcountscraper(slug)
    rescue
      return nil
    else
      project.save!
    end
    project
  end

  private

  def retrieve_highestbid_currentprice(nft)
    bid_url = URI("#{@base_url}/asset/#{nft.contract_id}/#{nft.token_id}/")
    bid_http = Net::HTTP.new(bid_url.host, bid_url.port)
    bid_http.use_ssl = true
    bid_request = Net::HTTP::Get.new(bid_url)
    bid_response = bid_http.request(bid_request)
    bid_parsed = JSON.parse(bid_response.read_body)
    highestbid_currentprice_arr = {}

    unless bid_parsed["orders"].empty?
      order_arr = bid_parsed["orders"]
      highest_bid_price_arr = order_arr.select do |entry|
        entry["side"] == 0
      end
      highest_bid = highest_bid_price_arr.max_by do |bid|
        bid["current_price"].to_f
      end
      if highest_bid_price_arr.empty?
        highestbid_currentprice_arr[:bid] = 0
      else
        highestbid_currentprice_arr[:bid] = highest_bid["current_price"].to_f
      end

      current_sale_price_arr = order_arr.select do |entry|
        entry["side"] == 1
      end
      if current_sale_price_arr.empty?
        highestbid_currentprice_arr[:price] = 0
      else
        current_sale = current_sale_price_arr.min_by do |price|
          price["current_price"].to_f
        end
        highestbid_currentprice_arr[:price] = current_sale["current_price"].to_f
      end
    end
    highestbid_currentprice_arr
  end

  def retrieve_collection(slug)
    url = URI("#{@base_url}/collection/#{slug}")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    request = Net::HTTP::Get.new(url)
    response = http.request(request)
    collection = JSON.parse(response.read_body)
    project = Collection.find_or_create_by!(
      slug: slug
    )
    # project.listed = listedcountscraper(slug)
    begin
      project.name ||= collection["collection"]["primary_asset_contracts"][0]["name"]
      project.description ||= collection["collection"]["primary_asset_contracts"][0]["description"]
      project.contract_id ||= collection["collection"]["primary_asset_contracts"][0]["address"]
      project.twitter_username ||= collection["collection"]["twitter_username"]
      project.image_url ||= collection["collection"]["image_url"]
      project.discord_url ||= collection["collection"]["discord_url"]
      project.twitter_url ||= "https://twitter.com/#{collection['collection']['twitter_username']}"
      project.floor_price = collection["collection"]["stats"]["floor_price"].to_f
      project.num_owners = collection["collection"]["stats"]["num_owners"].to_f
      project.total_supply = collection["collection"]["stats"]["total_supply"].to_f
      project.one_day_volume = collection["collection"]["stats"]["one_day_volume"].to_f
      project.one_day_change = collection["collection"]["stats"]["one_day_change"].to_f
      project.one_day_sales = collection["collection"]["stats"]["one_day_sales"].to_f
      project.one_day_average_price = collection["collection"]["stats"]["one_day_average_price"].to_f
      project.seven_day_volume = collection["collection"]["stats"]["seven_day_volume"].to_f
      project.seven_day_change = collection["collection"]["stats"]["seven_day_change"].to_f
      project.seven_day_sales = collection["collection"]["stats"]["seven_day_sales"].to_f
      project.seven_day_average_price = collection["collection"]["stats"]["seven_day_average_price"].to_f
      project.thirty_day_volume = collection["collection"]["stats"]["thirty_day_volume"].to_f
      project.thirty_day_change = collection["collection"]["stats"]["thirty_day_change"].to_f
      project.thirty_day_sales = collection["collection"]["stats"]["thirty_day_sales"].to_f
      project.thirty_day_average_price = collection["collection"]["stats"]["thirty_day_average_price"].to_f
      project.total_sales = collection["collection"]["stats"]["total_sales"].to_f
    rescue
      return nil
    else
      project.save!
    end
    return project
  end

  def listedcountscraper(slug)
    puts "getting results from this #{slug}"
    uri = URI("https://opensea.io/collection/#{slug}?search[sortAscending]=true&search[sortBy]=PRICE&search[toggles][0]=BUY_NOW")
    html_content = Net::HTTP.get(uri)
    doc = Nokogiri::HTML(html_content)
    result = doc.search('div.AssetSearchView--results-count').first.text.strip.gsub(/(\,?\D*)/,'').to_f
  end

  def self.listedcountscraper(slug)
    html_content = URI.open("https://opensea.io/collection/#{slug}?search[sortAscending]=true&search[sortBy]=PRICE&search[toggles][0]=BUY_NOW").read
    doc = Nokogiri::HTML(html_content)
    result = doc.search('div.AssetSearchView--results-count').first.text.strip.gsub(/(\,?\D*)/,'').to_f
  end
end
