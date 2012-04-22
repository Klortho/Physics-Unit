package Physics::Unit;

use strict;
use Carp;
use base qw(Exporter);
use vars qw(
    $VERSION
    @EXPORT_OK
    %EXPORT_TAGS
    $debug
    $number_re
);

$VERSION = '0.04_02';
$VERSION = eval $VERSION;

@EXPORT_OK = qw(
    $number_re
    GetTypeUnit
    GetUnit
    InitBaseUnit
    InitPrefix
    InitTypes
    InitUnit
    ListTypes
    ListUnits
    NumBases
);

%EXPORT_TAGS = ('ALL' => \@EXPORT_OK);

# This is the regular expression used to parse out a number.  It
# is here so that other modules can use it for convenience.

$number_re = '([-+]?((\d+\.?\d*)|(\.\d+))(E[-+]?((\d+\.?\d*)|(\.\d+)))?)';

# The value of this hash is a string representing the token returned
# when this word is seen

my %reserved_word = (
    per     => 'divide',
    square  => 'square',
    sq      => 'square',
    cubic   => 'cubic',
    squared => 'squared',
    cubed   => 'cubed',
);

# Pre-defined units
my %unit_by_name;

# Values are references to units representing the prefix
my %prefix;

# Known quantity types.  The values of this hash are references to
# unit objects that exemplify these types
my %prototype;

# The number of base units
my $NumBases = 0;

# The names of the base units
my @BaseName;

InitBaseUnit (
    'Distance'    => ['meter', 'm', 'meters', 'metre', 'metres'],
    'Mass'        => ['gram', 'gm', 'grams'],
    'Time'        => ['second', 's', 'sec', 'secs', 'seconds'],
    'Temperature' => ['kelvin', 'k', 'kelvins',
                      'degree-kelvin', 'degrees-kelvin', 'degree-kelvins'],
    'Current'     => ['ampere', 'amp', 'amps', 'amperes'],
    'Substance'   => ['mole', 'mol', 'moles'],
    'Luminosity'  => ['candela', 'cd', 'candelas', 'candle', 'candles'],
    'Money'       => ['us-dollar', 'dollar', 'dollars', 'us-dollars', '$'],
    'Data'        => ['bit', 'bits'],
);

InitPrefix (
    'deka',    1e1,
    'deca',    1e1,
    'hecto',   1e2,
    'kilo',    1e3,
    'mega',    1e6,
    'giga',    1e9,
    'tera',    1e12,
    'peta',    1e15,
    'exa',     1e18,
    'zetta',   1e21,
    'yotta',   1e24,
    'deci',    1e-1,
    'centi',   1e-2,
    'milli',   1e-3,
    'micro',   1e-6,
    'nano',    1e-9,
    'pico',    1e-12,
    'femto',   1e-15,
    'atto',    1e-18,
    'zepto',   1e-21,
    'yocto',   1e-24,

    # binary prefixes
    'kibi',    2^10,
    'mebi',    2^20,
    'gibi',    2^30,
    'tebi',    2^40,
    'pebi',    2^50,
    'exbi',    2^60,

    # others
    'semi',    0.5,
    'demi',    0.5,
);


