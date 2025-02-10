import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';
import { inject as service } from '@ember/service';

export default class FikaButtonComponent extends Component {
  @service fika;

  @tracked isFikaFormOpen = false;
  @tracked scheduledAt = '';
  @tracked errorMessage = '';

  @action
  openFikaForm() {
    this.isFikaFormOpen = true;
  }

  @action
  closeFikaForm() {
    this.isFikaFormOpen = false;
  }

  @action
  updateScheduledAt(event) {
    this.scheduledAt = event.target.value;
  }

  @action
  async submitFika() {
    if (!this.scheduledAt) {
      this.errorMessage = 'Please select a time.';
      return;
    }

    try {
      await this.fika.sendFika(this.args.receiverId, this.scheduledAt);
      this.closeFikaForm();
    } catch (error) {
      console.error('Failed to send Fika:', error);
    }
  }
}
