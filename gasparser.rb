require 'open-uri'
require 'nokogiri'

def opengasscraper
  html_content = URI.open('https://pumpmygas.xyz/').read
  doc = Nokogiri::HTML(html_content)
  doc.search('span.text-2xl.sm\:text-3xl.font-light.tracking-tight').map do |price|
    result = []
    result << price.text.strip
  end
end

p opengasscraper[4][0].to_f
