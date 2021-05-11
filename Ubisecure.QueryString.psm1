function IsEmpty {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Position=0,Mandatory=$true)]
        [AllowNull()]
        [object]
        $InputObject
    )
    process {
        if($InputObject -eq $null) { return $true }
        if($InputObject -is [string]) { return $false }
        if($InputObject -is [System.Collections.IEnumerable]) { return -not $InputObject.GetEnumerator().MoveNext() }
        return $false
    }
}

function ToString {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)]
        [AllowNull()]
        [AllowEmptyString()]
        [AllowEmptyCollection()]
        [object]
        $InputObject
    )
    process {
        if($InputObject -eq $null) { return }
        elseif($InputObject -is [string]) { return $InputObject }
        elseif($InputObject -is [System.Collections.IEnumerable]) { 
            foreach($i in $InputObject.GetEnumerator()) {
                $i | ToString
            }
            return
        }
        else { return $InputObject.ToString() }
    }
}

