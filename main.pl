use strict;
use warnings;
use LWP::Simple;
use XML::Simple;
use Data::Dumper;
use Getopt::Std;

$| = 1;


sub checkusage {
	my $opts = shift;
	my $r = $opts->{"r"};
	my $c = $opts->{"c"};

	# r is optional. don't really need to refer to it here at all.
	# c is mandatory.

	unless ( defined($c) ) {
		return 0;
	}

	return 1;
}

sub usage {
	print <<USAGE;

Access current weather data for any location on Earth including over 200,000 cities
API - https://openweathermap.org/
	
usage: perl main.pl <options>
	-c <city name>	specify a city.
	-r Optional - not used.

example usage:
	# Request the current weather data for the city of London.
	perl main.pl -c London -r xxx

	
USAGE
}


sub main {


	my %opts;

	# Get command line options
	getopts( 'c:r', \%opts );

	if ( !checkusage( \%opts ) ) {
		usage();
		exit();
	}

	my $input_city = $opts{"c"};

	print " Requesting the current weather data for the city of  $input_city ... \n";

	# API - Key: 74a07f6fbe1ee33a9b6e8a4695efb634
	#my $xmlApiCall = "http://api.openweathermap.org/data/2.5/weather?q=London&mode=xml&appid=74a07f6fbe1ee33a9b6e8a4695efb634";
	my $xmlApiCall = "http://api.openweathermap.org/data/2.5/weather?q=$input_city&mode=xml&appid=74a07f6fbe1ee33a9b6e8a4695efb634";
	#my $xmlApiCall = "http://samples.openweathermap.org/data/2.5/weather?q=London&mode=xml&appid=b1b15e88fa797225412429c1c50c122a1";
	my $content = get($xmlApiCall);


	unless ( defined($content) ) {
		die "Unreachable url-service-API\n";
	}

	print "\n=======================================\n";
	print $content;
	print "\n=======================================\n";

	my $parser = new XML::Simple;
	my $dom = $parser->XMLin( $content); #, ForceArray => 1 );
	print Dumper $dom;


	print "\n=======================================\n\n";

	print   "city, country: " . $dom->{"city"}->{"name"} . ", " . $dom->{"city"}->{"country"}  . "\n"; 
	print   "city-coord: (lat: " . $dom->{"city"}->{"coord"}->{"lat"} . ", lon: " . $dom->{"city"}->{"coord"}->{"lon"}  . ")\n"; 
	print   "sun rise: " . $dom->{"city"}->{'sun'}->{"rise"}. "\n"; 
	print   "sun set: " . $dom->{"city"}->{'sun'}->{"set"}. "\n"; 

	print   "temperature: " . $dom->{"temperature"}->{"value"} . " " . $dom->{"temperature"}->{"unit"} . ", (min: " . $dom->{"temperature"}->{"min"}. ", max: " . $dom->{"temperature"}->{"max"} . ")\n";

	print   "pressure: " . $dom->{"pressure"}->{"value"} . " " . $dom->{"pressure"}->{"unit"} . "\n";

	print   "humidity: " . $dom->{"humidity"}->{"value"} . " " . $dom->{"humidity"}->{"unit"} . "\n";

	print   "wind direction: " . $dom->{"wind"}->{"direction"}->{"value"} . " " . $dom->{"wind"}->{"direction"}->{"code"} . " " . $dom->{"wind"}->{"direction"}->{"name"} . "\n";
	print   "wind speed: " . $dom->{"wind"}->{"speed"}->{"value"} . " (" . $dom->{"wind"}->{"speed"}->{"name"} . ")\n"; 

	print   "precipitation: " . $dom->{"precipitation"}->{"mode"} . "\n";

	print   "weather: " . $dom->{"weather"}->{"value"} . "\n";

	print   "lastupdate: " . $dom->{"lastupdate"}->{"value"} . "\n";

	print "\n=======================================\n";

}



main();
