function IsEmpty {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Position = 0, Mandatory = $true)]
        [AllowNull()]
        [AllowEmptyString()]
        [AllowEmptyCollection()]
        [object]
        $InputObject
    )
    process {
        if ($null -eq $InputObject) { return $true }
        elseif ($InputObject -is [string]) { return $false }
        elseif ($InputObject -is [System.Collections.IEnumerable]) { 
            foreach ($i in $InputObject.GetEnumerator()) {
                if (-not (IsEmpty $i)) { return $false }
            }
            return $true
        }
        else { return $false }
    }
}
