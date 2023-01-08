[string]${PWD} = Read-Host -Prompt "DSRM Password" -AsSecureString

# -------------------------------------------------------------------------------------------------------------------- #
# SRV name.
# -------------------------------------------------------------------------------------------------------------------- #

function Set-SrvName() {
  [String]${Name}       = 'SRV-AD01'
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
  [String]${IP}       = '10.0.20.1'
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
# AD Domain Services
# -------------------------------------------------------------------------------------------------------------------- #

function Install-SrvADDSRole() {
  [String]${Name} = 'AD-Domain-Services'

  Install-WindowsFeature -Name "${Name}"
}

# -------------------------------------------------------------------------------------------------------------------- #
# AD Forest.
# -------------------------------------------------------------------------------------------------------------------- #

function Install-SrvADDSForest() {
  [String]${Name}       = 'domain.local'
  [String]${NetBIOS}    = 'DOMLOC'
  [String]${SrvPath}    = 'D:\SRV\ADDS'
  [DomainMode]${DMode}  = 7
  [ForestMode]${FMode}  = 7

  $Params = @{
    DomainName = "${Name}"
    DomainMode = ${DMode}
    ForestMode = ${FMode}
    DomainNetbiosName = "${NetBIOS}"
    DatabasePath = "${SrvPath}\NTDS"
    SysvolPath = "${SrvPath}\SYSVOL"
    LogPath = "${SrvPath}\Logs"
    SafeModeAdministratorPassword = "${PWD}"
    CreateDNSDelegation = $false
    InstallDNS = $false
    NoRebootOnCompletion = $true
    Force = $true
  }

  Install-ADDSForest @Params
}
