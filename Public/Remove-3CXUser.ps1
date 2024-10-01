function Remove-3CXUser {
  [CmdletBinding(SupportsShouldProcess = $true)]
  param(
    [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
    $ID
  )

  BEGIN {}
  PROCESS {
    If ($PSCmdlet.ShouldProcess($ID, "Delete User")) {
      return Get-3CXResult -Endpoint "/xapi/v1/Users($ID)" -Method DELETE
    }
  }
  END {}
}