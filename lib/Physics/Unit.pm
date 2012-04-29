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

$number_re = '([-+]?((\d+\.?\d*)|(\.\d+))([eE][-+]?((\d+\.?\d*)|(\.\d+)))?)';

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
    ['nm',],                                    'nanometer',        # exact

    ['pica',],                                  'in/6',    # exact, but see below
    ['point',],                                 'pica/12',          # exact

    ['nautical-mile', 'nmi', 'nauticalmiles',
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
    'Momentum'           => 'kg m/s',
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

        print "Initializing Base Unit $$names[0]\n" if $debug;

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

        print "Initializing Prefix $name\n" if $debug;

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
    croak 'GetUnit: expected an argument' unless $u;
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
    return undef unless @t;
    return $self->{type} = $t[0] if @t == 1;
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
    return undef unless defined $n;

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
        croak "Can't use a reference as a name!" if ref $n;
        carp "Name $n is already defined" if LookName($n);
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
    carp "You're not allowed to change named units!" if $self->{names}[0];
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
            print ' ' x $indent, "term: returning ", $u->DebugString, "\n"
                if $debug;
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

