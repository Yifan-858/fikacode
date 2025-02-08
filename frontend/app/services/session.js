import Service from '@ember/service';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';
import ENV from '../config/environment';

export default class SessionService extends Service {
  @tracked isAuthenticated = false;
  @tracked user = null;

  // keep the user logged in after refresh
  constructor() {
    super(...arguments);
    this.checkAuthToken();
  }

  get authToken() {
    return localStorage.getItem('auth_token');
  }

  checkAuthToken() {
    const token = this.authToken;
    if (token) {
      this.isAuthenticated = true;
      this.user = this.decodeToken(token);
    }
  }

  decodeToken(token) {
    try {
      const payload = JSON.parse(atob(token.split('.')[1]));
      return {
        id: payload.id,
        name: payload.name,
        role: payload.role,
        introduction: payload.introduction,
      };
    } catch (e) {
      console.error('Failed to decode token:', e);
      return null;
    }
  }
  //

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
