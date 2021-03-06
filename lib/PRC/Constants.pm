package PRC::Constants;
use namespace::autoclean;
use DateTime;

use base 'Exporter';

=encoding utf8

=head1 NAME

PRC::Constants - Provide our constants to other libraries

=head1 DESCRIPTION

Import to get our constants.

=cut

use constant { LATEST_LEGAL_DATE => DateTime->new(
  year => 2018, month => 11, day => 10
) };

use constant ASSIGNMENT_OPEN    => 0;
use constant ASSIGNMENT_SKIPPED => 1;
use constant ASSIGNMENT_DELETED => 2;
use constant ASSIGNMENT_DONE    => 10;

our @EXPORT = qw/
  LATEST_LEGAL_DATE

  ASSIGNMENT_OPEN
  ASSIGNMENT_SKIPPED
  ASSIGNMENT_DELETED
  ASSIGNMENT_DONE
/;

1;
