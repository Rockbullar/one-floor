const tweetDisplay = (twttr) => {
  twttr.widgets.createTweet(
    '20',
    document.querySelector('.tweet-here-pls'),
    {
      theme: 'dark'
    }
  )
}

export { tweetDisplay };
