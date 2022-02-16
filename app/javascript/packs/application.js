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
  const commentButtons = document.querySelectorAll('.comment-button');
  const toggleCommentsButtons = document.querySelectorAll('.toggle-comments');
  const toggleRepliesButtons = document.querySelectorAll('.toggle-replies');
  if (burger) {
    toggleBurger(burger, navLinks);
  }
  if (commentButtons) {
    toggleCommentBox(commentButtons)
  }
  if (toggleCommentsButtons) {
    toggleComments(toggleCommentsButtons);
  }

  if (toggleRepliesButtons) {
    toggleReplies(toggleRepliesButtons);
  }

  hideNotice();
});

function toggleCommentBox(commentButtons) {
  commentButtons.forEach((link) => {
    link.addEventListener('click', () => {
      const id = link.id.split('-')
      const commentBox = document.querySelector(`#comment-box-for-commentable-${id[0]}-${id[1]}`)
      commentBox.classList.toggle('visible')
    })
  })
}

function toggleBurger(burger, navLinks) {
  burger.addEventListener('click', () => {
    navLinks.classList.toggle('show')
  })
}

function toggleComments(buttons) {
  buttons.forEach((button) => {
    button.addEventListener('click', () => {
      const id = button.id.split('-')[2]
      const postComments = document.querySelector(`#post-${id}-comments`);
      postComments.classList.toggle('hidden');
      if (postComments.classList.contains('hidden')) {
        button.textContent = 'Show Comments'
        button.insertAdjacentHTML('beforeend', '<ion-icon class="chevron" name="chevron-down-outline"></ion-icon>')
      } else {
        button.textContent = 'Hide Comments'
        button.insertAdjacentHTML('beforeend', '<ion-icon class="chevron" name="chevron-up-outline"></ion-icon>')
      }
    })
  })
}

function toggleReplies(buttons) {
  buttons.forEach((button) => {
    button.addEventListener('click', () => {
      const id = button.id.split('-')[2]
      const postReplies = document.querySelector(`#comment-${id}-replies`);
      postReplies.classList.toggle('hidden');
      if (postReplies.classList.contains('hidden')) {
        button.textContent = 'Show Replies'
        button.insertAdjacentHTML('beforeend', '<ion-icon class="chevron" name="chevron-down-outline"></ion-icon>')
      } else {
        button.textContent = 'Hide Replies'
        button.insertAdjacentHTML('beforeend', '<ion-icon class="chevron" name="chevron-up-outline"></ion-icon>')
      }
    })
  })
}

function hideNotice() {
  const notification = document.querySelector('.notification')
  if (notification) {
    setInterval(function() {
      notification.classList.add('fade');
    }, 4000);
  }
}
