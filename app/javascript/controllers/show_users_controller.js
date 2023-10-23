import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static targets = ["friends", "users", "friendsButton", "usersButton"]

  showFriends() {
    this.friendsTarget.classList.toggle("hidden");
    const buttonText = this.friendsButtonTarget.textContent;
    this.friendsButtonTarget.textContent = buttonText == "Hide Friends" ? "Show Friends" : "Hide Friends";
  }

  showUsers(){
    this.usersTarget.classList.toggle("hidden");
    const buttonText = this.usersButtonTarget.textContent;
    this.usersButtonTarget.textContent = buttonText == "Show Other Users" ? "Hide Other Users" : "Show Other Users";
  }
}