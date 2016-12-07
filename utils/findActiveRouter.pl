my %routers;

$routers{"4676e7a5-279c-4114-8674-209f7fd5ab1a"} = "NRTR01-GEIX-IAD1-AIR-Internal-PRD01";
$routers{"7629f5d7-b205-4af5-8e0e-a3c4d15e7677"} = "NRTR01-GEIX-IAD1-AIR-NAT-PRD01";
$routers{"c8b5d5b7-ab57-4f56-9838-0900dc304af6"} = "NRTR01-GEIX-IAD1-AIR-Public-PRD01";

foreach my $rtr (keys %routers)
{

        my $northIP; my $nortInt;
        my $southIP; my $southInt;
        open (F, "ip netns exec $rtr ip a | ");
        while(<F>)
        {
                chomp;
                my $line = trim($_);
                next if /inet6/;
                next if /169.254/;
                next if /127.0.0.1/;
                if (/inet/)
                {
                        $line =~ s/inet//g;
                        $line =~ s/scope global//g;
                        $line = trim($line);
                        my ($ip, $interface) = split(/\s+/, $line);
                        if ( $interface =~ m/qg/  )
                        {
                                #print "North Interface : $ip [$interface]\n";
                                $northIP = $ip; $northInt = $interface;
                        }
                        if ( $interface =~ m/qr/ )
                        {
                                #print "South Interface : $ip [$interface]\n";
                                $southIP = $ip ; $southInt = $inteface;
                        }
                }
        }
        close F;
        if ($northIP && $southIP)
        {
                my $rtrName = $routers{$rtr];
                print "Router $rtrName is active\n";
                print "North IP : $northIP\n";
                print "South IP : $southIP\n";
        }



}
exit;


sub trim
{
   my ($s) = @_;
   $s =~ s/^\s+//g;
   $s =~ s/\s+$//g;
   return($s);
}
