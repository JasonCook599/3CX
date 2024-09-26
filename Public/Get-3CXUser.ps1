<#
    .SYNOPSIS
        Get 3CX User
    .DESCRIPTION
        Retrieve the 3CX User
    .EXAMPLE
        PS> Get-3CXUser
    .OUTPUTS
        powershell object containing the 3CX response
#>
function Get-3CXUser {
  [CmdletBinding()]
  param(
    $Filter = "not startsWith(Number,'HD')",
    $Order = "Number",
    $Select = "IsRegistered,CurrentProfileName,DisplayName,Id,EmailAddress,Number,Tags,Require2FA",
    $Expand = 'Groups($select=GroupId,Name,Rights;$filter=not startsWith(Name,''___FAVORITES___'');$expand=Rights($select=RoleName)),Phones($select=MacAddress,Name,Settings($select=IsSBC,ProvisionType))',
    [int]$Limit
  )
  $params = @{
    Endpoint    = '/xapi/v1/Users'
    Paginate    = $true
    PageFilter  = $Filter
    PageOrderBy = $Order
    PageSelect  = $Select
    PageExpand  = $Expand
    Limit       = $Limit
  }
  return Get-3CXResult @params
}
