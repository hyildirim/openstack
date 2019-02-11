# First delete the instances

# Delete the subnets that are attached to each router
my %routers;
my %routerPortList;
deleteAllInstances();
getRouterList(\%routers);
clearRouterGateways(\%routers);
deleteRouterInterfaces(\%routers);
deleteSubnets();
deleteNetworks();
deletePorts();
deleteSubnetPools();
deleteAddressScope();
deleteRouters(\%routers);
#deleteProjects();
#deleteUsers();
#deleteDomains();
exit;
#-----------------------------------------------------------------------------
sub deleteDomains
{
   # Get the port list
   open (F, "openstack domain list |");
   while (<F>)
   {
      chomp; next if (/\+----/); next if (/\| ID/);
      my @a = split(/\|/);
      $domainID = trim($a[1]); $domainName = trim($a[2]); 
      if ( length($domainID) > 0 && $domainName !~ m/default/ )
      {
         print "Deleting domain >$domainID< >$domainName< \n";
         system("openstack domain set $domainID --disable");
         system("openstack domain delete $domainID");
      }
   }
   close F;
   return;
}
#-----------------------------------------------------------------------------
sub deleteUsers
{
   # Get the port list
   open (F, "openstack user list |");
   while (<F>)
   {
      chomp; next if (/\+----/); next if (/\| ID/);
      my @a = split(/\|/);
      $userID = trim($a[1]); $userName = trim($a[2]); 
      if ( length($userID) > 0 && $userName !~ m/admin|cinder|neutron|glance|nova|demo|swift|horizon|keystone|heat/ )
      {
         print "Deleting user >$userID< >$userName< \n";
         system("openstack user delete $userID");
      }
   }
   close F;
   return;
}

#-----------------------------------------------------------------------------
sub deleteProjects
{
   # Get the port list
   open (F, "openstack project list |");
   while (<F>)
   {
      chomp; next if (/\+----/); next if (/\| ID/);
      my @a = split(/\|/);
      $projectID = trim($a[1]); $projectName = trim($a[2]); 
      if ( length($projectID) > 0 && $projectName !~ m/demo|service|admin/ )
      {
         print "Deleting project >$projectID< >$projectName< \n";
         system("openstack project delete $projectID");
      }
   }
   close F;
   return;
}


#-----------------------------------------------------------------------------
sub deleteAddressScope
{
   # Get the port list
   open (F, "neutron address-scope-list |");
   while (<F>)
   {
      chomp; next if (/\+----/); next if (/\| id/);
      my @a = split(/\|/);
      $scopeID = trim($a[1]); $scopeName = trim($a[2]); 
      if ( length($scopeID) > 0 )
      {
         print "Deleting address scope  >$scopeID< >$scopeName< \n";
         system("neutron address-scope-delete $scopeID");
      }
   }
   close F;
   return;
}

#-----------------------------------------------------------------------------
sub deleteSubnetPools
{
   # Get the port list
   open (F, "neutron subnetpool-list |");
   while (<F>)
   {
      chomp; next if (/\+----/); next if (/\| id/);
      my @a = split(/\|/);
      $subnetPoolID = trim($a[1]); $subnetPoolName = trim($a[2]); 
      if ( length($subnetPoolID) > 0 )
      {
         print "Deleting subnetPool  >$subnetPoolID< >$subnetPoolName< \n";
         system("neutron subnetpool-delete $subnetPoolID");
      }
   }
   close F;
   return;
}
#-----------------------------------------------------------------------------
sub deletePorts
{
   # Get the port list
   open (F, "neutron port-list |");
   while (<F>)
   {
      chomp; next if (/\+----/); next if (/\| id/);
      my @a = split(/\|/);
      $portID = trim($a[1]); 
      if ( length($portID) > 0 )
      {
         print "Deleting port PortID = >$portID< \n";
         system("neutron port-delete $portID");
      }
   }
   close F;
   return;
}
#-----------------------------------------------------------------------------
sub deleteSubnets
{
   # Get the router list
   open (F, "neutron subnet-list |");
   while (<F>)
   {
      chomp; next if (/\+----/); next if (/\| id/);
      my @a = split(/\|/);
      $subnetID = trim($a[1]); $subnetName = trim($a[2]);
      if ( length($subnetID) > 0 )
      {
         print "SubnetID = >$subnetID< >$subnetName<\n";
         system("neutron subnet-delete $subnetID");
      }
   }
   close F;
   return;
}
#-----------------------------------------------------------------------------
sub deleteNetworks
{
   open (F, "neutron net-list |");
   while (<F>)
   {
      chomp; next if (/\+----/); next if (/\| id/);
      my @a = split(/\|/);
      $networkID = trim($a[1]); $networkName = trim($a[2]);
      if ( length($networkID) > 0 )
      {
         print "Deleting networkID = >$networkID< >$networkName<\n";
         system("neutron net-delete $networkID");
      }
   }
   close F;
   return;
}

