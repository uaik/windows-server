# -------------------------------------------------------------------------------------------------------------------- #
# SRV name.
# -------------------------------------------------------------------------------------------------------------------- #

function Set-SrvName() {
  [String]${Name}       = 'SRV-DNS01'
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
  [String]${IP}       = '10.0.21.1'
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
# Install DNS role.
# -------------------------------------------------------------------------------------------------------------------- #

function Set-SrvDNS() {
  ${Name} = 'DNS'
  Install-WindowsFeature -Name "${Name}"
}

