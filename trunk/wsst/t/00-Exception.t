use strict;
use Test::More tests => 17;

BEGIN { use_ok("WSST::Exception"); }

$WSST::COMMAND_OPTS = {
    'verbose' => 1,
};

can_ok('WSST::Exception', qw(to_string raise));

my $obj1 = WSST::Exception->new();
ok(ref $obj1, '$obj1->new()');
ok(!$obj1->{msg}, '$obj1->{msg}');
ok(!$obj1->{detail}, '$obj1->{detail}');
ok(!$obj1->to_string, '$obj1->to_string');
is("$obj1", "", '"$obj1"');

my $obj2 = WSST::Exception->new(msg=>'Test', detail=>'Detail Message');
ok(ref $obj2, '$obj2->new()');
is($obj2->{msg}, 'Test', '$obj2->{msg}');
is($obj2->{detail}, 'Detail Message', '$obj2->{detail}');
is($obj2->to_string, 'Detail Message', '$obj2->to_string');
is("$obj2", 'Detail Message', '"$obj2"');

eval {
    WSST::Exception->raise('Test');
};
my $obj3 = $@;
ok(ref $obj3, '$obj3->raise()');
is($obj3->{msg}, 'Test', '$obj3->{msg}');
is($obj3->{detail}, "Test at t/00-Exception.t line 27\n\teval {...} called at t/00-Exception.t line 26\n", '$obj3->{detail}');
is($obj3->to_string, "Test at t/00-Exception.t line 27\n\teval {...} called at t/00-Exception.t line 26\n", '$obj3->to_string');
is("$obj3", "Test at t/00-Exception.t line 27\n\teval {...} called at t/00-Exception.t line 26\n", '"$obj3"');

1;
