#!perl

use strict;
use warnings;
use utf8;

use LWP::Online ':skip_all';
use Test::More 0.88 tests => 4;
use WebService::BambooHR;
my $domain  = 'testperl';
my $api_key = 'bfb359256c9d9e26b37309420f478f03ec74599b';
my $bamboo;
my @changes;

SKIP: {

    my $bamboo = WebService::BambooHR->new(
                        company => $domain,
                        api_key => $api_key);
    ok(defined($bamboo), "create BambooHR class");

    eval {
        @changes = grep { $_->lastChanged lt '2016-02-02T00:00:01Z' }
                   $bamboo->changed_employees('2016-01-01T00:00:01Z');
    };
    ok(!$@ && @changes > 0, 'get changes list');
    ok(@changes == 10, 'expected number of changes');

    my $changes_string = render_changes(\@changes);
    my $expected_changes_string = read_data();
    is($changes_string, $expected_changes_string, "compare changes fields");

};

sub render_changes
{
    my $changes_ref = shift;
    my $result = "id|action|lastChanged\n";

    foreach my $change (@$changes_ref) {
        $result .= $change->id
                   .'|'
                   .$change->action
                   .'|'
                   .$change->lastChanged
                   ."\n";
    }

    return $result;
}

sub read_data
{
    local $/;
    return scalar <DATA>;
}

__DATA__
id|action|lastChanged
11638|Updated|2016-01-01T07:34:59+00:00
11660|Updated|2016-01-01T07:34:59+00:00
11667|Updated|2016-01-01T07:34:59+00:00
40342|Updated|2016-01-01T07:34:59+00:00
40344|Updated|2016-01-01T07:34:59+00:00
40345|Updated|2016-01-01T07:34:59+00:00
11629|Updated|2016-02-01T07:31:30+00:00
11631|Updated|2016-02-01T07:31:30+00:00
11702|Updated|2016-02-01T07:31:30+00:00
11716|Updated|2016-02-01T07:31:30+00:00
