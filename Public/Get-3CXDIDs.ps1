function Get-3CXDIDs {
  param(
    [Parameter(Mandatory = $True)]
    [int]$ID
  )
  return ((Get-3CXRoute -ID $ID).Routes).DID
}
