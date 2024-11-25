function Add-QueryString {
    [CmdletBinding(DefaultParameterSetName = "KeyValue")]
    [OutputType([System.Collections.IDictionary])]
    param(
        [parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [System.Collections.IDictionary]
        $InputObject,

        [parameter(Mandatory = $true, Position = 1, ParameterSetName = "KeyValue")]
        [AllowNull()]
        [AllowEmptyString()]
        [Alias("Name")]
        [string]
        $Key,

        [parameter(Mandatory = $true, Position = 2, ParameterSetName = "KeyValue")]
        [AllowNull()]
        [AllowEmptyString()]
        [AllowEmptyCollection()]
        [string[]]
        $Value,

        [parameter(Mandatory = $true, Position = 1, ParameterSetName = "Values")]
        [System.Collections.IDictionary]
        $Values
    )
    process {
        switch ($PSCmdlet.ParameterSetName) {
            "KeyValue" {
                #Write-Host "Add-QueryString: '$Key'='$Value'"
                $list = [System.Collections.ArrayList]::new()
                foreach ($i in (ToString $InputObject[$key])) {
                    #Write-Host "InputObject: list.Add($i)"
                    $null = $list.Add($i)
                }
                foreach ($i in (ToString $Value)) {
                    #Write-Host "InputObject: list.Add($i)"
                    $null = $list.Add($i)
                }
                $InputObject[$Key] = $list
            }
            "Values" {
                foreach ($kv in $Values.GetEnumerator()) {                    
                    $keys = ToString $kv.Key
                    if (IsEmpty $keys) {
                        $keys = [string]::Empty
                    }
                    foreach ($key in $keys) {
                        $list = ToString $kv.Value
                        if (IsEmpty $list) {                            
                            $list = [string]::Empty
                        }
                        $InputObject = $InputObject | Add-QueryString -Key $key -Value $list
                    }
                }
            }
        }
        $PSCmdlet.WriteObject($InputObject, $false)        
    }
}