InitUnit (
    # Dimensionless
    ['pi',],    '3.1415926535897932385',
    ['e',],     '2.7182818284590452354',

    ['unity', 'one', 'ones',],           '1',
    ['two', 'twos',],                    '2',
    ['three', 'threes',],                '3',
    ['four', 'fours',],                  '4',
    ['five', 'fives',],                  '5',
    ['six', 'sixes',],                   '6',
    ['seven', 'sevens',],                '7',
    ['eight', 'eights',],                '8',
    ['nine', 'nines'],                   '9',
    ['ten', 'tens',],                   '10',
    ['eleven', 'elevens',],             '11',
    ['twelve', 'twelves',],             '12',
    ['thirteen', 'thirteens',],         '13',
    ['fourteen', 'fourteens',],         '14',
    ['fifteen', 'fifteens',],           '15',
    ['sixteen', 'sixteens',],           '16',
    ['seventeen', 'seventeens',],       '17',
    ['eighteen', 'eighteens',],         '18',
    ['nineteen', 'nineteens',],         '19',
    ['twenty', 'twenties',],            '20',
    ['thirty', 'thirties',],            '30',
    ['forty', 'forties',],              '40',
    ['fifty', 'fifties',],              '50',
    ['sixty', 'sixties',],              '60',
    ['seventy', 'seventies',],          '70',
    ['eighty', 'eighties',],            '80',
    ['ninety', 'nineties',],            '90',
    ['hundred', 'hundreds'],           '100',
    ['thousand', 'thousands'],        '1000',
    ['million', 'millions',],          '1e6',
    ['billion', 'billions',],          '1e9',
    ['trillion', 'trillions',],       '1e12',
    ['quadrillion', 'quadrillions',], '1e15',
    ['quintillion', 'quintillions',], '1e18',

    ['half', 'halves',],      '0.5',
    ['third', 'thirds',],     '1/3',
    ['fourth', 'fourths',],  '0.25',
    ['tenth',],               '0.1',
    ['hundredth',],          '0.01',
    ['thousandth',],        '0.001',
    ['millionth',],          '1e-6',
    ['billionth',],          '1e-9',
    ['trillionth',],        '1e-12',
    ['quadrillionth',],     '1e-15',
    ['quintillionth',],     '1e-18',

    ['percent', '%',],      '0.01',
    ['dozen', 'doz',],        '12',
    ['gross',],              '144',

    # Angular
    ['radian', 'radians',],                 '1',
    ['steradian', 'sr', 'steradians',],     '1',
    ['degree', 'deg', 'degrees',],          'pi radians / 180',
    ['arcminute', 'arcmin', 'arcminutes',], 'deg / 60',
    ['arcsecond', 'arcsec', 'arcseconds',], 'arcmin / 60',

    # Distance
    ['foot', 'ft', 'feet',],                    '.3048 m',          # exact
    ['inch', 'in', 'inches',],                  'ft/12',            # exact
    ['mil', 'mils',],                           'in/1000',          # exact
    ['yard', 'yards',],                         '3 ft',             # exact
    ['fathom', 'fathoms',],                     '2 yards',          # exact
    ['rod', 'rods',],                           '5.5 yards',        # exact
    ['pole', 'poles',],                         '1 rod',            # exact
    ['perch', 'perches',],                      '1 rod',            # exact
    ['furlong', 'furlongs',],                   '40 rods',          # exact
    ['mile', 'mi', 'miles',],                   '5280 ft',          # exact

    ['micron', 'microns', 'um',],               '1e-6 m',           # exact
    ['angstrom', 'a', 'angstroms',],            '1e-10 m',          # exact
    ['cm',],                                    'centimeter',       # exact
    ['km',],                                    'kilometer',        # exact

    ['pica',],                                  'in/6',    # exact, but see
                                                           # below
    ['point',],                                 'pica/12',          # exact

    ['nautical-mile', 'nm', 'nauticalmiles',
     'nauticalmile', 'nautical-miles',],        '1852 m',           # exact
    ['astronomical-unit', 'au',],               '1.49598e11 m',
    ['light-year', 'ly', 'light-years',
     'lightyear', 'lightyears'],                '9.46e15 m',
    ['parsec', 'parsecs',],                     '3.083e16 m',

    # equatorial radius of the reference geoid:
    ['re'],                          '6378388 m',    # exact
    # polar radius of the reference geoid:
    ['rp'],                          '6356912 m',    # exact

    # Acceleration
    ['g0', 'earth-gravity'],                    '9.80665 m/s^2',    # exact

    # Mass
    ['kg',],                                    'kilogram',         # exact
    ['metric-ton', 'metric-tons', 'tonne',
     'tonnes'],                                 '1000 kg',          # exact

    ['grain', 'grains'],                        '.0648 gm',

    ['pound-mass', 'lbm', 'lbms',
     'pounds-mass'],                            '0.45359237 kg',    # exact
    ['ounce', 'oz', 'ounces'],                  'lbm/16',           # exact
    ['stone', 'stones'],                        '14 lbm',           # exact
    ['hundredweight', 'hundredweights'],        '100 lbms',         # exact
    ['ton', 'tons', 'short-ton', 'short-tons'], '2000 lbms',        # exact
    ['long-ton', 'long-tons'],                  '2240 lbms',        # exact

    ['slug', 'slugs'],                          'lbm g0 s^2/ft',    # exact
    ['mg',],                                    'milligram',        # exact
    ['ug',],                                    'microgram',        # exact

    ['dram', 'drams'],                          'ounce / 16',       # exact

    ['troy-pound', 'troy-pounds'],              '0.373 kg',
    ['troy-ounce', 'troy-ounces',
     'ounce-troy', 'ounces-troy'],              '31.103 gm',
    ['pennyweight', 'pennyweights'],            '1.555 gm',
    ['scruple', 'scruples'],                    '1.296 gm',

    ['hg',],                                    'hectogram',        # exact
    ['dag',],                                   'decagram',         # exact
    ['dg',],                                    'decigram',         # exact
    ['cg',],                                    'centigram',        # exact
    ['carat', 'carats', 'karat', 'karats',],    '200 milligrams',   # exact
    ['j-point',],                               '2 carats',         # exact

    ['atomic-mass-unit', 'amu', 'u',
     'atomic-mass-units'],                      '1.6605402e-27 kg',


    # Time
    ['minute', 'min', 'mins', 'minutes'],               '60 s',
    ['hour', 'hr', 'hrs', 'hours'],                     '60 min',
    ['day', 'days'],    '24 hr',
    ['week', 'wk', 'weeks'],                            '7 days',
    ['fortnight', 'fortnights'],                        '2 week',
    ['year', 'yr', 'yrs', 'years'],                     '365.25 days',
    ['month', 'mon', 'mons', 'months'],                 'year / 12',    # an average month
    ['score', 'scores'],                                '20 yr',
    ['century', 'centuries'],                           '100 yr',
    ['millenium', 'millenia',],                         '1000 yr',

    ['ms', 'msec', 'msecs'], 'millisecond',
    ['us', 'usec', 'usecs'], 'microsecond',
    ['ns', 'nsec', 'nsecs'], 'nanosecond',
    ['ps', 'psec', 'psecs'], 'picosecond',

    # Data
    ['byte', 'bytes'], '8 bits',

    # Frequency
    ['hertz', 'hz'],                    '1/sec',
    ['becquerel', 'bq'],                '1 hz',
    ['revolution', 'revolutions',],     '1',
    ['rpm',],                           'revolutions per minute',
    ['cycle', 'cycles',],                '1',

    # Current
    ['abampere', 'abamp', 'abamps', 'abamperes'],         '10 amps',
    ['statampere', 'statamp', 'statamps', 'statamperes'], '3.336e-10 amps',

    ['ma',], 'milliamp',
    ['ua',], 'microamp',

    # Electric_potential
    ['volt', 'v', 'volts'],    'kg m^2 / amp s^3',
    ['mv',],                   'millivolt',
    ['uv',],                   'microvolt',
    ['abvolt', 'abvolts'],     '1e-8 volt',
    ['statvolt', 'statvolts'], '299.8 volt',

    # Resistance
    ['ohm', 'ohms'],         'kg m^2 / amp^2 s^3',
    ['abohm', 'abohms'],     'nano ohm',
    ['statohm', 'statohms'], '8.987e11 ohm',
    ['kilohm', 'kilohms',],  'kilo ohm',
    ['megohm', 'megohms'],   'mega ohm',

    # Conductance
    ['siemens',],    'amp^2 s^3 / kg m^2',
    ['mho', 'mhos'], '1/ohm',

    # Capacitance
    ['farad', 'f', 'farads'],    'amp^2 s^4 / kg m^2',
    ['abfarad', 'abfarads'],     'giga farad',
    ['statfarad', 'statfarads'], '1.113e-12 farad',

    ['uf',], 'microfarad',
    ['pf',], 'picofarads',

    # Inductance
    ['henry', 'henrys'],         'kg m^2 / amp^2 s^2',
    ['abhenry', 'abhenrys'],     'nano henry',
    ['stathenry', 'stathenrys'], '8.987e11 henry',

    ['uh',], 'microhenry',
    ['mh',], 'millihenry',

    # Magnetic_flux
    ['weber', 'wb', 'webers'],      'kg m^2 / amp s^2',
    ['maxwell', 'maxwells'],    '1e-8 weber',

    # Magnetic_field
    ['tesla', 'teslas'],      'kg / amp sec^2',
    ['gauss',],       '1e-4 tesla',

    # Temperature
    ['degree-rankine', 'degrees-rankine'],      '5/9 * kelvin',     # exact

    # Force
    ['pound', 'lb', 'lbs', 'pounds',
     'pound-force', 'lbf',
     'pounds-force', 'pound-weight'],           'slug foot / s^2',  # exact
    ['ounce-force', 'ozf'],                     'pound-force / 16', # exact
    ['newton', 'nt', 'newtons'],                'kg m / s^2',       # exact
    ['dyne', 'dynes'],                          'gm cm / s^2',      # exact
    ['gram-weight', 'gram-force'],              'gm g0',            # exact
    ['kgf',],                                   'kilo gram-force',  # exact

    # Area
    ['are', 'ares'],          '100 square meters',
    ['hectare', 'hectares',], '100 ares',
    ['acre', 'acres'],        '43560 square feet',
    ['barn', 'barns'],        '1e-28 square meters',

    # Volume
    ['liter', 'l', 'liters'],                   'm^3/1000',         # exact
    ['cl',],                                    'centiliter',       # exact
    ['dl',],                                    'deciliter',        # exact
    ['cc', 'ml',],                              'cubic centimeter', # exact

    ['gallon', 'gal', 'gallons'],               '3.785411784 liter',
    ['quart', 'qt', 'quarts'],                  'gallon/4',
    ['peck', 'pecks'],                          '8 quarts',
    ['bushel', 'bushels'],                      '4 pecks',
    ['fifth', 'fifths'],                        'gallon/5',
    ['pint', 'pt', 'pints'],                    'quart/2',
    ['cup', 'cups'],                            'pint/2',
    ['fluid-ounce', 'floz', 'fluidounce',
     'fluidounces', 'fluid-ounces'],            'cup/8',
    ['gill', 'gills'],                          '4 fluid-ounces',
    ['fluidram', 'fluidrams'],                  '3.5516 cc',
    ['minim', 'minims'],                        '0.059194 cc',
    ['tablespoon', 'tbsp', 'tablespoons'],      'fluid-ounce / 2',
    ['teaspoon', 'tsp', 'teaspoons'],           'tablespoon / 3',

    # Power
    ['watt', 'w', 'watts'], 'kg m^2 / s^3',
    ['horsepower', 'hp'],   '550 foot pound-force / s',

    # Energy
    ['joule', 'j', 'joules'],                   'kg m^2 / s^2',    # exact
    ['electron-volt', 'ev', 'electronvolt',
     'electronvolts', 'electron-volts'],        '1.60217733e-19 joule',

    ['mev',], 'mega electron-volt',
    ['gev',], 'giga electron-volt',
    ['tev',], 'tera electron-volt',

    ['calorie', 'cal', 'calories'],                '4.184 joules',  # exact
    ['kcal',],                                     'kilocalorie',   # exact
    ['british-thermal-unit', 'btu', 'btus',
     'britishthermalunit', 'britishthermalunits',
     'british-thermal-units'],                     '1055.056 joule',
    ['erg', 'ergs'],                               '1.0e-7 joule',  # exact
    ['kwh',],                                      'kilowatt hour', # exact

    # Torque
    ['foot-pound', 'ftlb', 'ft-lb',
     'footpound', 'footpounds', 'foot-pounds'], 'foot pound-force',

    # Charge
    ['coulomb', 'coul', 'coulombs'],             'ampere second',
    ['abcoulomb', 'abcoul', 'abcoulombs'],       '10 coulomb',
    ['statcoulomb', 'statcoul', 'statcoulombs'], '3.336e-10 coulomb',
    ['elementary-charge', 'eq'],     '1.6021892e-19 coulomb',

    # Pressure
    ['pascal', 'pa'],      'newton / m^2',
    ['bar', 'bars'],       '1e5 pascal',
    ['torr',],             '(101325 / 760) pascal',
    ['psi',],              'pounds per inch^2',
    ['atmosphere', 'atm'], '101325 pascal',             # exact

    # Speed
    ['mph',],          'mi/hr',
    ['kph',],          'km/hr',
    ['kps',],          'km/s',
    ['fps',],          'ft/s',
    ['knot', 'knots'], 'nm/hr',
    ['mps',],          'meter/s',
    ['speed-of-light', 'c'],         '2.99792458e8 m/sec',

    # Dose of radiation
    ['gray', 'gy'],    'joule / kg',
    ['sievert', 'sv'], 'joule / kg',
    ['rad',],          'gray / 100',
    ['rem',],          'sievert / 100',

    # Other
    ['gravitational-constant', 'g'], '6.6720e-11  m^3 / kg s^2',
    # Planck constant:
    ['h'],                            '6.626196e-34 J/s',
    # Avogadro constant:
    ['na'],                              '6.022169/mol',
);


