# Private settings for this machine. NOT committed.
# Copy to the folder of $PROFILE as local.ps1 (Split-Path $PROFILE), then edit:
#   Copy-Item $HOME\PDE\windows\powershell\local.example.ps1 (Join-Path (Split-Path $PROFILE) local.ps1)
# The profile loads it first. Do not put it in the repo: it holds the proxy address and may hold credentials.

$env:HTTP_PROXY  = "http://proxy.example.com:8080"
$env:HTTPS_PROXY = "http://proxy.example.com:8080"
$env:NO_PROXY    = "localhost,127.0.0.1,.example.com"
# Some tools read the lowercase names.
$env:http_proxy  = $env:HTTP_PROXY
$env:https_proxy = $env:HTTPS_PROXY
$env:no_proxy    = $env:NO_PROXY
