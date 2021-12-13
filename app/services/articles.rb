# service object that calls twitter api newsapi
require 'date'
class Articles
  def initialize
    @twitter_token = ENV['TWITTER_BEARER_TOKEN']
    @newsapi_token = ENV['NEWSAPI_TOKEN']
    @twitter_base_url = 'https://api.twitter.com/2/tweets/search/recent'
    @newsapi_base_url = 'https://newsapi.org/v2/everything?'
  end

  def call
    tweets = call_twitter_api
    news = call_news_api
    # raise
    (tweets + news).shuffle
  end

  private

  def call_twitter_api
    query = "(#BoredApeyc OR #CreatureNFT) -is:retweet"
    url = "https://api.twitter.com/2/tweets/search/recent"
    date_a = DateTime.now()

    query_params = {
      "query": query,
      "max_results": 10,
      "tweet.fields": "author_id,created_at",
      "expansions": "author_id",
      "user.fields": "description,profile_image_url"
    }

    options = {
      method: 'get',
      headers: {
        "User-Agent": "v2RecentSearchRuby",
        "Authorization": "Bearer #{@twitter_token}"
      },
      params: query_params
    }

    request = Typhoeus::Request.new(url, options)
    response = request.run
    results = JSON.parse(response.body)

    results["data"].map do |tweet|
      author_id = tweet["author_id"]
      author = results["includes"]["users"].find do |user|
        user["id"] == author_id
      end
      username = author["username"]
      {
        image_url: author["profile_image_url"],
        text: tweet["text"][0..50] + "...",
        link: "https://twitter.com/#{username}/status/#{tweet["id"]}",
        source: username,
        timestamp: ((Time.parse("#{date_a}\n\n") - Time.parse(tweet["created_at"]))/3600).to_i
      }
    end
  end

  def call_news_api
    keyword = "nft"
    today = Date.today
    date_from = today.strftime('%Y-%m-%d')
    date_to = today.strftime('%Y-%m-%d')
    date_a = DateTime.now()

    url = "#{@newsapi_base_url}"\
          "q=+#{keyword}&"\
          "from=#{date_from}&"\
          "to=#{date_to}&"\
          "sortBy=publishedAt&"\
          "language=en&"\
          "apiKey=#{@newsapi_token}"
    req = open(url).read
    response_body = JSON.parse(req)
    article_arr = response_body["articles"]
    article_arr.map do |article|
      {
        image_url: article["urlToImage"],
        text: article["title"][0..50],
        link: article["url"],
        source: article["source"]["name"],
        timestamp: ((Time.parse("#{date_a}\n\n") - Time.parse(article["publishedAt"]))/3600).to_i
      }
    end
  end
end
