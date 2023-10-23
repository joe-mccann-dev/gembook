  import { Controller } from "@hotwired/stimulus"

  export default class extends Controller {

    static targets = ["textArea", "fileInput"];

    validate(event) {
        event.preventDefault();

        const text = this.textAreaTarget.value;
        const file = this.fileInputTarget.files[0];

        if (!text.trim() && !file) {
          alert("Please enter text or submit text with an attached image");
          return;
        }
        
        if (text.trim().length < 10 && !file) {
          alert("Please make text posts 10 or more characters");
          return;
        }

        if (text.trim().length < 10 && file) {
          alert("Please include 10 or more text characters with your image post.");
          return;
        }
        
        this.element.requestSubmit();
    }
  }