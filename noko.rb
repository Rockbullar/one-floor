require 'open-uri'
require 'nokogiri'

  def listedcountscraper
    html_content = URI.open('https://opensea.io/collection/boredapeyachtclub?search[sortAscending]=true&search[sortBy]=PRICE&search[toggles][0]=BUY_NOW').read
    doc = Nokogiri::HTML(html_content)
    doc.search('div.AssetSearchView--results-count').map do |count|
      result = count.text.strip
      result
    end
  end

  p listedcountscraper
