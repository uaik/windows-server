# -------------------------------------------------------------------------------------------------------------------- #
# SRV name.
# -------------------------------------------------------------------------------------------------------------------- #

function Set-SrvName() {
  [String]${Name} = 'SRV-DHCP01'
  [PSCredential]${User} = Administrator

  $Params = @{
    NewName = "${Name}"
    LocalCredential = ${User}
    Restart = $false
  }

  Rename-Computer @Params
}

# -------------------------------------------------------------------------------------------------------------------- #
# SRV IP address.
#
# Checking 'InterfaceAlias':
#   Get-NetIPConfiguration
# -------------------------------------------------------------------------------------------------------------------- #

function Set-SrvIP() {
  [String]${Name}     = 'Ethernet'
  [String]${IP}       = '10.0.20.3'
  [Byte]${Mask}       = 16
  [String]${Gateway}  = '10.0.0.1'

  $Params = @{
    InterfaceAlias = "${Name}"
    IPAddress = "${IP}"
    PrefixLength = ${Mask}
    DefaultGateway = "${Gateway}"
  }

  New-NetIPAddress @Params
}

# -------------------------------------------------------------------------------------------------------------------- #
# SRV DNS address.
#
# Checking 'InterfaceAlias':
#   Get-NetIPConfiguration
# -------------------------------------------------------------------------------------------------------------------- #

function Set-SrvDNS() {
  [String[]]${Name} = 'Ethernet'
  [String[]]${DNS}  = ('10.0.21.1', '10.0.22.1')

  $Params = @{
    InterfaceAlias = ${Name}
    ServerAddresses = ${DNS}
  }

  Set-DnsClientServerAddress @Params
}

# -------------------------------------------------------------------------------------------------------------------- #
# DHCP role.
# -------------------------------------------------------------------------------------------------------------------- #

function Install-SrvDHCPRole() {
  [String]${Name} = 'DHCP'

  Install-WindowsFeature -Name "${Name}"
}

# -------------------------------------------------------------------------------------------------------------------- #
# DHCP database.
# -------------------------------------------------------------------------------------------------------------------- #

function Set-SrvDHCPDB() {
  [String]${SrvPath}  = 'D:\SRV\DHCP'

  $Params = @{
    -FileName "${SrvPath}\DHCP.mdb"
    -BackupPath "${SrvPath}\Backup"
    -BackupInterval 30
    -CleanupInterval 120
  }

  Set-DhcpServerDatabase @Params
}

# -------------------------------------------------------------------------------------------------------------------- #
# DHCP scope.
# -------------------------------------------------------------------------------------------------------------------- #

function Set-SrvDHCPScope() {
  [String]${Name}           = 'Main'
  [IPAddress]${RangeStart}  = 10.0.100.1
  [IPAddress]${RangeEnd}    = 10.0.200.254
  [IPAddress]${Mask}        = 255.255.0.0

  $Params = @{
    Name = "${Name}"
    StartRange = ${RangeStart}
    EndRange = ${RangeEnd}
    SubnetMask = ${Mask}
  }

  Add-DhcpServerv4Scope @Params
}

# -------------------------------------------------------------------------------------------------------------------- #
# DHCP options.
# -------------------------------------------------------------------------------------------------------------------- #

function Set-SrvDHCPOption() {
  [IPAddress]${ID}        = 10.0.0.0
  [IPAddress[]]${DNS}     = (10.0.21.1, 10.0.22.1)
  [IPAddress[]]${Gateway} = 10.0.0.1
  [String]${Domain}       = 'domain.local'

  $Params = @{
    ScopeId = ${ID}
    DnsServer = ${DNS}
    DnsDomain = "${Domain}"
    Router = ${Gateway}
  }

  Set-DhcpServerv4OptionValue @Params
}

# -------------------------------------------------------------------------------------------------------------------- #
# Adding SRV in Domain Controller (DC).
# -------------------------------------------------------------------------------------------------------------------- #

function Add-SrvDHCPInDC() {
  [String]${Name}   = 'srv-dhcp01.domain.local'
  [IPAddress]${IP}  = 10.0.20.3

  $Params = @{
    DnsName = "${Name}"
    IPAddress = ${IP}
  }

  Add-DhcpServerInDC @Params
}

# -------------------------------------------------------------------------------------------------------------------- #
# Adding DHCP security group.
# -------------------------------------------------------------------------------------------------------------------- #

function Add-SrvDHCPSecGp() {
  Add-DhcpServerSecurityGroup
}

# -------------------------------------------------------------------------------------------------------------------- #
# Configure a Hot-Standby DHCP Failover.
# -------------------------------------------------------------------------------------------------------------------- #

function Add-SrvDHCPFailover() {
  [String]${Name}                   = 'SFO-SIN-Failover'
  [String]${PartnerServer}          = '10.0.20.4'
  [String]${ServerRole}             = 'Active'
  [IPAddress[]]${ScopeID}           = 10.0.0.0
  [UInt32]${ReservePercent}         = 10
  [TimeSpan]${MaxClientLeadTime}    = 00:10:00
  [TimeSpan]${StateSwitchInterval}  = 00:10:00

  $Params = @{
    Name = "${Name}"
    PartnerServer = "${Partner}"
    ScopeId = ${ScopeID}
    ReservePercent = ${ReservePercent}
    MaxClientLeadTime = ${MaxClientLeadTime}
    StateSwitchInterval = ${StateSwitchInterval}
    ServerRole = "${ServerRole}"
  }

  Add-DhcpServerv4Failover @Params
}
