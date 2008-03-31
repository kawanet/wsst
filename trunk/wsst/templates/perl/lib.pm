$package_name = sprintf("WebService::%s::%s",
                        $tmpl->get('company_name'),
                        $tmpl->get('service_name'));

$package_dir = sprintf("WebService/%s/%s",
                       $tmpl->get('company_name'),
                       $tmpl->get('service_name'));

# sort files
{
    my @tmp = grep(m#t/{test_seq\(\)}_{service_name}\.t\.tmpl$#, @$files);
    my @other = grep(!m#t/{test_seq\(\)}_{service_name}\.t\.tmpl$#, @$files);
    push(@other, @tmp);
    @$files = @other;

    @tmp = grep(m#t/00_pod\.t\.tmpl$#, @$files);
    @other = grep(!m#t/00_pod\.t\.tmpl$#, @$files);
    push(@other, @tmp);
    @$files = @other;

    @tmp = grep(m/MANIFEST\.tmpl$/, @$files);
    @other = grep(!m#t/{n}_{service_name}\.t\.tmpl$#, @$files);
    push(@other, @tmp);
    @$files = @other;
}

# register listeners
#{
#    push(@{$listeners->{post_generate}}, \&exec_make_dist_sh);
#}

sub make_query_fields {
    my ($method) = @_;
    
    my $query_fields = [];
    
    foreach my $param (@{$method->{params}}) {
        next if $param->{fixed};
        push(@$query_fields, $param->{name});
    }
    
    return join(", ", map {"'$_'"} @$query_fields);
}

sub make_default_param {
    my ($method) = @_;
    
    my $default_param = {};
    
    foreach my $param (@{$method->{params}}) {
        $default_param->{$param->{name}} = $param->{default}
            if $param->{default};

        $default_param->{$param->{name}} = $param->{fixed}
            if $param->{fixed};
    }
    
    return join(", ", map {"'$_' => '$default_param->{$_}'"} keys %$default_param);
}

sub make_notnull_param {
    my ($method) = @_;
    
    my $notnull = [];
    
    foreach my $param (@{$method->{params}}) {
        push(@$notnull, $param->{name}) if $param->{'require'} eq 'true';
    }
    
    return join(", ", map {"'$_'"} @$notnull);
}

sub make_elem_fields {
    my ($method) = @_;
    
    my $blocks = {};
    
    my $rets = [$method->{'return'}, $method->{'error'}];
    while (@$rets) {
        my $ret = shift(@$rets);
        next unless ref $ret->{children};
        foreach my $child (@{$ret->{children}}) {
            push(@{$blocks->{$ret->{name}}}, $child->{name});
            push(@$rets, $child);
        }
    }
    
    my $result = "";
    foreach my $key (sort keys %$blocks) {
        $result .= "    '$key' => [";
        $result .= join(", ", map {"'$_'"} @{$blocks->{$key}});
        $result .= "],\n";
    }
    
    $result =~ s/^\s+//;
    
    return $result;
}

sub make_force_array {
    my ($method) = @_;
    
    my $force_array = {};
    
    my $que = [[$method->{'return'}]];
    while (@$que) {
        my $node = shift(@$que);
        foreach my $n (@$node) {
            if (exists $n->{children}) {
                push(@$que, $n->{children});
            }
            if ($n->{multiple} eq 'true') {
                $force_array->{$n->{name}}++;
            }
        }
    }
    
    return join(", ", map {"'$_'"} sort keys %$force_array);
}

sub make_pod_test_files {
    my @libs = grep(m#^\Q$odir\E/lib/#, @$result);
    return join("\n", map { s#^\Q$odir\E/##; "    $_" } @libs);
}

#sub exec_make_dist_sh {
#    local $tmp_dir = $tmp_dir;
#    $tmp_dir =~ s/([\&\;\`\'\\\"\|\*\?\~\<\>\^\(\)\[\]\{\}\$\n\r ])/\\$1/g;
#    local $odir = $odir;
#    $odir =~ s/([\&\;\`\'\\\"\|\*\?\~\<\>\^\(\)\[\]\{\}\$\n\r ])/\\$1/g;
#    print STDERR ">>> exec make-dist.sh\n";
#    `$tmpl_dir/make-dist.sh $odir >&2`;
#    WSST::Exception->raise("failed exec_make_dist_sh: ret=$?") if $?;
#    print STDERR "<<< done make-dist.sh\n\n";
#}

my $test_seq_val = 1;
sub test_seq {
    return sprintf("%02d", $test_seq_val++);
}

1;
