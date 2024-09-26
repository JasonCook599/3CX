<#
    .SYNOPSIS
        Get 3CX SIP Device
    .DESCRIPTION
        Retrieve the 3CX SIP Device(s)
    .EXAMPLE
        PS> Get-3CXSIPDevice
    .OUTPUTS
        powershell object containing the 3CX response
#>
function Get-3CXSIPDevice {
  [CmdletBinding()]
  param(
    $Expand = 'DN',
    $Filter = "DN/Type eq 'Extension'",
    $Order = "DN/Number",
    [int]$Limit
  )
  $params = @{
    Endpoint    = '/xapi/v1/SipDevices'
    Paginate    = $true
    PageExpand  = $Expand
    PageFilter  = $Filter
    PageOrderBy = $Order
    Limit       = $Limit
  }
  return Get-3CXResult @params -Verbose
}