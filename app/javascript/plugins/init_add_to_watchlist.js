const addCollectionButton = document.querySelector('#add-collection-to-watchlist');
const addCollectionForm = document.querySelector('#watchlist-collection-form');

const showAddWatchlistCollectionForm = () => {
  if (addCollectionButton) {
    addCollectionButton.addEventListener("click", () => {
      addCollectionButton.hidden = true;
      addCollectionForm.hidden = false;
    })
  }
}


export { showAddWatchlistCollectionForm }
