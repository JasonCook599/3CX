<#
    .SYNOPSIS
        Get 3CX Event Log
    .DESCRIPTION
        Retrieve the 3CX Event Log
    .EXAMPLE
        PS> Get-3CXEventLog
    .OUTPUTS
        powershell object containing the 3CX response
#>
function Get-3CXEventLog {
  [CmdletBinding()]
  param(
    $Filter = "Type eq 'Info' or Type eq 'Warning' or Type eq 'Error'",
    $Order = "TimeGenerated desc",
    [int]$Limit = 100
  )
  $params = @{
    Endpoint    = '/xapi/v1/EventLogs'
    Paginate    = $true
    PageFilter  = $Filter
    PageOrderBy = $Order
    Limit       = $Limit
  }
  return Get-3CXResult @params
}