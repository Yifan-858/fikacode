import Controller from '@ember/controller';
import { action } from '@ember/object';
import { inject as service } from '@ember/service';
import { tracked } from '@glimmer/tracking';
import ENV from '../config/environment';

export default class SignupController extends Controller {
  @service session;
  @service router;

  @tracked name = '';
  @tracked email = '';
  @tracked password = '';
  @tracked role = '';
  @tracked introduction = '';
  @tracked submitError = '';

  @tracked successMessage = '';
  @tracked showForm = true;

  @tracked nameError = '';
  @tracked emailError = '';
  @tracked passwordError = '';
  @tracked roleError = '';
  @tracked introductionError = '';

  IsNameValid(userName) {
    this.nameError = '';

    if (!userName) {
      this.nameError = 'Name is required';
      return false;
    }

    if (typeof userName !== 'string') {
      this.nameError = 'Please enter a valid name with letters';
      return false;
    }
    return true;
  }

  IsEmailValid(userEmail) {
    this.emailError = '';

    if (!userEmail) {
      this.emailError = 'Email is required';
      return false;
    }

    const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
    if (!userEmail || !emailRegex.test(userEmail)) {
      this.emailError = 'Please enter a valid email';
      return false;
    }
    return true;
  }

  IsPasswordValid(userPassword) {
    this.passwordError = '';
    if (!userPassword || userPassword.length < 6) {
      this.passwordError =
        'Please enter a proper password no shorter then 6 characters';
      return false;
    }
    return true;
  }

  IsRoleValid(userRole) {
    this.roleError = '';
    const validRoles = ['mentor', 'student'];
    if (!userRole || !validRoles.includes(userRole.toLowerCase())) {
      this.roleError = 'Role must be either "mentor" or "student"';
      return false;
    }
    return true;
  }

  IsIntroductionValid(userIntroduction) {
    this.introductionError = '';
    if (!userIntroduction) {
      this.introductionError = 'Introduction is required';
      return false;
    } else if (userIntroduction.length > 500) {
      this.introductionError = 'Introduction cannot exceed 500 characters';
      return false;
    }
    return true;
  }

  @action
  updateField(field, event) {
    this[field] = event.target.value;
  }

  @action
  async handleSignup(event) {
    event.preventDefault();
    this.submitError = '';

    const isNameValid = this.IsNameValid(this.name);
    const isEmailValid = this.IsEmailValid(this.email);
    const isPasswordValid = this.IsPasswordValid(this.password);
    const isRoleValid = this.IsRoleValid(this.role);
    const isIntroductionValid = this.IsIntroductionValid(this.introduction);

    if (
      !isNameValid ||
      !isEmailValid ||
      !isPasswordValid ||
      !isRoleValid ||
      !isIntroductionValid
    ) {
      return;
    }

    try {
      const response = await fetch(`${ENV.apihost}/users`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          name: this.name,
          email: this.email,
          password: this.password,
          role: this.role,
          introduction: this.introduction,
        }),
      });

      const data = await response.json();

      if (response.ok) {
        this.successMessage =
          'Thank you for joining in! Redirecting to login...';
        this.showForm = false;

        setTimeout(() => {
          this.router.transitionTo('login');
        }, 3000);
      } else {
        if (data.errors) {
          this.submitError =
            data.errors[0] || 'An error occurred while signing up.';
        }
      }

      this.name = '';
      this.email = '';
      this.password = '';
      this.role = '';
      this.introduction = '';
    } catch (error) {
      this.submitError = 'Network error. Please try again later.';
    }
  }
}
