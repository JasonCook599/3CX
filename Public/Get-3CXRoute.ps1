function Get-3CXRoute {
  [CmdletBinding(DefaultParameterSetName = "Default")]
  param(
    [Parameter(Mandatory = $True)]
    [int]$ID
  )

  return Get-3CXResult -Endpoint "/xapi/v1/Defs/Pbx.GetRoutes" -Body "{`"ids`":[`"$ID`"`]`}" -Method POST
}
