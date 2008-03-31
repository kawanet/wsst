use POSIX qw(strftime);
use Digest::MD5 ();

$package_name = sprintf("Services_%s_%s",
                        $tmpl->get('company_name'),
                        $tmpl->get('service_name'));

$package_dir = sprintf("Services/%s/%s",
                       $tmpl->get('company_name'),
                       $tmpl->get('service_name'));

$php_license_uri ||= {
    'PHP' => 'http://www.php.net/license/',
    'Apache' => 'http://www.apache.org/licenses/',
    'LGPL' => 'http://www.gnu.org/copyleft/lesser.html',
    'BSD style' => 'http://www.opensource.org/licenses/bsd-license.php',
    'BSD' => 'http://www.opensource.org/licenses/bsd-license.php',
    'MIT' => 'http://www.opensource.org/licenses/mit-license.html',
}->{$tmpl->get('license')};

$php_channel ||= "__uri";
$php_copyright ||= "";
$php_link ||= sprintf("http://localhost/%s", $package_name);
$php_license_abstract ||= "";

# sort files
{
    my @package_xml = grep(/package\.xml\.tmpl$/, @$files);
    my @other = grep(!/package\.xml\.tmpl$/, @$files);
    push(@other, @package_xml);
    @$files = @other;
}

sub make_params_conf {
    my ($method, $indent, $indstr) = @_;
    $indent ||= 0;
    $indstr ||= "    ";
    
    my $conf = {};
    
    foreach my $param (@{$method->{params}}) {
        next if $param->{fixed};
        push(@{$conf->{'keys'}}, $param->{name});
    }
    
    foreach my $param (@{$method->{params}}) {
        if ($param->{'require'} eq 'true') {
            $conf->{'notnull'}->{$param->{name}}++;
        }
        
        if ($param->{default}) {
            $conf->{defaults}->{$param->{name}} = $param->{default};
        }

        if ($param->{fixed}) {
            $conf->{fixed}->{$param->{name}} = $param->{fixed};
        }
    }
    
    if (exists $conf->{'notnull'}) {
        $conf->{'notnull'} = [sort keys %{$conf->{'notnull'}}];
    }
    
    my $result = make_php_array($conf, $indent, $indstr);
    $result =~ s/^\s+//;
    
    return $result;
}

sub make_response_conf {
    my ($method, $indent, $indstr) = @_;
    $indent ||= 0;
    $indstr ||= "    ";
    
    my $conf = {};

    my $que = [[$method->{'return'}]];
    while (@$que) {
        my $node = shift(@$que);
        foreach my $n (@$node) {
            if (exists $n->{children}) {
                push(@$que, $n->{children});
            }
            if ($n->{multiple} eq 'true') {
                $conf->{'force_array'}->{$n->{name}}++;
            }
        }
    }
    
    if (exists $conf->{'force_array'}) {
        $conf->{'force_array'} = [sort keys %{$conf->{'force_array'}}];
    }
    
    my $result = make_php_array($conf, $indent, $indstr);
    $result =~ s/^\s+//;
    
    return $result;
}

sub make_php_array {
    my ($data, $indent, $indstr) = @_;
    $indent ||= 0;
    $indstr ||= "    ";
    
    sub rec_func {
        my ($dd, $ii, $is) = @_;
        
        my $pf = $is x $ii;
        
        my $ref = ref $dd;
        if ($ref eq 'HASH') {
            my $res = [];
            push(@$res, "${pf}array(");
            foreach my $ddd (sort keys %$dd) {
                my $dddd = rec_func($dd->{$ddd}, $ii+1, $is);
                $dddd =~ s/^$pf$is//;
                push(@$res, "$pf$is'$ddd' => $dddd,");
            }
            push(@$res, "${pf})");
            return join("\n", @$res);
        } elsif ($ref eq 'ARRAY') {
            my $res = [];
            push(@$res, "${pf}array(");
            foreach my $ddd (@$dd) {
                push(@$res, rec_func($ddd, $ii+1, $is) . ",");
            }
            push(@$res, "${pf})");
            return join("\n", @$res);
        }
        
        return "$pf'$dd'";
    }
    
    return rec_func($data, $indent, $indstr);
}

sub make_package_contents {
    my $strs = [];
    
    my $md5 = Digest::MD5->new();
    
    foreach my $file (@$result) {
        my $cfile = $file;
        $cfile =~ s#^\Q$odir\E/##;
        
        my $md5sum = "";
        if (open(IN, $file)) {
            $md5->addfile(\*IN);
            $md5sum = sprintf(' md5sum="%s"', $md5->hexdigest);
            $md5->reset();
            close(IN);
        }
        
        my $role = 'php';
        $role = 'test' if $cfile =~ /tests/;
        $role = 'doc' if $cfile =~ /docs/;
        
        my $bid = "Services/" . $tmpl->get('company_name');
        
        my $ostr =<<EOS;
   <file baseinstalldir="$bid"$md5sum name="$cfile" role="$role">
    <tasks:replace from="\@package_version\@" to="version" type="package-info" />
   </file>
EOS
        push(@$strs, $ostr);
    }
    
    my $str = join("", @$strs);
    $str =~ s/\s+$//;
    
    return $str;
}

1;
