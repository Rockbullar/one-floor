require 'open-uri'
require 'nokogiri'

  def listedcountscraper
    html_content = URI.open("https://opensea.io/collection/sandbox?search[sortAscending]=true&search[sortBy]=PRICE&search[toggles][0]=BUY_NOW").read
    doc = Nokogiri::HTML(html_content)
    result = doc.search('div.AssetSearchView--results-count').first.text.strip.gsub(/(\,?\D*)/,'').to_f
  end

 p listedcountscraper
