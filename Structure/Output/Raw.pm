package CSS::Structure::Output::Raw;

# Pragmas.
use base qw(CSS::Structure::Output::Core);
use strict;
use warnings;

# Modules.
use Readonly;

# Constants.
Readonly::Scalar my $EMPTY_STR => q{};

# Version.
our $VERSION = 0.01;

# Resets internal variables.
sub reset {
	my $self = shift;

	# Reset internal variables from *::Core.
	$self->SUPER::reset;

	# Comment after selector.
	$self->{'comment_after_selector'} = 0;

	return;
}

# Flush $self->{'tmp_code'}.
sub _flush_tmp {
	my $self = shift;
	if (@{$self->{'tmp_code'}}) {
		my @comment;
		if ($self->{'comment_after_selector'}) {
			@comment = splice @{$self->{'tmp_code'}},
				-$self->{'comment_after_selector'};
		}
		pop @{$self->{'tmp_code'}};
		$self->{'flush_code'} .=
			(join $EMPTY_STR, @{$self->{'tmp_code'}}).'{'.
			(join $EMPTY_STR, @comment);
		$self->{'tmp_code'} = [];
	}
	return;
}

# At-rules.
sub _put_at_rules {
	my ($self, $at_rule, $file) = @_;
	$self->{'flush_code'} .= $at_rule.' "'.$file.'";';
	return;
}

# Comment.
sub _put_comment {
	my ($self, @comments) = @_;
	if (! $self->{'skip_comments'}) {
		push @comments, $self->{'comment_delimeters'}->[1];
		unshift @comments, $self->{'comment_delimeters'}->[0];
		my $comment = join $EMPTY_STR, @comments;
		if (@{$self->{'tmp_code'}}) {
			push @{$self->{'tmp_code'}}, $comment;
			$self->{'comment_after_selector'}++;
		} else {
			$self->{'flush_code'} .= $comment;
		}
	}
	return;
}

# Definition.
sub _put_definition {
	my ($self, $key, $value) = @_;
	$self->_check_opened_selector;
	$self->_flush_tmp;
	$self->{'flush_code'} .= $key.':'.$value.';';
	return;
}

# End of selector.
sub _put_end_of_selector {
	my $self = shift;
	$self->_check_opened_selector;
	$self->_flush_tmp;
	$self->{'flush_code'} .= '}';
	$self->{'open_selector'} = 0;
	return;
}

# Instruction.
sub _put_instruction {
	my ($self, $target, $code) = @_;
	$self->_put_comment($target, $code);
	return;
}

# Raw data.
sub _put_raw {
	my ($self, @raw_data) = @_;

	# To flush code.
	$self->{'flush_code'} .= join $EMPTY_STR, @raw_data;

	return;
}

# Selectors.
sub _put_selector {
	my ($self, $selector) = @_;
	push @{$self->{'tmp_code'}}, $selector, ',';
	$self->{'comment_after_selector'} = 0;
	$self->{'open_selector'} = 1;
	return;
}

# Reset flush code.
sub _reset_flush_code {
	my $self = shift;
	$self->{'flush_code'} = $EMPTY_STR;
	return;
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

CSS::Structure::Output::Raw - Raw printing 'CSS::Structure' structure to CSS code.

=head1 SYNOPSIS

 use CSS::Structure::Output::Raw;
 my $css = CSS::Structure::Output::Raw->new(%parameters);
 $css->put(@data);
 $css->flush;
 $css->reset;

=head1 METHODS

=over 8

=item C<new(%parameters)>

 Constructor.

=over 8

=item * C<auto_flush>

 Auto flush flag.
 Default is 0.

=item * C<comment_delimeters>

 Reference to array with begin and end comment delimeter.
 Default value is ['/*', '*/'].
 Possible values are:
 - ['/*', '*/']
 - ['<!--', '-->'],

=item * C<output_handler>

 Handler for print output strings.
 Must be a GLOB.
 Default is undef.

=item * C<skip_bad_types>

 Flag, that means bad 'CSS::Structure' types skipping.
 Default value is 0.

=item * C<skip_comments>

 Flag, that means comment skipping.
 Default value is 0.

=back

=item C<flush($reset_flag)>

 Flush CSS structure in object.
 If defined 'output_handler' flush to its.
 Or return code.
 If enabled $reset_flag, then resets internal variables via reset method.

=item C<put(@data)>

 Put CSS structure in format specified in L<CSS::Structure(3pm)>.

=item C<reset()>

 Resets internal variables.

=back

=head1 ERRORS

 Mine:
         None

 From CSS::Structure::Core:
         Auto-flush can't use without output handler.
         Bad comment delimeters.
         Bad data.
         Bad number of arguments.
                 ('CSS::Structure' structure array),
         Bad type of data.
         Cannot write to output handler.
         No opened selector.
         Output handler is bad file handler.
         Unknown parameter '%s'.

=head1 DEPENDENCIES

L<CSS::Structure::Output::Core(3pm)>,
L<Readonly(3pm)>.

=head1 SEE ALSO

L<CSS::Structure(3pm)>,
L<CSS::Structure::Utils(3pm)>,
L<CSS::Structure::Output::Core(3pm)>,
L<CSS::Structure::Output::Indent(3pm)>.

=head1 AUTHOR

Michal Špaček L<skim@cpan.org>

=head1 LICENSE AND COPYRIGHT

BSD license.

=head1 VERSION

0.01

=cut
