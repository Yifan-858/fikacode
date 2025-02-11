import Component from '@glimmer/component';
import { action } from '@ember/object';
import { inject as service } from '@ember/service';

export default class FikaButtonComponent extends Component {
  @service fika;

  @action
  async updateFikaStatus(status) {
    try {
      await this.fika.updateFikaStatus(this.args.fikaId, status);
    } catch (error) {
      console.error(`Failed to update status to ${status}:`, error);
    }
  }
}
