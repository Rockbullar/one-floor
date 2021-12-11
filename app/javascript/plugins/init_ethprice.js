const getEthData = async () => {
    fetch('https://min-api.cryptocompare.com/data/price?fsym=ETH&tsyms=USD')
      .then(response => response.json())
      .then(data => {
        console.log(data);
        document.getElementById("info").innerHTML = data.USD
      });
}

// tcount = setInterval(function(){
//     tcount++
//   if (tcount==10 ) {getBtcData(); tcount=0}
//   document.getElementById("infotime").innerHTML = 'Next update in ' + (10-tcount) + ' seconds'
// },1000);

const fetchEth = () => {
  setInterval(getEthData,1000);
};


export { fetchEth };
