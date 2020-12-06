$GroupMembers = 0
$Answers = @{}
$Part1 = 0
$Part2 = 0

# Add an artificial empty line at the end of the output to ensure that
# the final group is counted.
$Lines = @(Get-Content $PSScriptRoot\Day6-Input.txt) + @('')

foreach ($Line in $Lines) {
    if ($Line -eq '') {
        # Handle end of group by collating the answers
        foreach ($Value in $Answers.Values) {
            if ($Value -gt 0) {
                $Part1++
                if ($Value -eq $GroupMembers) {
                    $Part2++
                }
            }
        }
        $GroupMembers = 0
        $Answers = @{}
    } else {
        # Handle new answers within group
        $GroupMembers++
        foreach ($Answer in [char[]]$Line) {
            $Answers[$Answer]++
        }
    }
}

[pscustomobject]@{
    Day   = 6
    Part1 = $Part1
    Part2 = $Part2
}