$query = New-QueryString |
    Add-QueryString "response_type" "code" |
    Add-QueryString "client_id" "public" |
    Add-QueryString "scope" "openid" |
    Add-QueryString "redirect_uri" "http://localhost/public" |
    ConvertTo-QueryString

Start-Process "https://login.example.ubidemo.com/uas/oauth2/authorization?$query"
