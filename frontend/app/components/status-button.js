import Component from '@glimmer/component';
import { action } from '@ember/object';
import { inject as service } from '@ember/service';
import { tracked } from '@glimmer/tracking';

export default class FikaButtonComponent extends Component {
  @service fika;

  @tracked localStatus = this.args.fikaStatus;

  @action
  async updateFikaStatus(status) {
    try {
      await this.fika.updateFikaStatus(this.args.fikaId, status);
      this.localStatus = status;

      this.fika.loadFikas();
    } catch (error) {
      console.error(`Failed to update status to ${status}:`, error);
    }
  }
}
