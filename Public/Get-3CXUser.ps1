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
  [CmdletBinding(DefaultParameterSetName = "Default")]
  param(
    [Parameter(ParameterSetName = "Default")]
    $Filter = "not startsWith(Number,'HD')",

    [Parameter(ParameterSetName = "Default")]
    $Order = "Number",

    [Parameter(ParameterSetName = "Default")]
    [Parameter(ParameterSetName = "Single")]
    $Select = "IsRegistered,CurrentProfileName,DisplayName,Id,EmailAddress,Number,Tags,Require2FA",

    [Parameter(ParameterSetName = "Default")]
    [Parameter(ParameterSetName = "Single")]
    $Expand = 'Groups($select=GroupId,Name,Rights;$filter=not startsWith(Name,''___FAVORITES___'');$expand=Rights($select=RoleName)),Phones($select=MacAddress,Name,Settings($select=IsSBC,ProvisionType))',

    [Parameter(ParameterSetName = "Default")]
    [int]$Limit,

    [Parameter(ParameterSetName = "Single", Mandatory = $True)]
    [int]$ID
  )

  switch ($PSCmdlet.ParameterSetName) {
    "Default" {
      $params = @{
        Endpoint    = '/xapi/v1/Users'
        Paginate    = $true
        PageFilter  = $Filter
        PageOrderBy = $Order
        PageSelect  = $Select
        PageExpand  = $Expand
        Limit       = $Limit
      }
    }
    "Single" {
      $params = @{
        Endpoint   = "/xapi/v1/Users"
        ID         = $ID
        PageSelect = $Select
        PageExpand = $Expand
      }
    }
  }
  return Get-3CXResult @params
}
