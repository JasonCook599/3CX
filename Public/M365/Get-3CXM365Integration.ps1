function Get-3CXM365Integration {
  param()
  Get-3CXResult -Endpoint "/xapi/v1/Microsoft365Integration"
}