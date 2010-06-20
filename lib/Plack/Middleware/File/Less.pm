package Plack::Middleware::File::Less;

# ABSTRACT: LESS CSS support

use strict;
use warnings;

use parent qw(Plack::Middleware);
use Plack::Util;
use CSS::LESSp;

sub call {
    my ($self, $env) = @_;

    my $orig_path_info = $env->{PATH_INFO};
    if ($env->{PATH_INFO} =~ s/\.css$/.less/i) {
        my $res = $self->app->($env);

        return $res unless ref $res eq 'ARRAY';

        if ($res->[0] == 200) {
            my $less;
            Plack::Util::foreach($res->[2], sub { $less .= $_[0] });
            my @css = CSS::LESSp->parse($less);
            my $css = join("", @css);

            my $h = Plack::Util::headers($res->[1]);
            $h->set('Content-Type'   => 'text/css');
            $h->set('Content-Length' => length $css);

            $res->[2] = [$css];
        }
        elsif ($res->[0] == 404) {
            $env->{PATH_INFO} = $orig_path_info;
            $res = $self->app->($env);
        }

        return $res;
    }
    return $self->app->($env);
}

1;

=head1 SYNOPSIS

  use Plack::App::File;
  use Plack::Builder;

  builder {
      mount "/stylesheets" => builder {
          enable "File::Less";
          Plack::App::File->new(root => "./stylesheets");
      };
  };

  # Or with Middleware::Static
  enable "File::Less";
  enable "Static", path => qr/\.css$/, root => "./static";

=head1 DESCRIPTION

Plack::Middleware::File::Less is middleware that compiles
L<Less|http://lesscss.org> templates into CSS stylesheet..

When a request comes in for I<.css> file, this middleware changes the
internal path to I<.less> in the same directory. If the LESS template
is found, a new CSS stylesheet is built on memory and served to the
browsers.  Otherwise, it falls back to the original I<.css> file in
the directory.

=head1 SEE ALSO

L<Plack::App::File> L<CSS::LESSp> L<http://lesscss.org/>

=cut
