function Get-3CXDepartmentMembers {
  [CmdletBinding(DefaultParameterSetName = "Default")]
  param(
    [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
    $ID,
    $Filter,
    $Order = "Name",
    $Select = "GroupId,Name,Number,Id,MemberName,Type,CanDelete",
    $Expand,
    [int]$Limit

  )

  BEGIN {}
  PROCESS {
    $params = @{
      Endpoint    = "/xapi/v1/Groups($ID)/Members"
      Paginate    = $true
      PageFilter  = $Filter
      PageOrderBy = $Order
      PageSelect  = $Select
      PageExpand  = $Expand
      Limit       = $Limit
    }
    return Get-3CXResult @params
  }
  END {}
}
