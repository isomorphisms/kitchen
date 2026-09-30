# PowerShell static-IP positional binding

Evidence date: July 17–19, 2025.

This one is old enough to be useful: the original assistant-generated function
is recoverable.

    function static {
        param($if='Ethernet',$ip,$mask=24,$gw)
        Remove-NetIPAddress -InterfaceAlias $if -AddressFamily IPv4 -Confirm:$false
        New-NetIPAddress -InterfaceAlias $if -IPAddress $ip -PrefixLength $mask -DefaultGateway $gw
    }

## Observed failure

The one-argument call `static 172.17.1.0` bound `172.17.1.0` to the
interface parameter. PowerShell then reported no matching network-interface
object, and the later IP-address parameter was empty.

With explicit valid arguments, the same helper then reached a second missing
precondition: the network mutations returned `Access is denied` when run
without the required elevation.

## Regression

Semantic inputs must be validated before any mutation. Interface, IP address,
prefix length and gateway must not blur together merely because PowerShell can
bind them positionally. Required privilege is also a precondition, not an error
to discover after the script starts changing network state.
