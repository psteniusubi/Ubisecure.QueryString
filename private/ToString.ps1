function ToString {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true)]
        [AllowNull()]
        [AllowEmptyString()]
        [AllowEmptyCollection()]
        [object]
        $InputObject
    )
    process {
        if ($null -eq $InputObject) { }
        elseif ($InputObject -is [string]) { $PSCmdlet.WriteObject($InputObject, $false) }
        elseif ($InputObject -is [System.Collections.IEnumerable]) { 
            foreach ($i in $InputObject.GetEnumerator()) {
                foreach ($j in (ToString $i)) {
                    $PSCmdlet.WriteObject($j, $false)
                }                
            }
        }
        else { $PSCmdlet.WriteObject($InputObject.ToString(), $false) }
    }
}
