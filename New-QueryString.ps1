function New-QueryString {
    [CmdletBinding()]
    [OutputType([System.Collections.IDictionary])]
    param(
    )
    process {
        $t = [System.Collections.Specialized.OrderedDictionary]::new()
        $PSCmdlet.WriteObject($t, $false)
    }
}
