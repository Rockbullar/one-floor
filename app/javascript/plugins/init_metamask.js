const ethereumButton = document.querySelector('.enableEthereumButton');
const showAccount = document.querySelector('.showAccount');

async function getAccount() {

  const accounts = await ethereum.request({ method: 'eth_requestAccounts' });
  const account = accounts[0];
  showAccount.innerHTML = account;
}

const initMetamask = () => {
  ethereumButton.addEventListener('click', () => {
    getAccount();
  });
};

export { initMetamask };
