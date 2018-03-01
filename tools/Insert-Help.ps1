[cmdletbinding()]
param(
  [xml]$HelpDocument,
  [string]$ClassName
)

Set-StrictMode -Off

function Get-PlainText {
  param(
    [object]$MemberElement
  )

  if ($null -eq $MemberElement) {
    return
  }

  if ($MemberElement -is [string]) {
    return $MemberElement
  }

  $out = New-Object Text.StringBuilder

  foreach ($node in $MemberElement.ChildNodes) {
    switch ($node.Name) {
      "#text" {
        [void]$out.Append($node.InnerText)
      }
      "see" {
        [void]$out.Append(($node.cref -replace "^.:", ""))
      }
      default {
        [void]$out.Append($node.InnerText)
      }
    }
  }

  $out.ToString()
}

$doc = $HelpDocument.doc.members.member

$member = $doc | where { $_.name -eq "T:$ClassName" }

(. {
  "<#"
  ".SYNOPSIS"
  Get-PlainText $member.summary
  Get-PlainText $member.remarks
  ""

  $props = $doc | where { $_.name -like "P:$ClassName*" }

  foreach ($p in $props) {
    ".PARAMETER $($p.name -replace "^.+\.", '')"
    Get-PlainText $p.summary
    Get-PlainText $p.remarks
    ""
  }

  "#>"
}) -join "`r`n"
