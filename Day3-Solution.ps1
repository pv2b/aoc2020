$Map = Get-Content $PSScriptRoot\Day3-Input.txt

function TreeCountForSlope {
    Param([int]$ColumnSlope, [int]$RowSlope)
    $TreeCount = 0
    $Row = 0
    $Column = 0
    while ($Row -lt $Map.Length) {
        $RowMap = $Map[$Row]
        $WrappedColumn = $Column % $RowMap.Length
        $CurrentCell = $RowMap[$WrappedColumn]
        if ($CurrentCell -eq '#') {
            $TreeCount += 1
        }
        $Row += $RowSlope
        $Column += $ColumnSlope
    }
    $TreeCount
}

$Part1 = TreeCountForSlope -ColumnSlope 3 -RowSlope 1

$Slopes = @(
    @{ColumnSlope=1; RowSlope=1}
    @{ColumnSlope=3; RowSlope=1}
    @{ColumnSlope=5; RowSlope=1}
    @{ColumnSlope=7; RowSlope=1}
    @{ColumnSlope=1; RowSlope=2}
)

$Part2 = 1
foreach ($Slope in $Slopes) {
    $Part2 *= TreeCountForSlope @Slope
}

[pscustomobject]@{
    Day   = 3
    Part1 = $Part1
    Part2 = $Part2
}