function Select-QueryString {
    [CmdletBinding(DefaultParameterSetName = "IDictionary")]
    [OutputType([string])]
    param(
        [parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = "IDictionary")]
        [AllowNull()]
        [AllowEmptyCollection()]
        [System.Collections.IDictionary]
        $InputObject,

        [parameter(Mandatory = $true, ParameterSetName = "NameValueCollection")]
        [AllowNull()]
        [AllowEmptyCollection()]
        [System.Collections.Specialized.NameValueCollection]
        $NameValueCollection,

        [parameter(Position = 1, Mandatory = $true)]
        [Alias("Name")]
        [AllowNull()]
        [AllowEmptyCollection()]
        [AllowEmptyString()]
        [string[]]
        $Key
    )
    process {
        if ($InputObject -ne $null) { 
            foreach ($i in (ToString $Key)) {
                $list = $InputObject[$i]
                if (IsEmpty $list) {
                    $PSCmdlet.WriteObject([string]::Empty, $false)
                }
                else {
                    ToString $list
                }
            }
        }
        if ($NameValueCollection -ne $null) { 
            foreach ($i in (ToString $Key)) {
                $list = $NameValueCollection.GetValues($i)
                if (IsEmpty $list) {
                    $PSCmdlet.WriteObject([string]::Empty, $false)
                }
                else {
                    ToString $list
                }
            }
        }
    }
}
