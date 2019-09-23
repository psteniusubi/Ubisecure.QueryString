function New-QueryString {
    [CmdletBinding()]
    param(
    )
    process {
        [System.Collections.Specialized.OrderedDictionary]::new()
    }
}

function IsEmpty {
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

function Add-QueryString {
    [CmdletBinding(DefaultParameterSetName="KeyValue")]
    param(
        [parameter(Mandatory=$true,Position=2,ValueFromPipeline=$true)]
        [System.Collections.IDictionary]
        $InputObject = (New-QueryString),

        [parameter(Mandatory=$true,Position=0,ParameterSetName="KeyValue")]
        [AllowNull()]
        [AllowEmptyString()]
        [Alias("Name")]
        [string]
        $Key,

        [parameter(Mandatory=$true,Position=1,ParameterSetName="KeyValue")]
        [AllowNull()]
        [AllowEmptyString()]
        [AllowEmptyCollection()]
        [string[]]
        $Value,

        [parameter(Mandatory=$true,Position=0,ParameterSetName="Values")]
        [System.Collections.IDictionary]
        $Values
    )
    process {
        switch($PSCmdlet.ParameterSetName) {
            "KeyValue" {
                #Write-Host "Add-QueryString: '$Key'='$Value'"
                $list = [System.Collections.ArrayList]::new()
                if(-not (IsEmpty $InputObject[$Key])) {
                    $InputObject[$Key] | Out-String -Stream | % { $null = $list.Add($_) }
                }
                if(-not (IsEmpty $Value)) {
                    $Value | Out-String -Stream | % { $null = $list.Add($_) }
                }
                $InputObject[$Key] = $list
            }
            "Values" {
                foreach($kv in $Values.GetEnumerator()) {
                    $key = $kv.Key
                    $list = $kv.Value
                    if(IsEmpty $list) {
                        $list = @()
                    } else {
                        $list = $list | Out-String -Stream
                    }
                    $InputObject = $InputObject | Add-QueryString -Key $key -Value $list
                }
            }
        }
        $InputObject
    }
}

function ConvertTo-QueryString {
    [CmdletBinding()]
    param(
        [parameter(ValueFromPipeline=$true)]
        [AllowNull()]
        [AllowEmptyCollection()]
        [System.Collections.IDictionary]
        $InputObject
    )
    begin {        
        $t = @()
    }
    process {
        if($InputObject -eq $null) { return }
        foreach($kv in $InputObject.GetEnumerator()) {
            $key = $kv.Key
            $list = $kv.Value
            if(IsEmpty $list) {
                $list = @( [string]::Empty )
            } else {
                $list = $list | Out-String -Stream
            }
            foreach($value in $list) {
                if([string]::IsNullOrEmpty($key)) {
                    #Write-Host "ConvertTo-QueryString: '$value'"
                    $t += [System.Net.WebUtility]::UrlEncode($value) 
                } else {
                    #Write-Host "ConvertTo-QueryString: '$key'='$value'"
                    $t += [System.Net.WebUtility]::UrlEncode($key),[System.Net.WebUtility]::UrlEncode($value) -join "="
                }
            }
        }
    }
    end {
        $t -join "&"
    }
}

function Select-QueryString {
    [CmdletBinding()]
    param(
        [parameter(Position=1,Mandatory=$true,ValueFromPipeline=$true)]
        [AllowNull()]
        [AllowEmptyCollection()]
        [System.Collections.IDictionary]
        $InputObject,

        [parameter(Position=0,Mandatory=$true)]
        [Alias("Name")]
        [AllowNull()]
        [AllowEmptyCollection()]
        [AllowEmptyString()]
        [string[]]
        $Key
    )
    process {
        if($InputObject -eq $null) { return }
        $Key | Out-String -Stream | % { 
            $list = $InputObject[$_] 
            if(IsEmpty $list) {
                [string]::Empty
            } else {
                $list
            }
        } | Out-String -Stream
    }
}

function ConvertFrom-QueryString {
    [CmdletBinding()]
    param(
        [parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)]
        [AllowNull()]
        [AllowEmptyString()]
        [string]
        $InputObject
    )
    begin {        
        $t = New-QueryString
    }
    process {
        if([string]::IsNullOrEmpty($InputObject)) { return }
        $InputObject = $InputObject -replace "^[^\?]*\?",""
        $InputObject -split "&" | % {
            if($_ -match "^([^=]*)(=(.*))?$") {
                $key = $Matches[1]
                $value = $Matches[3]
                #Write-Host "ConvertFrom-QueryString: Matches.Count = $($Matches.Count)"
                switch($Matches.Count) {
                    2 { 
                        #Write-Host "ConvertFrom-QueryString: ''='$key'"
                        $t = $t | Add-QueryString -Key ([string]::Empty) -Value $key 
                    }
                    4 { 
                        #Write-Host "ConvertFrom-QueryString: '$key'='$value'"
                        $t = $t | Add-QueryString -Key $key -Value $value
                    }
                }                
            }
        }
    }
    end {
        $t
    }
}

