function New-QueryString {
    [CmdletBinding()]
    [OutputType([System.Collections.IDictionary])]
    param(
    )
    process {
        [System.Collections.Specialized.OrderedDictionary]::new()
    }
}