#-----------------------------------------------------------------------------
sub deleteRouters
{
   my ($r) = @_;
   my ($r) = @_;
   # Get the router list
   print "-" x 79 . "\n";
   foreach my $rtr (keys %{$r})
   {
      $routerName = $$r{$rtr}{'name'};
      print "Deleting router [$routerName]\n";
      system("neutron router-delete $rtr");
      print "-" x 79 . "\n";
   }
   return;
}

#-----------------------------------------------------------------------------
sub trim 
{
   my ($s) = @_;
   $s =~ s/^\s+//g;
   $s =~ s/\s+$//g;
   return($s);
}
#-----------------------------------------------------------------------------
sub deleteAllInstances
{
   open (F, "openstack server list |");
   while (<F>)
   {
        chomp; next if (/\+----/); next if (/\| ID/); next if (/PINGER/);
      my @a = split(/\|/);
      $instanceID = trim($a[1]); $instanceName = trim($a[2]);
      print "Deleting Instance [$instanceID] [$instanceName]\n";
      system("openstack server delete $instanceID");

   }

   return;
}


#-----------------------------------------------------------------------------
sub clearRouterGateways
{
   my ($r) = @_;
   my ($r) = @_;
   # Get the router list
   print "-" x 79 . "\n";
   foreach my $rtr (keys %{$r})
   {
      $routerName = $$r{$rtr}{'name'};
      print "Clearing the gateway for router [$routerName]\n";
      system("neutron router-gateway-clear $routerName");
      print "-" x 79 . "\n";
   }
   return;
}



#-----------------------------------------------------------------------------
sub getRouterList
{
   my ($r) = @_;
   # Get the router list
   open (F, "neutron router-list |");
   while (<F>)
   {
      chomp; next if (/\+----/); next if (/\| id/);
      my @a = split(/\|/);
      $routerID = trim($a[1]); $routerName = trim($a[2]);
      print "Router = >$routerID< >$routerName<\n";
      $$r{$routerID}{'name'} = $routerName;
   }
   close F;
   return;
}
#-----------------------------------------------------------------------------
sub deleteRouterInterfaces
{
   my ($r) = @_;
   # Get the router list
   print "-" x 79 . "\n";
   foreach my $rtr (keys %{$r})
   {
      $routerName = $$r{$rtr}{'name'};
      print "INFO: Checking Subnets attached to router [$routerName]\n";
      open (F, "neutron router-port-list $rtr |");
      while (<F>)
      {
         chomp; next if (/\+----/); next if (/\| id/);
         my @a = split(/\|/);
         $subnetID = trim($a[4]);
         $subnetID = parseJSON($subnetID);
         if ( length($subnetID) > 0)
         {
            system("neutron router-interface-delete $rtr $subnetID");
            print "INFO: Removing subnet [$subnetID] from router [$routerName]\n";
         }
         
      }
      close F;
      print "-" x 79 . "\n";
   }
   return;
}
#-----------------------------------------------------------------------------
sub parseJSON
{
   my ($json) = @_;
   $json =~ s/^\{//g;
   $json =~ s/\}$//g;
   $json =~ s/\"//g;
   my $subnetID;
   #print "JSON = >$json<\n";
   my (@a) = split(/,/, $json);
   foreach (@a)
   {
      if (/subnet_id/)
      {
         my ($header, $value) = split(/:/);
         $subnetID = trim($value);
         print "SubnetID = >$subnetID<\n";
      }
   }
   return ($subnetID);
}
#-----------------------------------------------------------------------------