InitTypes (
    'Dimensionless'      => 'unity',
    'Frequency'          => 'hertz',
    'Electric_potential' => 'volt',
    'Resistance'         => 'ohm',
    'Conductance'        => 'siemens',
    'Capacitance'        => 'farad',
    'Inductance'         => 'henry',
    'Magnetic_flux'      => 'weber',
    'Magnetic_field'     => 'tesla',
    'Force'              => 'newton',
    'Area'               => 'are',
    'Volume'             => 'liter',
    'Power'              => 'watt',
    'Energy'             => 'joule',
    'Torque'             => 'kg m^2/s^2',
    'Charge'             => 'coulomb',
    'Pressure'           => 'pascal',
    'Speed'              => 'mps',
    'Dose'               => 'gray',       #  of radiation
    'Acceleration'       => 'm/s^2',
);


GetUnit('joule')->type('Energy');
GetUnit('ev')->type('Energy');
GetUnit('mev')->type('Energy');
GetUnit('gev')->type('Energy');
GetUnit('tev')->type('Energy');
GetUnit('cal')->type('Energy');
GetUnit('kcal')->type('Energy');
GetUnit('btu')->type('Energy');
GetUnit('erg')->type('Energy');
GetUnit('kwh')->type('Energy');
GetUnit('ftlb')->type('Torque');


sub InitBaseUnit {
    while (@_) {
        my ($t, $names) = (shift, shift);
        croak 'Invalid arguments to InitBaseUnit'
            if ref $t || (ref $names ne "ARRAY");

        print "Initializing Base Unit $$names[0]\n"
            if $debug;

        my $unit = NewOne();
        $unit->AddNames(@$names);
        $unit->{def} = $unit->name();  # def same as name

        # The dimension vector for this Unit has zeros in every place
        # except the last
        $unit->{dim}->[$NumBases] = 1;
        $BaseName[$NumBases] = $unit->abbr();
        $NumBases++;

        $unit->NewType($t);
    }
}

sub InitPrefix {
    while (@_) {
        my ($name, $factor) = (shift, shift);
        croak 'Invalid arguments to InitPrefix'
            if !$name || !$factor || ref $name || ref $factor;

        print "Initializing Prefix $name\n"
            if $debug;

        my $u = NewOne();
        $u->AddNames($name);
        $u->{factor} = $factor;
        $u->{type} = 'prefix';
        $prefix{$name} = $u;

        $u->{def} = $factor;
    }
}

sub InitUnit {
    while (@_) {
        my ($names, $def) = (shift, shift);

        if (ref $names ne "ARRAY" || !$def) {
            print "InitUnit, second argument is '$def'\n";
            croak 'Invalid arguments to InitUnit';
        }

        print "Initializing Unit $$names[0]\n" if $debug;

        my $u = CreateUnit($def);

        $u->AddNames(@$names);
    }
}

sub InitTypes {
    while (@_) {
        my ($t, $u) = (shift, shift);
        croak 'Invalid arguments to InitTypes'
            if !$t || ref $t || !$u;

        my $unit = GetUnit($u);
        $unit->NewType($t);
    }
}

sub GetUnit {
    my $u = shift;

    croak 'GetUnit: expected an argument'
        unless $u;

    return $u if ref $u;

    if ($unit_by_name{$u}) {
        #print "GetUnit, $u yields ", $unit_by_name{$u}->name, "\n";
        return $unit_by_name{$u};
    }

    # Try it as an expression
    return CreateUnit($u);
}

