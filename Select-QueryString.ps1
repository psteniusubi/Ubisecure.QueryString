function Select-QueryString {
    [CmdletBinding(DefaultParameterSetName="IDictionary")]
    [OutputType([string])]
    param(
        [parameter(Mandatory=$true,ValueFromPipeline=$true,ParameterSetName="IDictionary")]
        [AllowNull()]
        [AllowEmptyCollection()]
        [System.Collections.IDictionary]
        $InputObject,

        [parameter(Mandatory=$true,ParameterSetName="NameValueCollection")]
        [AllowNull()]
        [AllowEmptyCollection()]
        [System.Collections.Specialized.NameValueCollection]
        $NameValueCollection,

        [parameter(Position=1,Mandatory=$true)]
        [Alias("Name")]
        [AllowNull()]
        [AllowEmptyCollection()]
        [AllowEmptyString()]
        [string[]]
        $Key
    )
    process {
        if($InputObject -ne $null) { 
            $Key | ToString | % { 
                $list = $InputObject[$_] 
                if(IsEmpty $list) {
                    [string]::Empty
                } else {
                    $list
                }
            } | ToString 
        }
        if($NameValueCollection -ne $null) { 
            $Key | ToString | % { 
                $list = $NameValueCollection.GetValues($_)
                if(IsEmpty $list) {
                    [string]::Empty
                } else {
                    $list
                }
            } | ToString 
        }
    }
}

