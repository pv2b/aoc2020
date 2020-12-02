<#
--- Day 1: Report Repair ---

After saving Christmas five years in a row, you've decided to take a
vacation at a nice resort on a tropical island. Surely, Christmas will go
on without you.

The tropical island has its own currency and is entirely cash-only. The
gold coins used there have a little picture of a starfish; the locals just
call them stars. None of the currency exchanges seem to have heard of them,
but somehow, you'll need to find fifty of these coins by the time you
arrive so you can pay the deposit on your room.

To save your vacation, you need to get all fifty stars by December 25th.

Collect stars by solving puzzles. Two puzzles will be made available on
each day in the Advent calendar; the second puzzle is unlocked when you
complete the first. Each puzzle grants one star. Good luck!

Before you leave, the Elves in accounting just need you to fix your expense
report (your puzzle input); apparently, something isn't quite adding up.

Specifically, they need you to find the two entries that sum to 2020 and
then multiply those two numbers together.

For example, suppose your expense report contained the following:

1721
979
366
299
675
1456

In this list, the two entries that sum to 2020 are 1721 and 299.
Multiplying them together produces 1721 * 299 = 514579, so the correct
answer is 514579.

Of course, your expense report is much larger. Find the two entries that
sum to 2020; what do you get if you multiply them together?
#>


# My thought for an algorithm: Let's start by putting all the integers
# in a HashSet. Then we iterate over the original list, and then for
# every value n, we can look to see if there is an x present in the
# HashSet such that n+x = 2020, i.e. look for an x = 2020-n.
# This will be done in O(n) time, because lookup and insertions intoa
# HashSet is done in O(1) time.

<#
--- Part Two ---

The Elves in accounting are thankful for your help; one of them even offers
you a starfish coin they had left over from a past vacation. They offer you
a second one if you can find three numbers in your expense report that meet
the same criteria.

Using the above example again, the three entries that sum to 2020 are 979,
366, and 675. Multiplying them together produces the answer, 241861950.

In your expense report, what is the product of the three entries that sum
to 2020?
#>

# Oh dear, for part two, I had to completely re-think this. First of all,
# I refactored my code into being recursive. Second, to avoid duplicate
# solutions, I added a constraint saying the terms have to be in
# ascending order.

# Read the numbers from the file, making sure to parse them as integers.
$ValueList = @(Get-Content $PSScriptRoot\Day1-Input.txt | % { [int]$_ })

# Create a HashSet with all of the values.
$ValueSet = [System.Collections.Generic.HashSet[int]]$ValueList

function Solve {
    Param(
    # The sum we're expecting to see
    [Parameter(Mandatory=$true)][int]$ExpectedSum,

    # The numbers of terms we want
    [Parameter(Mandatory=$true)][int]$Terms,
    
    # The minimum allowable term. (This ensures we're getting unique
    # solutions by enforcing they need to be in ascending order.)
    [Parameter(Mandatory=$false)]$MinTerm = 1
    )

    if ($Terms -eq 1) {
        if ($ExpectedSum -ge $MinTerm -and $ValueSet.Contains($ExpectedSum)) {
            $ExpectedSum
        } else {
            throw "No solution found!"
        }
    } elseif ($Terms -gt 1) {
        $Results = @($ValueSet | Sort-Object | Where { $_ -lt $ExpectedSum -and $_ -ge $MinTerm } | Foreach-Object {
            $ValueSet.Remove($_) | Out-Null
            try {
                (Solve -ExpectedSum ($ExpectedSum - $_) -Terms ($Terms - 1) -MinTerm ($_ + 1)) * $_
            } catch {}
            $ValueSet.Add($_) | Out-Null
        })

        if ($Results.Count -ne 1) {
            throw "Expected 1 results, actually got $($Results.Count) results!"
        }

        $Results
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