import Service from '@ember/service';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';
import ENV from '../config/environment';

export default class SessionService extends Service {
  @tracked isAuthenticated = false;
  @tracked user = null;

  get authToken() {
    return localStorage.getItem('auth_token');
  }

  @action
  async authenticate(email, password) {
    const response = await fetch(`${ENV.apihost}/login`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ email, password }),
    });

    const data = await response.json();
    if (response.ok) {
      console.log('login success');
      this.isAuthenticated = true;
      this.user = data.user;
      localStorage.setItem('auth_token', data.token);
    } else {
      throw new Error('Invalid credentials');
    }
  }

  @action
  logout() {
    this.isAuthenticated = false;
    this.user = null;
    localStorage.removeItem('auth_token');
  }
}
