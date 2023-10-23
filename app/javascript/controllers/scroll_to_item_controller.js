import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["item"];

  connect() {
    if (this.itemTarget) {
      this.itemTarget.scrollIntoView({ behavior: "smooth", block: "start" });
    }
  }
}
