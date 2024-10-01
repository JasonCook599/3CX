function Get-3CXDepartment {
  [CmdletBinding(DefaultParameterSetName = "Default")]
  param(
    [Parameter(ParameterSetName = "Default")]
    $Filter,

    [Parameter(ParameterSetName = "Default")]
    $Order = "Name",

    [Parameter(ParameterSetName = "Default")]
    [Parameter(ParameterSetName = "Single")]
    $Select = "Name,Number,Id,Hours,PromptSet,HasMembers,AllowCallService,AnswerAfter",

    [Parameter(ParameterSetName = "Default")]
    [Parameter(ParameterSetName = "Single")]
    $Expand,

    [Parameter(ParameterSetName = "Default")]
    [int]$Limit,

    [Parameter(ParameterSetName = "Single", Mandatory = $True)]
    [int]$ID
  )

  switch ($PSCmdlet.ParameterSetName) {
    "Default" {
      $params = @{
        Endpoint    = '/xapi/v1/Groups'
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
        Endpoint   = "/xapi/v1/Groups"
        ID         = $ID
        PageSelect = $Select
        PageExpand = $Expand
      }
    }
  }
  return Get-3CXResult @params
}
