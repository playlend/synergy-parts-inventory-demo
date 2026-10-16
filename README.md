# Parts inventory (Traditional Synergy DBL)

A small ISAM-backed parts inventory: a repository with one structure, a
library of file routines and business rules, a command-line program, and unit
tests for the library. It is a sample for the DevPartner 2026 session on
AI-directed development, so it is meant to be read in a few minutes. To run the
session's demo yourself, see `demo\README.md`.

## Requirements

- Windows, Synergy/DE 12 (x64), Visual Studio 2026 with Synergy DBL Integration (SDI).
- The repository project uses the `Synergex.SynergyDE.Build` NuGet package.
  Visual Studio restores it when the solution opens. On the command line, run
  `nuget restore PartsInventory.slnx` (needs nuget.exe); `msbuild -t:restore`
  skips Synergy projects.

## Build and test

In Visual Studio: open `PartsInventory.slnx`, build the Debug x64 configuration,
and run the tests in Test Explorer.

On the command line, from a Developer PowerShell (or Developer Command Prompt)
for Visual Studio in the repository root:

```
msbuild PartsInventory.slnx -p:Configuration=Debug -p:Platform=x64 -v:minimal
vstest.console Debug\x64\PartsInventoryTests.elb
```

Everything goes to `Debug\x64`: `PartsInventory.dbr`, `PartsInventoryLib.elb`,
and `PartsInventoryTests.elb`. `vstest.console` runs the same tests as Test
Explorer; there is no MSBuild target for Traditional unit tests.

## Run

The program needs two logicals: `EXEDIR` (the build output, where it finds
`PartsInventoryLib.elb`) and `DAT` (the data folder). Visual Studio sets both
from `Common.props` when it runs the PartsInventory project; pass the command as
its command-line arguments. From a Synergy/DE command prompt in the repository
root:

```
set EXEDIR=%CD%\Debug\x64\
set DAT=%CD%\data\
dbr Debug\x64\PartsInventory.dbr load
dbr Debug\x64\PartsInventory.dbr list
```

| Command | What it does |
|---------|--------------|
| `load` | rebuild `data\parts.ism` from `data\parts.txt` |
| `list` | list every part in part-number order |
| `find 200100` | show one part |
| `receive 300200 10` | add stock |
| `issue 100100 50` | remove stock (fails if not enough on hand) |

## Layout

| Path | What it is |
|------|------------|
| `PartsInventoryRepository\repository.scm` | structure `PART` and file `PARTS`; the only place field names and sizes live |
| `PartsInventoryLib\PartsIO.dbl` | ISAM routines: create, open, close, find, first, next, update; no output |
| `PartsInventoryLib\PartsRules.dbl` | business rules, one function per rule, no file access |
| `PartsInventory\Program.dbl` | command parsing and all output, one internal subroutine per command |
| `PartsInventoryTests\` | unit tests for the library (`PartsIOTests`, `PartsRulesTests`) |
| `data\parts.txt` | seed data, pipe-delimited: `partno\|description\|qty\|reorder\|price` |
| `Common.props` | environment for Visual Studio: `EXEDIR` (build output) and `DAT` (data folder) |
| `demo\` | the conference demo: the AI instructions file and the prompt (see `demo\README.md`) |
