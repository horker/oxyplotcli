$key = cat private\NugetApiKey.txt

Publish-Module -Path $PSScriptRoot\..\oxyplotcli -NugetApiKey $key -Verbose