sub ListUnits {
    return sort keys %unit_by_name;
}

sub ListTypes {
    return sort keys %prototype;
}

sub NumBases {
    return $NumBases;
}

sub GetTypeUnit {
    my $t = shift;
    return $prototype{$t};
}

sub new {
    my $proto = shift;
    my $class;

    my $self;
    if (ref $proto) {        # object method
        $self = $proto->copy;
    }
    else {                    # class method
        my $r = shift;
        $self = CreateUnit($r);
    }

    $self->AddNames(@_);

    return $self;
}

sub type {
    my $self = shift;

    # See if the user is setting the type
    my $t;
    if ($t = shift) {
        # XXX Maybe we should check that $t is a valid type name, and
        # XXX that it's type really does match.
        return $self->{type} = $t;
    }

    # If the type is known already, return it
    return $self->{type} if $self->{type};

    # See if it is a prefix
    my $name = $self->name();

    return $self->{type} = 'prefix'
        if defined $name && defined $prefix{$name};

    # Collect all matching types
    my @t;
    for (keys %prototype) {
        push @t, $_
            unless CompareDim($self, $prototype{$_});
    }

    # Return value depends on whether we got zero, one, or multiple types
    return undef
        unless @t;

    return $self->{type} = $t[0]
        if @t == 1;

    return \@t;
}

sub name {
    my $self = shift;
    my $n = $self->{names};
    return $$n[0];
}

sub abbr {
    my $self = shift;
    my $n = ${$self->{names}}[0];
    return undef
        unless defined $n;

    for ($self->names()) {
        $n = $_ if length $_ < length $n;
    }

    return $n;
}

sub names {
    my $self = shift;
    return @{$self->{names}};
}

sub def {
    my $self = shift;
    return $self->{def};
}

sub expanded {
    my $self = shift;

    my $s = $self->{factor};
    $s = '' if $s == 1;

    my $i = 0;
    for my $d (@{$self->{dim}}) {
        if ($d) {
            #print "Dimension index $i is $d\n";
            if ($s) { $s .= " "; }
            $s .= $BaseName[$i];
            $s .= "^$d" unless $d == 1;
        }
        $i++;
    }

    $s = 1 if $s eq '';

    return $s;
}

sub ToString {
    my $self = shift;
    return $self->name || $self->def || $self->expanded;
}

sub factor {
    my $self = shift;
    if (@_) {
        $self->CheckChange;
        $self->{factor} = shift;
    }
    return $self->{factor};
}

sub convert {
    my ($self, $other) = @_;
    my $u = GetUnit($other);
    carp "Can't convert ". $self->name() .' to '. $u->name()
        if CompareDim($self, $u);
    return $self->{factor} / $u->{factor};
}

sub times {
    my $self = shift;
    $self->CheckChange;
    my $u = GetUnit(shift);
    $self->{factor} *= $u->{factor};

    for (0 .. $NumBases) {
        my $u_val = defined $u->{dim}[$_] ? $u->{dim}[$_] : 0;
        if (defined $self->{dim}[$_]) {
            $self->{dim}[$_] += $u_val;
        }
        else {
            $self->{dim}[$_] = $u_val;
        }
    }

    $self->{type} = '';

    return $self;
}

sub recip {
    my $self = shift;
    $self->CheckChange;
    $self->{factor} = 1 / $self->{factor};

    for (0 .. $NumBases) {
        if (defined $self->{dim}[$_]) {
            $self->{dim}->[$_] = -$self->{dim}->[$_];
        }
        else {
            $self->{dim}[$_] = 0;
        }
    }

    return $self;
}

sub divide {
    my ($self, $other) = @_;
    my $u = GetUnit($other)->copy;
    $self->times($u->recip);
}

sub power {
    my $self = shift;
    $self->CheckChange;
    my $p = shift;
    die 'Exponentiation to integer values only, please'
        unless $p == int $p;
    $self->{factor} **= $p;

    for (0 .. $NumBases) {
        $self->{dim}[$_] = 0 unless defined $self->{dim}[$_];
        $self->{dim}[$_] *= $p;
    }

    $self->{type} = '';

    return $self;
}

sub add {
    my $self = shift;

    $self->CheckChange;

    my $other = shift;
    my $u = GetUnit($other);

    croak "Can't add ". $u->type .' to a '. $self->type
        if CompareDim($self, $u);

    $self->{factor} += $u->{factor};

    return $self;
}

sub neg {
    my $self = shift;
    $self->CheckChange;
    $self->{factor} = -$self->{factor};
    return $self;
}

sub subtract {
    my ($self, $other) = @_;
    my $u = GetUnit($other)->copy;
    $self->add( $u->neg );
}

sub copy {
    my $self = shift;

    my $n = {
        'factor' => $self->{factor},
        'dim'    => [@{$self->{dim}}],
        'type'   => $self->{type},
        'names'  => [],
        'def'    => $self->{def},
    };

    bless $n, 'Physics::Unit';

    return $n;
}

sub equal {
    my $obj1 = shift;

    # If it was called as a class method, throw away the first
    # argument (the class name)
    $obj1 = shift unless ref $obj1;

    $obj1 = GetUnit($obj1);

    my $obj2 = GetUnit(shift);

    return 0 if CompareDim($obj1, $obj2);
    return 0 unless $obj1->{factor} == $obj2->{factor};
    return 1;
}

