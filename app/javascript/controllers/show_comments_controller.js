import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static targets = ["commentForm", "postComments", "commentComments", "postCommentsButton", "commentCommentsButton"];

  showCommentForm() {
    this.commentFormTarget.classList.toggle("hidden");
    this.commentFormTarget.reset();
  }

  showPostComments() {
    this.postCommentsTarget.classList.toggle("hidden");

    if (this.postCommentsButtonTarget.textContent == "Show Comments") {
      this.postCommentsButtonTarget.textContent = "Hide Comments";
      this.postCommentsButtonTarget.insertAdjacentHTML('beforeend', '<ion-icon class="chevron" name="chevron-up-outline"></ion-icon>');
    } else {
      this.postCommentsButtonTarget.textContent = "Show Comments";
      this.postCommentsButtonTarget.insertAdjacentHTML('beforeend', '<ion-icon class="chevron" name="chevron-down-outline"></ion-icon>')
    }
  }

  showCommentComments() {
    this.commentCommentsTarget.classList.toggle("hidden");

    if (this.commentCommentsButtonTarget.textContent == "Show Replies") {
      this.commentCommentsButtonTarget.textContent = "Hide Replies";
      this.commentCommentsButtonTarget.insertAdjacentHTML('beforeend', '<ion-icon class="chevron" name="chevron-up-outline"></ion-icon>');
    } else {
      this.commentCommentsButtonTarget.textContent = "Show Replies";
      this.commentCommentsButtonTarget.insertAdjacentHTML('beforeend', '<ion-icon class="chevron" name="chevron-down-outline"></ion-icon>')
    }
  }
} 