import Service from '@ember/service';
import { inject as service } from '@ember/service';
import { tracked } from '@glimmer/tracking';
import ENV from '../config/environment';

export default class FikaService extends Service {
  @service session;

  @tracked fikas = [];

  //comnine sent and received fikas
  async loadFikas() {
    try {
      const sentFikas = await this.getSentFikas();
      const receivedFikas = await this.getReceivedFikas();

      this.fikas = [...sentFikas, ...receivedFikas];
    } catch (error) {
      console.error('Error loading fikas:', error);
    }
  }

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

  async sendFika(receiverId, scheduledAt) {
    try {
      const response = await fetch(`${ENV.apihost}/fikas`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          Authorization: `Bearer ${this.session.authToken}`,
        },
        body: JSON.stringify({
          sender_id: this.session.user.id,
          receiver_id: receiverId,
          status: 'pending',
          scheduled_at: scheduledAt,
        }),
      });

      if (!response.ok) {
        throw new Error('Failed to create fika');
      }
      window.location.reload();

      return await response.json();
    } catch (error) {
      console.error('Error creating fika', error);
      throw error;
    }
  }

  async updateFikaStatus(fikaId, status) {
    try {
      const response = await fetch(
        `${ENV.apihost}/fikas/${fikaId}/update_status`,
        {
          method: 'PATCH',
          headers: {
            'Content-Type': 'application/json',
            Authorization: `Bearer ${this.session.authToken}`,
          },
          body: JSON.stringify({ status }),
        },
      );

      if (!response.ok) {
        throw new Error('Failed to update fika status');
      }

      const updatedFika = await response.json();

      await this.loadFikas();
      window.location.reload();

      return updatedFika;
    } catch (error) {
      console.error('Error updating fika status:', error);
      throw error;
    }
  }
}
