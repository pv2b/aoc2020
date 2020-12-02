function Get-PuzzleInput {
    Get-Content $PSScriptRoot\Day2-Input.txt | % {
        if ($_ -match '^(\d+)-(\d+) (.): (.+)$') {
            [pscustomobject]@{
                Password = $matches[4]
                PolicyCharacter = $matches[3]
                PolicyMinCount = [int]$matches[1]
                PolicyMaxCount = [int]$matches[2]
            }
        } else {
            throw "Parse error on line $_"
        }
    }
}

$Part1 = (Get-PuzzleInput | Where {
    $Occurrences = 0
    foreach ($Character in [char[]]$_.Password) {
        if ($Character -eq $_.PolicyCharacter) {
            $Occurrences += 1
        }
    }
    # True if valid
    ($Occurrences -ge $_.PolicyMinCount) -and ($Occurrences -le $_.PolicyMaxCount)
} | Measure-Object).Count

$Part2 = (Get-PuzzleInput | Where {
    ($_.Password[$_.PolicyMinCount - 1] -eq $_.PolicyCharacter) -xor ($_.Password[$_.PolicyMaxCount - 1] -eq $_.PolicyCharacter)
} | Measure-Object).Count

[pscustomobject]@{
    Day   = 2
    Part1 = $Part1
    Part2 = $Part2
}