function Get-3CXResult {
  [CmdletBinding(DefaultParameterSetName = "Simple")]
  param(

    [Parameter(Mandatory = $True, ParameterSetName = "Simple")]
    [Parameter(Mandatory = $True, ParameterSetName = "Paginate")]
    [string]$Endpoint,

    [Parameter(Mandatory = $False, ParameterSetName = "Simple")]
    [AllowNull()]
    $ID = $null,

    [Parameter(Mandatory = $False, ParameterSetName = "Simple")]
    [object]$Body = @{},

    [Parameter(Mandatory = $False, ParameterSetName = "Simple")]
    [ValidateSet('GET', 'POST', 'PATCH', 'DELETE')]
    [string]$Method = 'GET',

    [Parameter(Mandatory = $False, ParameterSetName = "Paginate")]
    [switch]$Paginate,

    [Parameter(Mandatory = $False, ParameterSetName = "Paginate")]
    [int]$Limit,

    [Parameter(Mandatory = $False, ParameterSetName = "Paginate")]
    [int]$PageSize = 50,

    [Parameter(Mandatory = $False, ParameterSetName = "Paginate")]
    [string]$PageFilter = '',

    [Parameter(Mandatory = $False, ParameterSetName = "Paginate")]
    [string]$PageOrderBy = '',

    [Parameter(Mandatory = $False, ParameterSetName = "Paginate")]
    [Parameter(Mandatory = $False, ParameterSetName = "Simple")]
    [string[]]$PageSelect = @(),

    [Parameter(Mandatory = $False, ParameterSetName = "Paginate")]
    [Parameter(Mandatory = $False, ParameterSetName = "Simple")]
    [string]$PageExpand = ''
  )

  $PageSelect = $PageSelect | Where-Object { $null -ne $_ }


  if ($null -eq $script:3CXSession) {
    throw "3CX session not established - Please run Connect-3CX"
  }
  elseif ((Get-Date) -ge $script:3CXSession.ExpiresAt) {
    throw "3CX session has expired. - Please run Connect-3CX"
  }

  switch ($PSCmdlet.ParameterSetName) {

    "Simple" {
      if ($null -ne $ID -or $ID -ge 0) {
        if ($ID -match '^\d+$') {
          Write-Debug "ID is a number"
          $Endpoint = "{0}({1})" -f $Endpoint, $ID
        }
        else {
          $Endpoint = "{0}('{1}')" -f $Endpoint, $ID
        }
      }

      if (($PageSelect | Measure-Object).Count -gt 0) {
        $Body.'$select' = $PageSelect -join ','
      }

      $params = @{
        Uri             = ("https://{0}:{1}{2}" -f $script:3CXSession.APIHost, $script:3CXSession.APIPort, $Endpoint)
        Method          = $Method
        Headers         = @{
          Authorization = "Bearer $($script:3CXSession.AccessToken)"
        }
        Body            = $Body
        UseBasicParsing = $true
      }
      Write-Debug "Parameter $($params | ConvertTo-Json)"

      try { $result = Invoke-WebRequest @params }
      catch { throw $_ }
      Write-Debug "Raw Content Result $($result.Content)"

      $obj = $result.Content | ConvertFrom-Json

      $arrayFields = @('value', '@odata.context')
      if ($null -eq (Compare-Object -ReferenceObject $arrayFields -DifferenceObject $obj.PSObject.Properties.Name) ) {
        return $obj.value
      }
      return $obj | Select-Object -ExcludeProperty '@odata.context'
    }

    "Paginate" {

      $targetCount = -1
      $values = New-Object Collections.Generic.List[object]

      while ($targetCount -lt 0 -or $values.Count -lt $targetCount) {
        Write-Verbose "Retrieving SIP Devices from Top $PageSize and Skip $($values.Count)"
        $newBody = @{
          '$top'   = if ($Limit -gt 0) { (@(($Limit - $values.count), $PageSize) | Measure-Object -Minimum).Minimum }      else { $PageSize }
          '$skip'  = $values.Count
          '$count' = 'true'
        }

        if (-not [string]::IsNullOrEmpty($PageFilter)) {
          $newBody.'$filter' = $PageFilter
        }

        if (-not [string]::IsNullOrEmpty($PageExpand)) {
          $newBody.'$expand' = $PageExpand
        }

        if ($PageSelect.Count -gt 0) {
          $newBody.'$select' = $PageSelect -join ','
        }

        if (-not [string]::IsNullOrEmpty($PageOrderBy)) {
          $newBody.'$orderby' = $PageOrderBy
        }

        $result = Get-3CXResult -Endpoint $Endpoint -Body $newBody
        if ($Limit) { $targetCount = $Limit }
        else { $targetCount = $result.'@odata.count' }
        $result.value | ForEach-Object { $values.Add($_) }
      }

      return $values
    }
  }
}