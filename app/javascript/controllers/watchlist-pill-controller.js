// Visit The Stimulus Handbook for more details
// https://stimulusjs.org/handbook/introduction
//
// This example controller works with specially annotated HTML like:
//
// <div data-controller="hello">
//   <h1 data-target="hello.output"></h1>
// </div>

import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "24h", "7d", "30d", "nft", "addbutton" ]

  update_button_nft() {
    const url = `/updatesearch?query=${this.nameTarget.value}`
    fetch(url, { headers: { 'Accept': 'text/plain' } })
      .then(response => response.text())
      .then((data) => {
        this.outputTarget.innerHTML = data;
      })
  }
  update_button_collection() {
    this.addbuttonTarget.innerHTML = ''
  }

}
