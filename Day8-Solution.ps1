function Get-Program {
    $Program = @()

    # Load program
    Get-Content $PSScriptRoot\Day8-Input.txt | % {
        $Operation, [int]$Operand = $_ -split ' ', 2
        $Program += @([pscustomobject]@{
            Operation=$Operation
            Operand=$Operand
        })
    }
    $Program
}

$Program = Get-Program

class AocVirtualMachine
{
    [int]$ProgramCounter
    [int]$Accumulator
    [int]$MutatedInstructionCounter
    [pscustomobject[]]$Program

    AocVirtualMachine ($Program, $MutatedInstructionCounter) {
        $this.Program = $Program
        $this.ProgramCounter = 0
        $this.Accumulator = 0
        $this.MutatedInstructionCounter = $MutatedInstructionCounter
    }

    [void]Execute($Operation, $Operand) {
        if ($this.IsHalted()) {
            throw 'Halted!'
        }
        switch ($Operation) {
            'acc' {
                $this.Accumulator += $Operand
                $this.ProgramCounter += 1
            }
            'jmp' {
                $this.ProgramCounter += $Operand
            }
            'nop' {
                $this.ProgramCounter += 1
            }
            default {
                throw "Illegal operation: $Operation"
            }
        }
    }

    [void]Step() {
        $Instruction = $this.Program[$this.ProgramCounter]
        $Operation = $Instruction.Operation
        $Operand = $Instruction.Operand

        if ($this.ProgramCounter -eq $this.MutatedInstructionCounter) {
            switch ($Operation) {
                'jmp' { $Operation = 'nop' }
                'nop' { $Operation = 'jmp' }
            }
        }

        $this.Execute($Operation, $Operand)
    }

    [bool]IsHalted() {
        return ($this.ProgramCounter -ge $this.Program.Length) -or ($this.ProgramCounter -lt 0)
    }
}

$Part1VM = [AocVirtualMachine]::new($Program, -1)
$Heatmap = @(0) * $Program.Length
while ($HeatMap[$Part1VM.ProgramCounter] -eq 0) {
    $HeatMap[$Part1VM.ProgramCounter] += 1
    $Part1VM.Step()
}
$Part1 = $Part1VM.Accumulator

# Initialize a bunch of VMs, each with their own mutation
$Part2VMs = @()
for ($MutatedInstructionCounter = 0; $MutatedInstructionCounter -lt $Program.Length; $MutatedInstructionCounter++) {
    $Operation = $Program[$MutatedInstructionCounter].Operation
    if (($Operation -eq 'jmp') -or ($Operation -eq 'nop')) {
        $Part2VMs += @([AocVirtualMachine]::new($Program, $MutatedInstructionCounter))
    }
}

# Step once step on all VMs until one of them halts
$Part2 = $null
do {
    foreach ($VM in $Part2VMs) {
        $VM.Step()
        if ($VM.IsHalted()) {
            $Part2 = $VM.Accumulator
            break
        }
    }
} while ($Part2 -eq $null)

[pscustomobject]@{
    Day   = 8
    Part1 = $Part1
    Part2 = $Part2
}