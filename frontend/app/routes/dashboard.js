import Route from '@ember/routing/route';
import { inject as service } from '@ember/service';

export default class DashboardRoute extends Route {
  @service router;
  @service session;
  @service fika;
  @service community;

  beforeModel() {
    if (!this.session.isAuthenticated) {
      this.router.transitionTo('login');
    }
  }

  async model() {
    try {
      const [community, sentFikas, receivedFikas] = await Promise.all([
        this.community.getCommunity(),
        this.fika.getSentFikas(),
        this.fika.getReceivedFikas(),
      ]);

      return {
        currentUser: this.session.user,
        otherUsers: community,
        sentFikas: sentFikas,
        receivedFikas: receivedFikas,
      };
    } catch (error) {
      console.error('Error fetching data for dashboard:', error);
      return {};
    }
  }
}
