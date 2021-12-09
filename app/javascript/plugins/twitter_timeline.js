const tweetDisplay = (twttr) => {
  const url_arr = fetch("http://localhost:3000/tweet")
  console.log(url_arr)
  debugger
  url_arr.forEach((id) => {
    console.log(id);
  });
  twttr.widgets.createTweet(
    '20',
    document.querySelector('.tweet-here-pls'),
    {
      theme: 'dark'
    }
  )

  fetch
}

export { tweetDisplay };
