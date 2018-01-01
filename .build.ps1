
task . Load, Build, LocalImport

task Load {
  Import-Module HorkerTemplateEngine
  OxyPlotCli\AssemblyLoader.ps1
}

task Build {
  Copy-Item -Recurse -Force "$PSScriptRoot\scripts\*" "$PSScriptRoot\OxyPlotCli"

  Invoke-Build -File "$PSScriptRoot\templates\template.build.ps1"
}

task LocalImport {
  Import-Module .\OxyPlotCli -force
}

task Install {
  Remove-Item -Recurse -Force ~\Documents\WindowsPowerShell\Modules\OxyPlotCli -EA Continue
  Copy-Item -Recurse -Force .\OxyPlotCli ~\Documents\WindowsPowerShell\Modules
}
