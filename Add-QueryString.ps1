function Add-QueryString {
    [CmdletBinding(DefaultParameterSetName="KeyValue")]
    [OutputType([System.Collections.IDictionary])]
    param(
        [parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [System.Collections.IDictionary]
        $InputObject = (New-QueryString),

        [parameter(Mandatory=$true,Position=1,ParameterSetName="KeyValue")]
        [AllowNull()]
        [AllowEmptyString()]
        [Alias("Name")]
        [string]
        $Key,

        [parameter(Mandatory=$true,Position=2,ParameterSetName="KeyValue")]
        [AllowNull()]
        [AllowEmptyString()]
        [AllowEmptyCollection()]
        [string[]]
        $Value,

        [parameter(Mandatory=$true,Position=1,ParameterSetName="Values")]
        [System.Collections.IDictionary]
        $Values
    )
    process {
        switch($PSCmdlet.ParameterSetName) {
            "KeyValue" {
                #Write-Host "Add-QueryString: '$Key'='$Value'"
                $list = [System.Collections.ArrayList]::new()
                if(-not (IsEmpty $InputObject[$Key])) {
                    $InputObject[$Key] | ToString | % { 
                        #Write-Host "InputObject: list.Add($_)"
                        $null = $list.Add($_) 
                    }
                }
                if(-not (IsEmpty $Value)) {
                    $Value | ToString | % { 
                        #Write-Host "Value: list.Add($_)"
                        $null = $list.Add($_) 
                    }
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
                        $list = $list | ToString 
                    }
                    $InputObject = $InputObject | Add-QueryString -Key $key -Value $list
                }
            }
        }
        $InputObject
    }
}