sub NewOne {
    my $u = {
        'factor' => 1,
        'dim'    => [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        'type'   => undef,
        'names'  => [],
        'def'    => undef,
    };
    bless $u, 'Physics::Unit';
}

sub AddNames {
    my $self = shift;

    my $n;
    while ($n = shift) {
        croak "Can't use a reference as a name!"
            if ref $n;
        carp "Name $n is already defined"
            if LookName($n);

        push @{$self->{names}}, "\L$n";

        $unit_by_name{$n} = $self;
    }
}

sub NewType {
    my ($self, $t) = @_;
#    my $oldtype = $self->type;
#    croak "NewType: the type $t is already defined as $oldtype"
#        if $oldtype ne 'unknown';
    $self->{type} = $t;
    $prototype{$t} = $self;
}

sub CreateUnit {
    my $def = shift;

    # argument was a Unit object
    return $def->new() if ref $def;

    # argument was either a simple name or an expression - doesn't matter
    $def = lc $def;

    my $u = expr($def);

    $u->{def} = $def;

    return $u;
}

sub CompareDim {
    my ($u1, $u2) = @_;

    my $d1 = $u1->{dim};
    my $d2 = $u2->{dim};

    for (0 .. $NumBases) {
        $$d1[$_] = 0 unless defined $$d1[$_];
        $$d2[$_] = 0 unless defined $$d2[$_];

        my $c = ($$d1[$_] <=> $$d2[$_]);
        return $c if $c;
    }

    return 0;
}

sub LookName {
    my $name = shift;
    return 3 if defined $prototype{$name};
    return 2 if defined $unit_by_name{$name};
    return 1 if defined $reserved_word{$name};
    return 0;
}

sub DebugString {
    my $self = shift;
    my $s = $self->{factor};
    $s .= '['. join (', ', @{$self->{dim}}) .']';
    return $s;
}

sub CheckChange {
    my $self = shift;
    carp "You're not spozed to change named units!"
        if $self->{names}[0];
    $self->{names} = [];
    $self->{type} = $self->{def} = undef;
}

# global variables used for parsing.
my $def;      # string being parsed
my $tok;      # the token type
my $numval;   # the value when the token is a number
my $tokname;  # when it is a name
my $indent;   # used to indent debug messages

# parser
sub expr {
    if (@_) {
        $def = shift;
        get_token();
    }

    print ' ' x $indent, "inside expr\n" if $debug;

    $indent++;

    my $u = term();

    for (;;) {
        print ' ' x $indent, "inside expr loop\n" if $debug;

        if ($tok eq 'times') {
            get_token();

            $u->times(term());
        }
        elsif ($tok eq 'divide') {
            get_token();

            $u->divide(term());
        }
        else {
            print ' ' x $indent, "expr: returning ", $u->DebugString, "\n"
                if $debug;

            $indent--;

            return $u;
        }
    }
}

sub term {
    print ' ' x $indent, "inside term\n" if $debug;

    $indent++;

    my $u = Factor();

    for (;;) {
        print ' ' x $indent, "inside term loop\n" if $debug;

        if ($tok eq 'number' ||
            $tok eq 'name'   ||
            $tok eq 'prefix' ||
            $tok eq 'square' ||
            $tok eq 'cubic')
        {
            $u->times(Factor());
        }
        else {
            print ' ' x $indent, "term: returning ",
                $u->DebugString, "\n" if $debug;

            $indent--;

            return $u;
        }
    }
}

sub Factor {
    print ' ' x $indent, "inside factor\n" if $debug;

    $indent++;

    my $u = prim();

    for (;;) {
        print ' ' x $indent, "inside factor loop\n" if $debug;

        if ($tok eq 'exponent') {
            get_token();

            die 'Exponent must be an integer'
                unless $tok eq 'number';

            $u->power($numval);

            get_token();
        }
        else {
            print ' ' x $indent, "factor: returning ",

            $u->DebugString, "\n" if $debug;

            $indent--;

            return $u;
        }
    }
}

sub prim {
    print ' ' x $indent, "inside prim\n" if $debug;

    $indent++;

    my $u;

    if ($tok eq 'number') {
        print ' ' x $indent, "got number $numval\n" if $debug;

        # Create a new Unit object to represent this number
        $u = NewOne();

        $u->{factor} = $numval;

        get_token();
    }
    elsif ($tok eq 'prefix') {
        print ' ' x $indent, "got a prefix: ", "$tokname\n" if $debug;

        $u = GetUnit($tokname)->copy();

        get_token();

        $u->times(prim());
    }
    elsif ($tok eq 'name') {
        print ' ' x $indent, "got a name: ", "$tokname\n" if $debug;

        $u = GetUnit($tokname)->copy();

        get_token();
    }
    elsif ($tok eq 'lparen') {
        print ' ' x $indent, "got a left paren\n" if $debug;

        get_token();

        $u = expr();

        die 'Missing right parenthesis'
            unless $tok eq 'rparen';

        get_token();
    }
    elsif ($tok eq 'end') {
        print ' ' x $indent, "got end\n" if $debug;

        $u = NewOne();
    }
    elsif ($tok eq 'square') {
        get_token();

        $u = prim()->power(2);
    }
    elsif ($tok eq 'cubic') {
        get_token();

        $u = prim()->power(3);
    }
    else {
        die 'Primary expected';
    }

    print ' ' x $indent, "prim: returning ", $u->DebugString, "\n"
        if $debug;

    $indent--;

    # Before returning, see if the *next* token is 'squared' or 'cubed'
    for(;;) {
        if ($tok eq 'squared') {
            get_token();
            $u->power(2);
        }
        elsif ($tok eq 'cubed') {
            get_token();
            $u->power(3);
        }
        else {
            last;
        }
    }

    return $u;
}

sub get_token {
    print ' ' x $indent, "get_token, looking at '$def'\n" if $debug;

    # First remove whitespace at the begining
    $def =~ s/^\s+//;

    if ($def eq '') {
        $tok = 'end';
        return;
    }

    if ($def =~ s/^\(//) {
        $tok = 'lparen';
    }
    elsif ($def =~ s/^\)//) {
        $tok = 'rparen';
    }
    elsif ($def =~ s/^\*\*// || $def =~ s/^\^//) {
        $tok = 'exponent';
    }
    elsif ($def =~ s/^\*//) {
        $tok = 'times';
    }
    elsif ($def =~ s/^\///) {
        $tok = 'divide';
    }
    elsif ($def =~ s/^$number_re//io) {
        $numval = $1 + 0;  # convert to a number
        $tok = 'number';
    }
    elsif ($def =~ /^([^\ \n\r\t\f\(\)\/\^\*]+)/) {
        my $t = $1;

        my $l = LookName($t);

        if ($l == 1) {
            $tok = $reserved_word{$t};

            $tokname = $t;

            $def = substr $def, length($t);

            return;
        }
        elsif ($l == 2) {
            $tok = 'name';

            $tokname = $t;

            $def = substr $def, length($t);

            return;
        }

        # Couldn't find the name on the first try, look for prefix
        for my $p (keys %prefix) {
            if ($t =~ /^$p/i) {
                $tok = 'prefix';

                $tokname = $p;

                $def = substr $def, length($p);

                return;
            }
        }

        die "Unknown unit: $t\n";
    }
    else {
        die "Illegal token in $def";
    }
}

1;
__END__

=head1 NAME

Physics::Unit - Manipulate physics units and dimensions.

=head1 SYNOPSIS

  use Physics::Unit ':ALL';   # exports all util. function names

  # Define your own units
  $ss = new Physics::Unit('furlong / fortnight', 'ff');

  # Print the expanded representation of a unit
  print $ss->expanded, "\n";

  # Convert from one to another
  print 'One ', $ss->name, ' is ', $ss->convert('mph'), " miles per hour\n";

  # Get a Unit's conversion factor
  print 'Conversion factor of foot is ', GetUnit('foot')->factor, "\n";

=head1 DESCRIPTION

This module allows for the representation of physical quantities with
encapsulated units.

A Unit is defined by three things: a list of names, a conversion
factor, and a dimensionality vector. From the dimensionality, a type
can be derived (usually).

There are two main types of Unit objects: named and anonymous. Named
Unit objects are constant. Anonymous Unit objects, however, can
dynamically change.

Objects of class Unit define units of measurement that correspond to
physical quantities. This module allows you to manipulate these
units, generate new derived units from other units, and convert from
one unit to another. Each unit is defined by a conversion factor and
a dimensionality vector.

The conversion factor is a floating point number that specifies how
this unit relates to a reference unit of the same dimensionality.

The dimensionality vector holds a list of integers - each of which
records the power of a base unit in this unit.

For example, consider the unit of speed, "miles per hour". This has a
dimensionality of (Distance / Time), or of (Distance ^ 1 * Time ^ -1).
So this unit's dimensionality vector has a 1 in the place
corresponding to Distance, and a -1 in the place corresponding to
Time.

The reference unit for speed is "meters per second" (since meter is
the base unit corresponding to Distance, and second is the base unit
corresponding to Time). Therefore, the conversion factor for the unit
"miles per hour" is 0.44704, since 1 mph equals 0.44704 meters / sec.

Try this:

  print "One mph is ", GetUnit('mph')->factor, " meters / sec\n";

Units that have the same dimensionality can be compared, and
converted from one to the other.

Units are created through the use of unit expressions, which allow
you to combine previously defined named units in new and interesting
ways. In the synopsis above, "furlong / fortnight" is a unit
expression.

=head1 Types of Units

A Unit can have one or more names associated with it, or it can be
unnamed (anonymous).

Named units are constant. This ensures that expressions used to
derive other units will remain consistent. For example, consider the
expression "miles per hour", which uses the unit name "hour" to
create a new, derived unit. It is possible that the same expression
is used multiple times during the life of a program to create new
Unit objects. If the unit refered to by the name "hour" was allowed
to change, then a new, derived unit could possibly be different from
another unit derived with the same expression.

Anonymous units, however, can be changed.

Among named Units, there are three types: prefixes, base units, and
derived units.

A prefix Unit is a special case Unit object that:

  * is dimensionless
  * has only one name

A prefix name can be used in unit expressions in a special manner.
They can be used as prefixes to other unit names, with no intervening
whitespace. For example, "kilo" is a commonly used prefix. It can
appear as in the following unit expressions:

  kilogram
  kilomegameter

Prefixes are described more fully in the unit expressions section
below.

A base unit is one that defines a new base dimension. For example,
the unit meter is a base unit; it defines the dimension for Distance.

A derived unit is one that is built up from other named units from a
unit expression.

The terms base dimension and derived dimension (or derived type) are
sometimes used. Distance is an example of a base dimension. It is not
derived from any other set of dimensional quantities. Speed, however,
is a derived dimension (or derived type), corresponding to
Distance / Time.

=head1 Unit Names

Unit names are not allowed to contain whitespace, or any of the
characters ^, *, /, (, ). Case is not significant. Also, they may not
begin with any sequence of characters that could be interpreted as a
decimal number. Furthermore, these reserved words are not allowed as
unit names: per, square, sq, cubic, squared, or cubed. Other than
that, pretty much anything goes.

So, for example, each of these is a valid unit name:

  blather
  blather-hour
  ..splather!min_glub

But these are not:

  ^glub_glub   # contains invalid character ^
  .1foo        # '.1' looks a lot like a number
  123abc       # so does '123'

=head1 Unit Expressions

Unit Expressions allow you to create new unit objects from the set of
existing named units. Some examples of unit expressions are:

  megaparsec / femtosecond
  kg / feet^2 sec
  square millimeter
  kilogram meters per second squared

The explicit grammar for unit expressions is defined in the
implementation page.

The operators allowed in unit expressions are, in order from high to
low precedence:

prefix

Any prefix that is attached to a unit name is applied to that unit
immediately (highest precedence). Note that if there is whitespace
between the prefix and the unit name, this would be the space
operator, which is not the same (see below).

  square, sq, or cubic

square or cube the next thing on the line

  squared or cubed

square or cube the previous thing on the line

  ** or ^

exponentiation (must be to an integral power)

  space

any amount of whitespace between units is considered a multiplication

  *, /, or per

multiplication or division

Parentheses can be used to override the precedence of any of the
operators.

Prefixes are special case units, whose names can be attached to
beginning of other units, with no intervening whitespace. The Unit
module comes with a rather complete set of predefined SI prefixes;
see the Units by Type page.

The prefixes are allowed before units, or by themselves. Thus, these
are equivalent:

  megaparsec
  mega parsec
  kilo kilo parsec
  kilo**2 parsec
  square kilo parsec

Note in the last example that square applies only to kilo, and not to
parsec. That's because the square operator has higher precedence than
the space.

Note, however, that the space operator has higher precedence than
'*', '/', or 'per'. This means that units separated by only
whitespace in the denominator of an expression do not need to be
enclosed in parentheses. Thus

  meters / sec sec

is a unit of acceleration, but

  meters / sec*sec

is not. The latter is equivalent to just 'meters'.

=head1 Predefined Units

A rather complete set of units is pre-defined in the library, so it
will probably be rare that you'll need to define your own. See the
units by name page, or the units by type page for a complete list.

A pound is a unit of force. I was very much tempted to make it a unit
of mass, since that is much more often the way it is used, but I have
a feeling I would have had to take more guff for that than I'm
prepared to. The everyday pound, then, is named 'pound-mass', 'lbm',
'lbms', or 'pounds-mass'.

However, I couldn't bring myself to do the same thing to all the
other American units derived from a pound. Therefore, ounce, ton,
long-ton, and hundredweight are all units of mass.

A few physical constants were defined as Unit objects. This list is
very restricted, however. I limited them to physical constants which
really qualify as universal, according to (as much as I know of) the
laws of physics, and a few constants which have been defined by
international agreement. Thus, they are:

  * c   - the speed of light
  * G   - the universal gravitational constant
  * eq  - elementary charge
  * em  - electron mass
  * u   - atomic mass unit
  * g0  - standard gravity
  * atm - standard atmosphere
  * re  - equatorial radius of the reference geoid
  * rp  - polar radius of the reference geoid
  * h   - Planck constant
  * Na  - Avogadro constant



=head1 Name Conflicts and Resolutions

A few unit names and abbreviations had to be changed in order to avoid name
conflicts.  These are:

Elementary charge - abbreviated 'eq' instead of 'e'

Earth gravity - abbreviated 'g0' instead of 'g'

point - there are several definitions for this term:
  * typography -- point
      * I define it to be exactly 1/72 of an inch
      * my dictionary (Webster's II New College Dictionary) defines it as
        0.01384 inch, or 72.2543 points / inch.
      * The Convert::Units::Base module sez that it's commonly defined as
        0.01383 inch, or 72.3066 points / inch.
      * The Postscript documentation defines it as exactly 1/72 in.
      * The Convert::Units::Base module documentation also sez
        "Other type systems consider it 1/72.27 inch, or 0.01383 inches,
        or 0.0148 inches.  Outside of that context, a point may be 1/120
        or 1/144 inch."

  * a unit of academic classwork, usually equal to to one hour of class work
    per week during one semester
  * 11 deg., 15 min. between any two adjacent markings on a mariner's
    compass
  * a unit of scoring in any of a very many games
  * a unit equal to one dollar, used to quote the current prices of
    commodoties or stocks
  * a unit equal to one percentage point, used in reference to ownership
  * 2 milligrams (or 0.01 carat) used by jewelers -- j-point

minute -
  * duration -- minute
  * arc -- arcminute

second -
  * duration -- second
  * arc -- arcsecond

pound -
  * as a unit of force -- pound, pound-force, pounds-force, pound-weight, lbf
  * as a unit of mass -- pound-mass, pounds-mass, lbm
  * another unit of mass -- troy-pound

ounce -
  * as a unit of mass -- ounce, ounce-force, ozf
  * as a unit of volume -- fluid-ounce, floz, fluidounce
  * another unit of mass - troy-ounce

gram -
  * as a unit of mass - gram
  * as a unit of force -- gram-weight, gram-force


=head1 Export Options

By default, this module exports nothing. You can request all of the
utility functions to be exported as follows:

  use Physics::Unit ':ALL';

Or, you can just get specific ones. For example:

  use Physics::Unit qw( GetUnit ListUnits );

=head1 PACKAGE VARIABLES

=head2 $debug

Turning this on enables copious debugging information. This is a
package global, not a file-scoped lexical. So it can be turned on
like this

  BEGIN { $Physics::Unit::debug = 1; }

  use Physics::Unit;

=head2 $number_re

This is the regular expression used to parse out a number.  It is
here so that other modules can use it for convenience.

A (correct) regular expression for a floating point number,
optionally in exponent form. This is hard to come by.

This variable may also be imported for ease of use.


=head1 PUBLIC UTILITY FUNCTIONS

=head2 InitBaseUnit()

  Physics::Unit::InitBaseUnit( type, name-list,
                               type, name-list, ... );

InitBaseUnit is used to define any number of new, fundamental,
independent dimensional quantities.  Each such quantity is represented
by a Unit object, which must have at least one name.  From these base
units, all the units in the system are derived.

The library is initialized to know about nine base quantities. These
quantities, and the base units which represent them, are:

  1.  Distance - meter
  2.  Mass - gram
  3.  Time - second
  4.  Temperature - kelvin
  5.  Current - ampere
  6.  Substance - mole
  7.  Luminosity - candela
  8.  Money - us-dollar
  9.  Data - bit

More base quantities can be added at run-time, by calling this
function. The arguments to this function are in pairs. Each pair
consists of a type name followed by a reference to an array. The
array consists of a list of names which can be used to reference the
unit. For example:

  InitBaseUnit('Beauty' => ['sarah', 'sarahs', 'smw']);

This defines a new basic physical type, called Beauty. This also
causes the creation of a single new Unit object, which has three
names: sarah, sarahs, and smw. The type Beauty is refered to as a
base type. The Unit sarah is refered to as the base unit
corresponding to the type Beauty.

After defining a new base unit and type, you can then create other
units derived from this unit, and other types derived from this type.

=head2 InitPrefix()

  Physics::Unit::InitPrefix( name, number,
                             name, number, ... );

This function is used to define strings that can be used to prefix
any other unit name.  As with InitBaseUnit, the library is initialized
to know about a fair set of prefixes, and more can be added at
run-time.

If you desire to create a prefix at run-time, call InitPrefix with a
list of name-value pairs, for example:

  InitPrefix('gonzo' => 1e100, 'piccolo' => 1e-100);

From then on, you can use those prefixes to define new units, as in:

  $beauty_rate = new Physics::Unit('5 piccolosarah / hour');

=head2 InitUnit()

  Physics::Unit::InitUnit( name-list, unit-def,
                           name-list, unit-def, ... );

This function creates one or more new named Units.  This is called at
compile time to initialize the module with all the predefined units.
It may also be
called by users at runtime, to expand the unit system. For example:

  InitUnit( ['chris', 'cfm'] => '3 piccolosarahs' );

creates another unit of type Beauty equal to 3 * 10-100 sarahs.

Both this utility function and the new class method can be used to
create new, named Units. There are minor differences between these
two. The new method only allows you to create one unit at a time,
whereas the InitUnit function can be used to create a large set of
units with one call. The other difference is that units created with
InitUnit must have a name, whereas new can be used to create anonymous
Unit objects.

In this function and in others, wherever an argument is specified as
unit-def, you can use either a Unit object, a single unit name, or a
unit expression. So, for example, these are the same:

  InitUnit( ['mycron'], '3600 sec' );
  InitUnit( ['mycron'], 'hour' );
  $h = GetUnit('hour');  InitUnit( ['mycron'], $h );

creates a new unit named mycron which is the same as one hour.

=head2 InitTypes()

  Physics::Unit::InitTypes( type-name, unit-def,
                            type-name, unit-def, ... );

Use this function to define derived types. For example:

  InitTypes( 'Aging' => 'chris / year' );

might describe the loss of beauty with time.

This function associates a type name with a specific dimensionality.
The factor of the unit is not used. I.e., in the above example, Aging
is associated with ( Beauty / Time ). The factor of the unit
'chris / year' is not used.

The unit-def argument can be a single unit name, a unit expression,
or a Unit object.

=head2 GetUnit()

  $u = Physics::Unit::GetUnit( unit-def );

Returns a unit associated with the the argument passed in. The
argument can either be a name, a unit expression, or a Unit object.

If the argument is a Unit object, it is simply returned. If the
argument is a simple unit name, then this returns a reference to the
named unit.

If the argument cannot be found as a simple unit name, then this
method attempts to evaluate it as an expression. If it is successful,
it will create a new, anonymous Unit object and return a reference to
it.

For example:

  # This returns a reference to a pre-defined, named unit:
  $u = GetUnit('gram');

  # This creates a new, anonymous unit and returns a reference to it:
  $u = GetUnit('km / hour');

=head2 ListUnits()

  @l = Physics::Unit::ListUnits;

Returns a list of all unit names known, sorted alphabetically.

=head2 ListTypes()

  @l = Physics::Unit::ListTypes;

Returns a list of all the quantity types known to the library, sorted
alphabetically.

=head2 NumBases()

  $n = Physics::Unit::NumBases;

Returns the number of base dimension units.

=head2 GetTypeUnit()

  $u = Physics::Unit::GetTypeUnit( type-name );

Returns the Unit object corresponding to a given type.


=head1 PUBLIC METHODS

=head2 new()

  $u1 = new Physics::Unit( unit-def [, name, name, ... ] );
  $u2 = $u1->new( [name, name, ... ] );

This method creates a new Unit object. The names are optional. (Note:
the square brackets above are used to indicate that the name list is
optional, not that the argument is a reference to an anonymous array.
See the examples below.)

If names are given, then the new Unit will be given those names, and
that object will thereafter be constant.

If more than one name is given, the first is the primary name. The
primary name is retrieved whenever the name method is called.

If a unit has a name or names, those names must be different than
every other unit name known to the library. See the Unit by Names
page to see an alphabetical list of all the pre-defined unit names.

If no names are given, then an anonymous unit is created. Note that
another way of creating new anonymous units is with the GetUnit
utility function.

Examples:

  # Create a new, anonymous unit:
  $u = new Physics::Unit ('3 pi sarahs per s');

  # Create a new, named unit:
  $u = new Physics::Unit ('3 pi sarahs per s', 'bloom');

  # Or, create a new unit with a list of names:
  $u  = new Physics::Unit ('3 pi sarahs per s', 'b', 'blooms', 'blm');
  $n = $u->name;   # returns 'b'

  @@ - add a description, and an example of the use of this as an object
       method

=head2 type()

  $t = $u->type;
  $u->type( type-name );

Get or set this unit's type.

For example:

  GetUnit('rod')->type;    # returns 'Distance'

It will almost never be necessary to set a Unit object's type. The type
is normally determined uniquely from the dimensionality of the unit.
However, occasionally, more than one type can match a given unit's
dimensionality. For example, Torque and Energy have the same
dimensionality.

In that case, all of the predefined, named units are explicitly
designated to be one type or the other. For example, the unit newton
is defined to have the type Energy. See the list of units by type to
see which units are defined as Energy and which as Torque.

However, if you are going to create new Unit objects from unit
expressions that have that dimensionality, it will be necessary to
explicitly specify which type that unit object is.

When this method is called to set the unit's type, only one type
string argument is allowed, and it must be a predefined type name
(see InitTypes above).

Once a single type has been associated with a unit, then that will
remain that unit's type for the rest of the program, unless it is
re-set again.

This method returns one of:

  undef

no type was found to match the unit's dimensionality

  'prefix'

in the special case where the unit is a named prefix

  type_name

the prototype unit for type_name matches the unit's dimensionality
(see InitTypes above)

  ref to an array of type_name's

more than one type was found to match the unit's dimensionality

Some examples may perhaps make this clear:

  $u1 = new Physics::Unit('kg m^2/s^2');
  $t = $u1->type;       #  $t == ['Energy', 'Torque']

  $u1->type('Energy');  #  This establishes the type once and for all
  $t = $u1->type;       #  $t == 'Energy'

  # Now create another Unit object from the same definition
  $u2 = new Physics::Unit('kg m^2/s^2');

  # This is a brand-new object, so the explicit type is unknown, as before:
  $t = $u2->type;    # $t == ['Energy', 'Torque']

  # But if we use a predefined, named unit, we get a single type:
  $u3 = GetUnit('joule')->new;    # *not*  Physics::Unit->new('joule');
  $t = $u3->type;    # $t == 'Energy'

=head2 name()

  $n = $u->name;

Returns the primary name of the unit. If this unit has no names, then
this method returns undef.

=head2 abbr()

  $a = $u->abbr;

Returns the shortest name of the unit. If this unit has no names,
this method will return the undef.

=head2 names()

  @a = $u->names;

Returns a list of names that can be used to reference the unit.
Returns undef if the unit is unnamed.

Be aware: this might be an empty list - whereas the name() method
above will always return something meaningful.

=head2 def()

  $s = $u->def;

Returns the string that was used to define this unit.  Note that if
the unit has been manipulated with any of the arithmetic methods,
then the def method will return undef, since the definition string is
no longer a valid definition of the unit.

=head2 expanded()

  $s = $u->expanded;

Produces a string representation of the unit, in terms of the base
units (see InitBaseUnit above).

For example:

  print GetUnit('calorie')->expanded, "\n";

produces

  4184 m^2 gm s^-2

=head2 ToString()

  $s = $u->ToString;

There are several ways to have a Unit object print itself to a string.
This method is designed to give you what you usually want, and to be
guaranteed to always print out something meaningful.

If the object is named, this does the same as the name method above.
Otherwise, if the object's definition string is still valid, this
does the same as the def method above. Otherwise, this does the same
thing as the expanded method.

=head2 factor()

  $f = $u->factor;
  $u->factor(newvalue);    # $u must be unnamed

Get or set the unit's conversion factor. If this is used to set a
Unit's factor, then the Unit object must be anonymous.

=head2 convert()

  $f = $u->convert( unit-def );

Returns the number which converts this unit to another. The types of
the units must match. For example:

  $mile = GetUnit('mile');
  $foot = GetUnit('foot');
  $c = $mile->convert($foot);     # returns 5280


=head2 times()

  $u->times( unit-def );

$u is multiplied by either a Unit or a number.  $u must be anonymous.

=head2 recip()

  $u->recip;

$u is replaced with its reciprocal.  $u must be anonymous.

=head2 divide()

  $u->divide( unit-def );

$u is divided by either a Unit or a number, and the result replaces $u.
$u must be anonymous.

For example:

  $u = new Physics::Unit('36 m^2');
  $u->divide('3 meters');    # $u is now '12 m'
  $u->divide(3);             # $u is now '4 m'
  $u->divide( new Physics::Unit('.5 sec') );  # $u is now '8 m/s'

=head2 power()

  $u->power( integer );

Raises a unit to an integral power.  $u must be anonymous.

=head2 add()

  $u->add( unit );   # unit types must match

unit is added to $u.  $u and unit must be of the same type.
$u must be anonymous.

=head2 neg()

  $u->neg;

$u is replaced with its arithmetic negative.  $u must be anonymous.

=head2 subtract()

  $u->subtract( unit-def );   # unit types must match

unit is subtracted from $u.  $u and unit must be of the same type.
$u must be anonymous.

=head2 copy()

  $n = $u->copy;

This creates a copy of an existing unit. It doesn't copy the names,
however.  So you are free to modify the copy (while modification of
named units is verboten).

If the type of the existing unit is well-defined, then it, also, is
copied.

This is the same as the new method, when new is called as an object
method with no names.

=head2 equal()

  $u1->equal( unit-def );
  Physics::Unit->equal( unit-def, unit-def );

This returns 1 if the two unit objects have the same type and the
same conversion factor.


=head1 EXPRESSION GRAMMAR

  expr : term
       | term '/' expr
       | term '*' expr
       | term 'per' expr

  term : factor
       | term factor

A term is any number of factors separated (nominally) by whitespace.
Whitespace is an 'operator' that means the same thing as multiplication,
but has a higher priority than either '*', '/', or 'per'.

Examples of terms (the following lines each contain one term):

  3pi radians
  3e+4 globules

  factor : prim
         | prim '**' integer

Note that a primary can be an integer, of course, so factors can
look like this:

  meter ** 3 ^ 5    # note, '**' and '^' are synonymous

  prim : number
       | word
       | '(' expr ')'
       | 'square' primary
       | 'sq' primary
       | 'cubic' primary
       | primary 'squared'
       | primary 'cubed'



=head1 AUTHOR

Written by Chris Maloney <voldrani@gmail.com>

Formatted for distribution by Gene Boggs <cpan@ology.net>

=head1 COPYRIGHT AND LICENSE

Copyright 2002-2003 by Chris Maloney

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.
