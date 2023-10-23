import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["navLinks"];

  toggleNavLinks() {
    this.navLinksTarget.classList.toggle('show');
  }
}