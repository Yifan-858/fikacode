import Service from '@ember/service';
import { inject as service } from '@ember/service';
import ENV from '../config/environment';

export default class FikaService extends Service {
  @service session;

  async getSentFikas() {
    try {
      const response = await fetch(
        `${ENV.apihost}/fikas?sender_id=${this.session.user.id}`,
        {
          method: 'GET',
          headers: {
            Authorization: `Bearer ${this.session.authToken}`,
          },
        },
      );
      return await response.json();
    } catch (error) {
      console.error('Error fetching sent fikas', error);
      return [];
    }
  }

  async getReceivedFikas() {
    try {
      const response = await fetch(
        `${ENV.apihost}/fikas?receiver_id=${this.session.user.id}`,
        {
          method: 'GET',
          headers: {
            Authorization: `Bearer ${this.session.authToken}`,
          },
        },
      );
      return await response.json();
    } catch (error) {
      console.error('Error fetching received fikas', error);
      return [];
    }
  }
}
