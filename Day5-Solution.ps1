function Get-SeatID {
    Get-Content $PSScriptRoot\Day5-Input.txt | % {
        [convert]::ToInt32(($_ -replace '[FL]', '0' -replace '[BR]', '1'), 2)
    }
}

$SeatIDs = Get-SeatID

# Find the range we should be looking in by sorting the boarding passes by seat ID.

$MeasureSeatID = $SeatIDs | Measure-Object -Minimum -Maximum # BEATS PER MINUTE!
$MinSeatID = $MeasureSeatID.Minimum
$MaxSeatID = $MeasureSeatID.Maximum

# Put all the SeatIDs in a HashSet so we can easilly see if a seat is taken or not

$SeatIDSet = [System.Collections.Generic.HashSet[int]]($SeatIDs)

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