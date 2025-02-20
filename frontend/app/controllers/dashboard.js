import Controller from '@ember/controller';
import { action } from '@ember/object';
import { tracked } from '@glimmer/tracking';

export default class DashboardController extends Controller {
  @tracked isSentFikaListVisible = false;
  @tracked isReceivedFikaListVisible = false;

  @action
  toggleSentFikaList() {
    this.isSentFikaListVisible = !this.isSentFikaListVisible;

    if ((this.isReceivedFikaListVisible = true)) {
      this.isReceivedFikaListVisible = !this.isReceivedFikaListVisible;
    }
  }

  @action
  toggleReceivedFikaList() {
    this.isReceivedFikaListVisible = !this.isReceivedFikaListVisible;

    if ((this.isSentFikaListVisible = true)) {
      this.isSentFikaListVisible = !this.isSentFikaListVisible;
    }
  }
}
