use utf8;
package PRC::Schema::Result::User;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

PRC::Schema::Result::User

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 TABLE: C<user>

=cut

__PACKAGE__->table("user");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 create_time

  data_type: 'datetime'
  default_value: current_timestamp
  is_nullable: 0

=head2 update_time

  data_type: 'datetime'
  default_value: current_timestamp
  is_nullable: 0

=head2 name

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 email_address

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "create_time",
  {
    data_type     => "datetime",
    default_value => \"current_timestamp",
    is_nullable   => 0,
  },
  "update_time",
  {
    data_type     => "datetime",
    default_value => \"current_timestamp",
    is_nullable   => 0,
  },
  "name",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "email_address",
  { data_type => "varchar", is_nullable => 1, size => 255 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07049 @ 2018-10-13 18:04:30
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:zVuexFuRCp7mBKN+A+xVRw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;