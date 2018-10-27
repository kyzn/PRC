package PRC::Controller::Auth;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

use PRC::GitHub;
use DateTime;

=encoding utf8

=head1 NAME

PRC::Controller::Auth - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=head2 login

This is where "Login with GitHub" button sends. Immediately redirects.

=cut

sub login :Path('/login') :Args(0) {
  my ($self, $c) = @_;

  my $redirect_url = $c->user_exists ? $c->uri_for('/') : PRC::GitHub->authenticate_url;
  $c->response->redirect($redirect_url,303);
  $c->detach;
}

=head2 login_error

A private action that sets an error message and detaches to '/'.

=cut

sub login_error :Private {
  my ($self, $c, $error) = @_;

  $error ||= 'Login was not successful, please try again.';
  $c->session->{alert_danger} = $error;
  $c->response->redirect($c->uri_for('/'),303);
  $c->detach;
}

=head2 callback

GitHub sends users here after authorization. We get a code.

=cut

sub callback :Path('/callback') :Args(0) {
  my ($self, $c) = @_;

  # TODO rate limit this endpoint.

  my $code         = $c->req->params->{code}               or $c->forward('login_error');
  my $access_token = PRC::GitHub->access_token($code)      or $c->forward('login_error');
  my $user_data    = PRC::GitHub->user_data($access_token) or $c->forward('login_error');
  my $github_email = PRC::GitHub->get_email($access_token) or $c->forward('login_error',
    ['We had trouble getting your primary verified email from GitHub. Please try again.']);

  # If existing user, update data. New user, add to DB.
  my $db_args = {
    last_login_time => DateTime->now->datetime,
    github_id       => $user_data->{id},
    github_login    => $user_data->{login},
    github_email    => $github_email,
    github_token    => $access_token,
    github_profile  => $user_data->{html_url},
  };
  my $rs   = $c->model('PRCDB::User');
  my $user = $rs->search({ github_id => $user_data->{id}})->first;
  if ($user){
    $user->update($db_args);
  } else {
    $user = $rs->create($db_args);
    # If that didn't work, kick out
    $c->forward('login_error') unless $user;
  }

  # TODO: Get repositories from https://api.github.com/user/repos

  # LOGIN HAPPENS!
  $c->authenticate({ user_id => $user->id });
  $c->response->redirect($c->uri_for('/'),303);
  $c->detach;

  # Now, a couple more things to do:
  # - checking if user has deactivated their account
  # - checking if user has agreed to legal (tos/pp/gdpr)
  # - if all good, sending user to their homepage!

  # In the meantime, we need to make sure they don't access anything in User Controller
  # So we will set a session variable here, and check it in User's auto.

}

=head2 logout

Clear session, logout, send to /.

=cut

sub logout :Path('/logout') :Args(0) {
  my ($self, $c) = @_;
  $c->delete_session;
  $c->logout;
  $c->response->redirect($c->uri_for('/'),303);
  $c->detach;
}

__PACKAGE__->meta->make_immutable;

1;