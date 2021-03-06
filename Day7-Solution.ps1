﻿$BagRules = @{}
Select-String -Path $PSScriptRoot\Day7-Input.txt -AllMatches "^(.+) bags contain (?:(?:(?:(\d+ .+?) bags?)(?:, |.))+|no other bags.)$" | % {
    $g = $_.Matches.Groups
    $Container = $g[1].Value
    $Contents = @{}
    foreach ($Content in $g[2].Captures.Value) {
        $Count, $Type = $Content -split ' ', 2
        $Contents[$Type] = [int]$Count
    }
    $BagRules[$Container] = $Contents
}

$CanContainMemo = @{}
function CanContain {
    Param($Container, $DesiredContent)

    $MemoKey = "$Container $DesiredContent"

    if (-not $CanContainMemo.ContainsKey($MemoKey)) {
        if ($BagRules[$Container].ContainsKey($DesiredContent)) {
            $CanContainMemo[$MemoKey] = $true
        } else {
            $CanContainMemo[$MemoKey] = $false
            foreach ($ContainedContainer in $BagRules[$Container].Keys) {
                if (CanContain $ContainedContainer $DesiredContent) {
                    $CanContainMemo[$MemoKey] = $true
                    break
                }
            }
        }
    }

    return $CanContainMemo[$MemoKey]
}

$ContainsCountMemo = @{}
function ContainsCount {
    Param($Container)
    if (-not $ContainsCountMemo.ContainsKey($Container)) {
        $ContainsCountMemo[$Container] = ($BagRules[$Container].GetEnumerator() | % {
            $_.Value * (1 + (ContainsCount $_.Name))
        } | Measure-Object -Sum).Sum
    }
    return $ContainsCountMemo[$Container]
}

$Part1 = ($BagRules.Keys | Where { CanContain $_ "shiny gold" } | Measure-Object).Count
$Part2 = ContainsCount "shiny gold"

[pscustomobject]@{
    Day   = 7
    Part1 = $Part1
    Part2 = $Part2
}