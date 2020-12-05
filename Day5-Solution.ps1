function DecodeBinary($String, $Zero, $One) {
    [convert]::ToInt32($String.Replace($Zero, '0').Replace($One, '1'), 2)
}

function Get-BoardingPass {
    Get-Content $PSScriptRoot\Day5-Input.txt | % {
        if ($_ -match "^([FB]{7})([LR]{3})$") {
            $Row = DecodeBinary $matches[1] 'F' 'B'
            $Column = DecodeBinary $matches[2] 'L' 'R'
            $SeatID = (8 * $Row) + $Column

            [pscustomobject]@{
                Code   = $_
                Row    = $Row
                Column = $Column
                SeatID = $SeatID
            }
        } else {
            throw "Unparsable code: $_"
        }
    }
}

$BoardingPasses = Get-BoardingPass

# Find the range we should be looking in by sorting the boarding passes by seat ID.

$MeasureSeatID = $BoardingPasses | Measure-Object -Property SeatID -Minimum -Maximum # BEATS PER MINUTE!
$MinSeatID = $MeasureSeatID.Minimum
$MaxSeatID = $MeasureSeatID.Maximum

# Put all the SeatIDs in a HashSet so we can easilly see if a seat is taken or not

$SeatIDSet = [System.Collections.Generic.HashSet[int]]($BoardingPasses.SeatID)

# Find the SeatID that's not taken. (Also we know it's not MinSeatID and MaxSeatID because they exist. So...)

for ($SeatID = $MinSeatID+1; $SeatID -lt $MaxSeatID; $SeatID++) {
    if (-not $SeatIDSet.Contains($SeatID)) {
        $FreeSeatID = $SeatID
        break
    }
}

[pscustomobject]@{
    Day   = 5
    Part1 = $MaxSeatID
    Part2 = $FreeSeatID
}