function Add-3CXDepartmentMember {
  [CmdletBinding(DefaultParameterSetName = "Default")]
  param(
    [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
    $Id,
    $Number
  )
  $Members = Get-3CXDepartmentMembers -ID $Id -Select Number, ID

  if ($Members.Number -contains $Number) {
    Write-Verbose "$Number is already a member of group ID $ID."
    return [PSCustomObject]@{
      Id                = $Id
      StatusCode        = 100
      StatusDescription = "Continue"
      Content           = $null
    }
  }
  else {
    if ($Members.count -gt 0) { $Body = @{Members = ($Members + [PSCustomObject]@{Number = [string]$Number }) } | ConvertTo-Json }
    else { $Body = '{"Members":[{"Number":"' + $Number + '"}]}' }
    return Get-3CXResult -Endpoint "/xapi/v1/Groups($Id)" -Body $Body -Method PATCH
  }
}
