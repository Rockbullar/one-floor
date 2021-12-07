const ethereumButton = document.querySelector('.enableEthereumButton');
const showAccount = document.querySelector('.showAccount');
const deviseArea = document.querySelector('.devise');
const walletInput = document.querySelector('#user_wallet_id')
let currentAccount = null;

async function getAccount() {

  const accounts = await ethereum.request({ method: 'eth_requestAccounts' });
  const account = accounts[0];
  showAccount.innerHTML = account;
}

const handleAccountsChanged = (accounts) => {
  if (accounts.length === 0) {
    // MetaMask is locked or the user has not connected any accounts
    console.log('Please connect to MetaMask.');
  } else {
    console.log('connected and check devise')
    walletInput.setAttribute('value', accounts[0])
  }
}


const connect = () => {
  ethereum
    .request({ method: 'eth_requestAccounts' })
    .then(handleAccountsChanged)
    .catch((err) => {
      if (err.code === 4001) {
        // EIP-1193 userRejectedRequest error
        // If this happens, the user rejected the connection request.
        console.log('Please connect to MetaMask.');
      } else {
        console.error(err);
      }
    });
}

const initMetamask = () => {
  if (deviseArea) {
    connect();
  }


  // ethereumButton.addEventListener('click', () => {
  //   getAccount();
  // });
};

export { initMetamask };
