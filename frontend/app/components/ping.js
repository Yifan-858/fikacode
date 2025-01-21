import Component from '@glimmer/component';
import { action } from '@ember/object';
import { tracked } from '@glimmer/tracking';

export default class PingTestComponent extends Component {
  @tracked pingResponse = null;

  @action
  async fetchPingResponse() {
    try {
      const response = await fetch('http://127.0.0.1:3000/ping'); // Adjust the URL if your Rails server runs elsewhere
      if (!response.ok) {
        throw new Error('Failed to fetch ping response');
      }

      const data = await response.json();
      this.pingResponse = data.response; // Update the tracked property with the server's response
    } catch (error) {
      console.error('Error fetching ping response:', error);
      this.pingResponse = 'Error fetching server status.';
    }
  }
}
