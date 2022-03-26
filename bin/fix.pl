#!/usr/bin/env perl

use strict;
use warnings;
use Capture::Tiny qw(capture_stdout);

foreach my $file ( split /\n/,
    capture_stdout { system qw(find /usr/local -name perl5db.pl) } )
{
    my $found = qx{grep 'sub cmd_l ' $file};

    exit if $found;

    my $code = <<'HEREDOC';

sub DB::cmd_l {my (undef, $line) = @_;return _cmd_l_main($line)}

1;

HEREDOC

    open my $pdb, '>>', $file;
    print $pdb $code;
}
