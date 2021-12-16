const initLoadingWatchlist = () => {
  console.log('connected')
  let modal = document.querySelector('#modal-display')
  let selected_cards = document.querySelectorAll('#selected-collection')
  selected_cards.forEach(card => {
    card.addEventListener('click', () => modal.classList.toggle("none"));
  });
};

export { initLoadingWatchlist };
