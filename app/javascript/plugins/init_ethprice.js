const etherscan_key = process.env.ETHERSCAN_KEY

const getEthData = async () => {
    fetch('https://min-api.cryptocompare.com/data/price?fsym=ETH&tsyms=USD')
    // fetch(`https://api.etherscan.io/api?module=stats&action=ethprice&apikey=${etherscan_key}`)
      .then(response => response.json())
      .then(data => {
        console.log(data);
        document.getElementById("info").innerHTML = data.USD
        // document.getElementById("info").innerHTML = data.result.ethusd
      });
};


const fetchEth = () => {
  setInterval(getEthData,1000);
};


export { fetchEth };
