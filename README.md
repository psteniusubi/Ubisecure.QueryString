# PowerShell module for query string format 

Used by [Ubisecure.OAuth2](../../../Ubisecure.OAuth2), [Ubisecure.SSO.Management](../../../Ubisecure.SSO.Management)

## Install from github.com

Windows

```cmd
cd /d %USERPROFILE%\Documents\WindowsPowerShell\Modules
git clone --recurse-submodules https://github.com/psteniusubi/Ubisecure.QueryString.git
```

Linux

```bash
cd ~/.local/share/powershell/Modules
git clone --recurse-submodules https://github.com/psteniusubi/Ubisecure.QueryString.git
```

## Example use

```powershell
$query = New-QueryString |
    Add-QueryString "response_type" "code" |
    Add-QueryString "client_id" "public" |
    Add-QueryString "scope" "openid" |
    Add-QueryString "redirect_uri" "http://localhost/public" |
    ConvertTo-QueryString

Start-Process "https://login.example.ubidemo.com/uas/oauth2/authorization?$query"
```
