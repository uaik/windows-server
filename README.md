# Windows Server Installation Scripts

## Install PowerShell

```powershell
${V} = '7.3.1'; ${N} = "PowerShell-${V}-win-x64"; ${P} = "${env:SystemDrive}\Apps\PowerShell"; Invoke-WebRequest "https://github.com/PowerShell/PowerShell/releases/download/v${V}/PowerShell-${V}-win-x64.zip" -OutFile "${P}\${N}.zip"; Expand-Archive -Path "${P}\${N}.zip" -DestinationPath "${P}"; if ( Test-Path -Path "${P}\${N}" ) { Remove-Item -Path "${P}\${N}" -Recurse -Force }; Remove-Item -Path "${P}\${N}.zip";
```

## Install Scripts

```powershell
${N} = 'Server'; ${U} = 'uaik/windows-server'; ${P} = "${env:SystemDrive}\Apps"; Invoke-WebRequest "https://github.com/${U}/archive/refs/heads/main.zip" -OutFile "${P}\${N}.zip"; Expand-Archive -Path "${P}\${N}.zip" -DestinationPath "${P}"; if ( Test-Path -Path "${P}\${N}" ) { Remove-Item -Path "${P}\${N}" -Recurse -Force }; Rename-Item -Path "${P}\windows-server-main" -NewName "${P}\${N}"; Remove-Item -Path "${P}\${N}.zip";
```

## Network Topology

- **Network Gateways**
  - `10.0.0.1`
  - `10.0.9.254`
- **Network Switches**
  - `10.0.10.1`
  - `10.0.19.254`
- **Physical Servers**
  - `10.0.20.1`
  - `10.0.29.254`
- **Virtual Servers**
  - `10.0.30.1`
  - `10.0.39.254`
- **Access Points**
  - `10.0.40.1`
  - `10.0.49.254`
- **Shared**
  - `10.0.100.1`
  - `10.0.200.254`
