import EmberRouter from '@ember/routing/router';
import config from 'frontend/config/environment';

export default class Router extends EmberRouter {
  location = config.locationType;
  rootURL = config.rootURL;
}

Router.map(function () {
  this.route('users');
  this.route('fikas');
  this.route('login');
  this.route('signup');
  this.route('landing', { path: '/' });
});
