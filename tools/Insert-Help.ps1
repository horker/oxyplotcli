[cmdletbinding()]
param(
  [xml]$HelpDocument,
  [string]$ClassName
)

Set-StrictMode -Version 3

$links = New-Object Collections.Generic.List[string]

function Get-PlainText {
  param(
    [xml.XmlElement]$Xml
  )

  if ($null -eq $Xml) {
    return
  }

  $out = New-Object Text.StringBuilder

  foreach ($node in $Xml.ChildNodes) {
    switch ($node.Name) {
      "#text" {
        # Modify descriptions for properties to those for cmdlet parameters
        $s = $node.InnerText -replace "^\s*Gets or sets ", "Sets "

        # .NET XML component returns multiple lines that end with LF only.
        $s = $s -replace "`n", "`r`n"

        [void]$out.Append($s)
      }
      "see" {
        [void]$out.Append(($node.cref -replace "^.:", ""))
      }
      "a" {
        [void]$out.Append((Get-PlainText $node))
        [void]$out.Append(" ($($node.href))")
        $links.Add($node.href)
      }
      default {
        [void]$out.Append((Get-PlainText $node))
      }
    }
  }

  if ($Xml.Name -eq "summary" -or $Xml.Name -eq "remarks") {
    [void]$out.Append("`r`n")
  }

  $out.ToString()
}

$members = $HelpDocument.doc.members.member

$classDescription = $members | where { $_.name -eq "T:$ClassName" }

$classes = New-Object Collections.Generic.List[string]

$c = Invoke-Expression "[$ClassName]"
while ($c) {
  $classes.Add($c.FullName)
  $c = $c.BaseType
}

$props = $members |
  where { $_.name -match "^P:" -and $_.name -notmatch "#ctor$" } |
  where { $classes.Contains(($_.name -replace "^.:", "" -replace "\.([^.]+)$")) }

(. {
  ".SYNOPSIS"
  Get-PlainText $classDescription
  ""

  foreach ($p in $props) {
    ".PARAMETER $($p.name -replace "^.+\.", '')"
    (Get-PlainText $p)
    ""
  }

  foreach ($l in $links) {
    ".LINK"
    $l
    ""
  }
}) -join "`r`n" -replace "([ `t]*`r?`n[ `t]*){2,}", "`r`n`r`n" -replace "`n[ `t]+", "`n"
