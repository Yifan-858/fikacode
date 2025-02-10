import Service from '@ember/service';
import { inject as service } from '@ember/service';
import ENV from '../config/environment';

export default class CommunityService extends Service {
  @service session;

  async getCommunity() {
    try {
      const response = await fetch(
        `${ENV.apihost}/users?exclude_current=true`,
        {
          method: 'GET',
          headers: {
            Authorization: `Bearer ${this.session.authToken}`,
          },
        },
      );
      return await response.json();
    } catch (error) {
      console.error('Error fetching other users', error);
      return [];
    }
  }
}
