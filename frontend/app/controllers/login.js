import Controller from '@ember/controller';
import { action } from '@ember/object';
import { inject as service } from '@ember/service';
import { tracked } from '@glimmer/tracking';

export default class LoginController extends Controller {
  @service session;
  @service router;

  @tracked email = '';
  @tracked password = '';
  @tracked errorMessage = '';

  @action
  updateField(field, event) {
    this[field] = event.target.value;
  }

  @action
  async handleLogin(event) {
    event.preventDefault();

    if (!this.email.trim() || !this.password.trim()) {
      this.errorMessage = 'Email and password cannot be empty';
      return;
    }

    try {
      await this.session.authenticate(this.email, this.password);
      this.router.transitionTo('/dashboard');
    } catch (error) {
      this.errorMessage = 'Invalid email or password';
    }
  }
}
