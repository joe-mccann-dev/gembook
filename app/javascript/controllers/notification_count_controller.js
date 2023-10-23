import { Controller } from "@hotwired/stimulus";

export default class extends Controller {

  decrementNotificationCount() {
    const notificationContainer = document.getElementById("notification-container");
    const notificationCountElement = document.getElementById("notificationCount");
    const numNotifications = parseInt(notificationCountElement.textContent);
    if (numNotifications === 1) {
      notificationContainer.classList.remove('notifications-count');
      notificationCountElement.remove();
    } else {
      notificationCountElement.textContent = numNotifications - 1;
    }
  }
}
