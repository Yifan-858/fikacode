import Route from '@ember/routing/route';
import { inject as service } from '@ember/service';
import ENV from '../config/environment';

export default class DashboardRoute extends Route {
  @service session;
  @service router;

  beforeModel() {
    if (!this.session.isAuthenticated) {
      this.router.transitionTo('login');
    }
  }

  async model() {
    // return this.session.user;
    try {
      const response = await fetch(`${ENV.apihost}/users`, {
        method: 'GET',
        headers: {
          Authorization: `Bearer ${this.session.authToken}`,
        },
      });
      const users = await response.json();

      const otherUsers = users.filter(
        (user) => user.id !== this.session.user.id,
      );

      return {
        currentUser: this.session.user,
        otherUsers: otherUsers,
      };
    } catch (error) {
      console.error('Error fetching users', error);
      return [];
    }
  }
}
