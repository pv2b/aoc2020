$Values = [System.Collections.Generic.List[int]] @(Get-Content $PSScriptRoot\Day1-Input.txt | % { [int]$_ })
$Values.Sort()

function Solve {
    Param(
    # The sum we're expecting to see
    [Parameter(Mandatory=$true)][int]$ExpectedSum,

    # The numbers of terms we want
    [Parameter(Mandatory=$true)][int]$Terms,
    
    # The index we start looking through the list at. (This ensures we're
    # getting unique solutions by enforcing they need to be in ascending
    # order.)
    [Parameter(Mandatory=$false)]$StartIndex = 0
    )

    $Count = $Values.Count - $StartIndex

    if ($Terms -eq 1) {
        $i = $Values.BinarySearch($StartIndex, $Count, $ExpectedSum, $null)
        if ($i -ge 0) {
            $ExpectedSum
        }
    } elseif ($Terms -gt 1) {
        for ($i = $StartIndex; $i -lt $Values.Count; $i++) {
            $Value = $Values[$i]
            $Result = (Solve -ExpectedSum ($ExpectedSum - $Value) -Terms ($Terms - 1) -StartIndex ($i + 1)) * $Value
            if ($Result) {
                return $Result
            }
        }
    } else {
        throw "Terms must be >= 1! (Is $Terms)"
    }
}

$Part1 = Solve -ExpectedSum 2020 -Terms 2
$Part2 = Solve -ExpectedSum 2020 -Terms 3

[pscustomobject]@{
    Day   = 1
    Part1 = $Part1
    Part2 = $Part2
}