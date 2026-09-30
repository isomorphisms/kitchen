# PowerShell DHCP mutation without elevation preflight

Evidence date: July 18, 2025.

The original generated helper is recoverable in substance:

    function dhcp {
        param($if='Ethernet')
        Set-NetIPInterface ... -Dhcp Enabled
        Remove-NetIPAddress ... -AddressFamily IPv4 ...
        Set-DnsClientServerAddress ... -ResetServerAddresses
        ipconfig /renew $if
    }

## Observed failure

The user ran the helper and received `Access is denied`, Windows System Error 5,
and a CIM access failure before the requested network reconfiguration could
complete.

## Regression

A script that requires administrator rights should establish that fact before
the first mutation. A fixture should verify that a non-elevated invocation
refuses cleanly rather than partially executing several privileged operations.
