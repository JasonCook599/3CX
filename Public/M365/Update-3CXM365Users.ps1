function Update-3CXM365Users {
  param(
    [Parameter(Mandatory = $true)]
    $SelectedUsers
  )
  $Microsoft365Integration = Get-3CXM365Integration
  return $Microsoft365Integration


  $Microsoft365Integration.AdUsers.SelectedUsers = $SelectedUsers
  [string]$Microsoft365Integration = $Microsoft365Integration | Select-Object  -Property * -ExcludeProperty "@odata*" | ConvertTo-Json -Compress

  Get-3CXResult -Endpoint "/xapi/v1/Microsoft365Integration" -Method PATCH -Body $Microsoft365Integration -Verbose -Debug
}