function Update-3CXM365Users {
  param(
    [Parameter(Mandatory = $true)]
    $SelectedUsers
  )
  $Microsoft365Integration = Get-3CXM365Integration
  $Microsoft365Integration.AdUsers.SelectedUsers = $SelectedUsers
  Get-3CXResult -Endpoint "/xapi/v1/Microsoft365Integration" -Method PATCH -Body $Microsoft365Integration
}