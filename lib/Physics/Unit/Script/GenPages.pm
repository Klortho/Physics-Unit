package Physics::Unit::Script::GenPages;

# This test program generates the UnitsByName.html and
# UnitsByType.html pages.

use strict;
use warnings;

use Physics::Unit ':ALL';

use parent 'Exporter';
our @EXPORT = qw/GenPages/;

#-----------------------------------------------------------
sub GenPages
{
    my @return;
    my $outFile;

    # Generate Units by Name

    $outFile = "UnitsByName.html";
    push @return, $outFile;
    open NAMES, ">$outFile" or die "Can't open $outFile for output";
    print NAMES header("Name");

    print NAMES tableHeader(1);

    for my $name (ListUnits()) {
        my $n = GetUnit($name);
        printrow(1, $name, $n->type(), $n->def(), $n->expanded());
    }

    print NAMES trailer();
    close NAMES;


    # Generate Units by Type

    $outFile = "UnitsByType.html";
    push @return, $outFile;
    open NAMES, ">$outFile" or die "Can't open $outFile for output";
    print NAMES header("Type");

    # Print out the "Table of Contents"

    my @t = ('unknown', 'prefix', ListTypes());
    my @links = map "      <a href='#$_'>$_</a>", @t;
    print NAMES join ",\n", @links;

    # Print out the table

    print NAMES "\n      <p>\n" .
                tableHeader(0);

    my $lastType = '-';
    for my $name (sort byType ListUnits())
    {
        my $n = GetUnit($name);
        my $t = $n->type || '';
        if ($t ne $lastType) {
            print NAMES typeRow($t);
            $lastType = $t;
        }

        printrow(0, $name, $t, $n->def, $n->expanded);
    }

    print NAMES trailer();
    close NAMES;

    return @return;
}

#-----------------------------------------------------------
sub header
{
    my $sortBy = shift;
    my $title = "Units by $sortBy";

    return <<END_HEADER;
<html>
  <head>
    <title>$title</title>
    <link rel="stylesheet" href="http://st.pimg.net/tucs/style.css" type="text/css" />
  </head>
  <body>
    <div class='pod'>
      <h1>$title</h1>
END_HEADER
}

#-----------------------------------------------------------
sub trailer
{
    return <<END_TRAILER;
      </table>
    </div>
  </body>
</html>
END_TRAILER
}

#-----------------------------------------------------------
sub tableHeader
{
    my $printType = shift;

    my $th = "      <table border='1' cellpadding='2'>\n" .
             "        <tr bgcolor='#003070'>\n" .
             "          <th>Unit</th>\n" .
             ($printType ? "          <th>Type</th>\n" : '') .
             "          <th>Value</th>\n" .
             "          <th>Expanded</th>\n" .
             "        </tr>\n";

    return $th;
}

#-----------------------------------------------------------
sub printrow
{
    my ($printType, $name, $t, $d, $ex) = @_;
    print NAMES "        <tr>\n" .
                "          <td>$name</td>\n" .
                ($printType ?
                    "          <td>" . typeStr($t) . "</td>\n" : '') .
                "          <td>$d</td>\n" .
                "          <td>$ex</td>\n" .
                "        </tr>\n";
}

#-----------------------------------------------------------
# This is used in a couple of places.  It returns a human-readable
# string for a type.  If $t is undef, this returns "unknown";
# otherwise, this returns $t.

sub typeStr
{
    my $t = shift;
    return !defined $t || $t eq '' ? 'unknown' : $t;
}

#-----------------------------------------------------------
# Used for sorting an array of unit names by type.
# Note: 'unknown' is first, 'prefix' next

sub byType
{
    my $ua = GetUnit($a);
    my $ub = GetUnit($b);

    return altType($ua->type) cmp altType($ub->type) ||
           $ua->factor <=> $ub->factor ||
           $a cmp $b;
}

#-----------------------------------------------------------
# This is used by the byType comparison routine.  This takes a
# unit's type and returns a value that ensures that undef (type is
# unknown) is sorted first, then 'prefix' and then the other types.

sub altType
{
    my $t = shift;

    return !defined $t ? 0 :
           $t eq 'prefix'  ? 1 :
           $t;
}

#-----------------------------------------------------------
sub typeRow
{
    my $t = shift;
    my $ts = typeStr($t);

    return "      <tr bgcolor='#B0D8FC'>\n" .
           "        <td colspan='4'>\n" .
           "          <a name='$ts'>" .
           ($ts eq 'prefix' ? 'prefix (dimensionless)' : $ts) .
           "</a>\n" .
           "        </td>\n" .
           "      </tr>\n";
}

