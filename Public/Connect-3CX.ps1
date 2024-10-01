
function Connect-3CX {
  [CmdletBinding()]
  param(
    [Parameter(ParameterSetName = "Connect", mandatory = $true, HelpMessage = "3CX Credential")]
    [pscredential]$Credential,
    [Parameter(ParameterSetName = "Connect", mandatory = $true, HelpMessage = "3CX Server")]
    [string]$APIHost,
    [Parameter(ParameterSetName = "Connect", mandatory = $false, HelpMessage = "3CX Server Port")]
    [int]$APIPort = 443,
    [Parameter(ParameterSetName = "Refresh")]
    [switch]$Refresh
  )

  if ($Refresh) { Connect-3CX -Credential $3CXSession.Credential -APIHost $3CXSession.APIHost }
  else {
    $params = @{
      Uri             = "https://{0}:{1}/webclient/api/Login/GetAccessToken" -f $APIHost, $APIPort
      Method          = 'POST'
      Body            = @{
        Username     = $Credential.UserName
        SecurityCode = ""
        Password     = $Credential.GetNetworkCredential().Password
      } | ConvertTo-Json
      ContentType     = 'application/json'
      UseBasicParsing = $true
    }
    $result = Invoke-WebRequest @params

    if ($result.StatusCode -ne 200) {
      throw "Failed to get bearer token - status code: $($result.StatusCode)"
    }

    $obj = $result.Content | ConvertFrom-Json
    if ($obj.Status -notlike "AuthSuccess") {
      throw "Failed to get Bearer - Status is not AuthSuccess"
    }
    $script:3CXSession = @{
      AccessToken = $obj.Token.access_token
      ExpiresAt   = (Get-Date).AddMinutes($obj.Token.expires_in)
      APIHost     = $APIHost
      APIPort     = $APIPort
      Credential  = $Credential
    }
  }
}
