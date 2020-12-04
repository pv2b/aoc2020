function Get-Passport {
    $Passport = [pscustomobject]@{}
    Get-Content $PSScriptRoot/Day4-Input.txt | % {
        if ($_ -eq '') {
            # Blank line, next passport!
            $Passport
            $Passport = [pscustomobject]@{}
        } else {
            (Select-String -InputObject $_ -Pattern "([^:\s]+):([^:\s]+)" -AllMatches).Matches | % {
                $Passport | Add-Member $_.Groups[1].Value $_.Groups[2].Value
            }
        }
    }
    # Last passport
    $Passport
}

function Get-ValidPassport {
    Param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]$Passport
    )

    Process {
        $KeysToCheck = @('byr', 'iyr', 'eyr', 'hgt', 'hcl', 'ecl', 'pid')
        $Valid = $true
        foreach ($Key in $KeysToCheck) {
            if (-not ($Passport | Get-Member -Name $Key)) {
                $Valid = $false
                break
            }
        }
        if ($Valid) {
            $Passport
        }
    }
}

function Get-ValidPassport2 {
    Param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]$Passport
    )

    Process {
        [int]$byr = $_.byr
        if (($byr -lt 1920) -or ($byr -gt 2002)) {
            return
        }

        [int]$iyr = $_.iyr
        if (($iyr -lt 2010) -or ($iyr -gt 2020)) {
            return
        }

        [int]$eyr = $_.eyr
        if (($eyr -lt 2020) -or ($eyr -gt 2030)) {
            return
        }
        if ($_.hgt -match "^(\d+)(cm|in)") {
            [int]$height = $matches[1]
            $unit = $matches[2]
            switch ($unit) {
                'cm' {
                    if (($height -lt 150) -or ($height -gt 193)) {
                        return
                    }
                }
                'in' {
                    if (($height -lt 59) -or ($height -gt 76)) {
                        return
                    }
                }
            }
        } else {
            return
        }

        if ($_.hcl -notmatch '^#[0-9a-f]{6}$') {
            return
        }

        if (@('amb', 'blu', 'brn', 'gry', 'grn', 'hzl', 'oth') -notcontains $_.ecl) {
            return
        }

        if ($_.pid -notmatch '^[0-9]{9}$') {
            return
        }

        $Passport
    }
}

$ValidPassports = Get-Passport | Get-ValidPassport
$ValidPassports2 = $ValidPassports | Get-ValidPassport2

$Part1 = ($ValidPassports | Measure-Object).Count
$Part2 = ($ValidPassports2 | Measure-Object).Count

[pscustomobject]@{
    Day   = 4
    Part1 = $Part1
    Part2 = $Part2
}