
function New-QueryString {
    [CmdletBinding()]
    param()
    Process {
        [PSCustomObject] @{
            "PSTypeName" = "QueryString";
            "Value" = [System.Collections.Specialized.NameValueCollection]::new();
        }
    }
}

function Add-QueryString {
    [CmdletBinding()]
    param(
        [parameter(Mandatory=$true,Position=0,ParameterSetName="NameValue")] 
        [string] 
        $Name,

        [parameter(Mandatory=$true,Position=1,ParameterSetName="NameValue")] 
        [AllowEmptyString()] 
        [string] 
        $Value,
    
        [parameter(Mandatory=$true,Position=0,ParameterSetName="Hashtable")] 
        [hashtable] 
        $Values,
    
        [parameter(Mandatory=$true,Position=2,ValueFromPipeline=$true)] 
        [PSTypeName("QueryString")] 
        $QueryString 
    )
    Begin {
        $out = New-QueryString
        switch ($PsCmdlet.ParameterSetName) {
            "NameValue" {
                $out.Value.Add($Name, $Value)
            }
            "Hashtable" {
                $Values.Keys | % {
                    $key = $_
                    $Values[$key] | % {
                        Write-Verbose "$key $_"
                        $out.Value.Add($key, $_)
                    }
                }
            }
        }        
    }
    Process {
        $out.Value.Add($QueryString.Value)
    }
    End {
        return $out
    }
}

function Select-QueryString {
    [CmdletBinding()]
    param(
        [parameter(Mandatory=$true,Position=0)] 
        [string[]] 
        $Name,

        [parameter(Mandatory=$true,Position=1,ValueFromPipeline=$true)] 
        [PSTypeName("QueryString")] 
        $QueryString = (New-QueryString)
    )
    Process {
        $Name | % {
            $QueryString.Value.GetValues($_)
        }
    }
}

function ConvertTo-QueryString {
    [CmdletBinding()]
    param(
        [parameter(Mandatory=$true,Position=0,ValueFromPipeline=$true,ParameterSetName="QueryString")] 
        [PSTypeName("QueryString")] 
        $QueryString,

        [parameter(Mandatory=$true,Position=0,ValueFromPipeline=$true,ParameterSetName="Hashtable")] 
        [hashtable] 
        $InputObject
    )
    Begin {
        $out = @()
    }
    Process {
        if($QueryString) {
            $out += $QueryString.Value.AllKeys | % { 
			    $key = $_
			    $QueryString.Value.GetValues($key) | % {
                    $value = $_
                    [System.Net.WebUtility]::UrlEncode($key),[System.Net.WebUtility]::UrlEncode($value) -join "=" 
                }
            }
        } elseif($InputObject) {
            $out += $InputObject.Keys | % { 
			    $key = $_
			    $InputObject[$key] | % {
                    $value = $_
                    [System.Net.WebUtility]::UrlEncode($key),[System.Net.WebUtility]::UrlEncode($value) -join "=" 
                }
            }
        }
    }
    End {
        $out -join "&"
    }
}

function ConvertFrom-QueryString {
    [CmdletBinding()]
    param(
        [parameter(Mandatory=$true,Position=0,ValueFromPipeline=$true)] 
        [AllowEmptyString()] 
        [string] 
        $Value
    )
    Begin {
        Add-Type -AssemblyName "System.Web" -ErrorAction Stop
        $out = New-QueryString
    }
    Process {
        $out.Value.Add([System.Web.HttpUtility]::ParseQueryString($Value))
    }
    End {
        return $out
    }
}

