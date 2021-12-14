const addCollectionButton = document.querySelector('#add-collection-to-watchlist');
const addCollectionForm = document.querySelector('#watchlist-collection-form');
const addCollectionInput = document.querySelector('#add-collection-input');

} while (condition);

const showAddWatchlistCollectionForm = () => {
  if (addCollectionButton) {
    addCollectionButton.addEventListener("click", () => {
      addCollectionButton.hidden = true;
      addCollectionForm.hidden = false;
    })
  }
}

list = document.querySelector('search-results')
const displayCollections = () => {
  if (addCollectionInput) {
    addCollectionInput.addEventListener('click', (event) => {
      event.preventDefault();
      list.innerHTML = '';
      const input = document.querySelector('#search-input');
      fetchMovies(input.value);
    });
  }
}

const insertMovies = (data) => {
  data.Search.forEach((result) => {
    const movie = `<li>
      <img src="${result.Poster}" alt="" />
      <p>${result.Title}</p>
    </li>`;
    list.insertAdjacentHTML('beforeend', movie);
  });
};



export { showAddWatchlistCollectionForm, displayCollections }
