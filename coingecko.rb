require 'open-uri'
require 'json'

apiKey = "25638f9687ad481d8831606d3ad9ce97"
keyword = "nft"
date_from = "2021-12-01"
date_to = "2021-12-08"

url = "https://newsapi.org/v2/everything?"\
      "q=+#{keyword}&"\
      "from=#{date_from}&"\
      "to=#{date_to}&"\
      "sortBy=publishedAt&"\
      "language=en&"\
      "apiKey=#{apiKey}"
req = open(url).read
response_body = JSON.parse(req)
article_arr = response_body["articles"]

article_arr.each do |article|
  puts article["title"]
  puts article["description"]
end
