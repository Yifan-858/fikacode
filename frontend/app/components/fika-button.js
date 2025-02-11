import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';
import { inject as service } from '@ember/service';

export default class FikaButtonComponent extends Component {
  @service fika;

  @tracked isFikaFormOpen = false;
  @tracked scheduledAt = '';
  @tracked errorMessage = '';

  get receiverId() {
    return this.args.receiverId;
  }

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
    console.log('Scheduled Time Updated:', event.target.value);
    this.scheduledAt = event.target.value;
  }

  @action
  async submitFika() {
    if (!this.scheduledAt) {
      this.errorMessage = 'Please select a time.';
      return;
    }

    try {
      console.log('Sending Fika to:', this.receiverId, 'At:', this.scheduledAt);
      await this.fika.sendFika(this.args.receiverId, this.scheduledAt);
      this.closeFikaForm();
      this.errorMessage = '';
    } catch (error) {
      console.error('Failed to send Fika:', error);
    }
  }
}
