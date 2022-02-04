// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

Rails.start()
Turbolinks.start()
ActiveStorage.start()

window.addEventListener("turbolinks:load", () => {
  const burger = document.querySelector('#hamburger');
  const navLinks = document.querySelector('#nav-links');
  if (burger) {
    burger.addEventListener('click', () => {
      navLinks.classList.toggle('show')
    })
  }
});
