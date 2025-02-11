import Component from '@glimmer/component';
import { inject as service } from '@ember/service';

export default class FikaListComponent extends Component {
  @service fika;

  constructor() {
    super(...arguments);
    this.fika.loadFikas();
  }
}
