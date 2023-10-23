import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["message"];

  connect() {
    setTimeout(() => this.hideNotice(), 2000);
  }

  hideNotice() {
    const message = this.messageTarget;
    message.classList.add('fade');
  }
}
