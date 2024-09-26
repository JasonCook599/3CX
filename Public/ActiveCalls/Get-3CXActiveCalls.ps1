<#
    .SYNOPSIS
        Get 3CX Active Calls
    .DESCRIPTION
        Retrieve the Active Calls
    .EXAMPLE
        PS> Get-3CXActiveCalls
    .OUTPUTS
        powershell object containing the 3CX response
#>
function Get-3CXActiveCalls {
  [CmdletBinding()]
  param(
    $Order = 'LastChangeStatus desc',
    [int]$Limit
  )
  $params = @{
    Endpoint    = '/xapi/v1/ActiveCalls'
    Paginate    = $true
    PageOrderBy = $Order
    Limit       = $Limit
  }
  return Get-3CXResult @params
}
