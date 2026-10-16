# Parts inventory (Traditional Synergy DBL, Visual Studio solution)

ISAM-backed parts inventory. Windows, Synergy/DE 12 x64, Visual Studio with SDI.
The shell is a Developer PowerShell for Visual Studio, so `msbuild` and `vstest.console`
are on PATH. Run every command from the repository root.

## Build, test, run
- Restore, only if `packages\` is missing: `nuget restore PartsInventory.slnx`. If nuget isn't
  found, stop and ask the user to open the solution in Visual Studio once (that restores it).
  `msbuild -t:restore` doesn't work for Synergy projects.
- Build: `msbuild PartsInventory.slnx -p:Configuration=Debug -p:Platform=x64 -v:minimal`.
  Output goes to `Debug\x64`. Exit code 0 with no errors and no new warnings is a clean build.
- Test: `vstest.console Debug\x64\PartsInventoryTests.elb -- RunConfiguration.TreatNoTestsAsError=true`.
  It does not build, so build first. One test: add `/Tests:<MethodName>` before the `--`.
  Success is `Test Run Successful` with a total that includes every new test. A run where no
  test runs exits 1; that is a failure, not a pass. There is no MSBuild target for these tests.
- Run the program (not needed to check a change; the tests are the check): it needs the logicals
  `EXEDIR` and `DAT`. In PowerShell, as one command:
  `$env:EXEDIR="$PWD\Debug\x64\"; $env:DAT="$PWD\data\"; dbr Debug\x64\PartsInventory.dbr list`.
  After a fresh clone, run `load` first. If `dbr` isn't found, it's in `$env:SYNERGYDE64\dbl\bin`.

## Layout
- `PartsInventoryRepository\repository.scm`: structure `PART`, file `PARTS`. Field names and sizes
  live only here. Code gets the record with `.include "PART" repository, record="part"`.
- `PartsInventoryLib\PartsIO.dbl`: ISAM routines (create, open, close, find, first, next, update).
  No output.
- `PartsInventoryLib\PartsRules.dbl`: business rules. One `^val` function per rule, taking a PART
  record, no file access. `parts_can_issue` is the pattern to copy.
- `PartsInventory\Program.dbl`: command dispatch and all output, one internal subroutine per command
  named `do_<command>`. `do_list` is the pattern to copy for a report.
- `PartsInventoryTests\PartsRulesTests.dbl`, `PartsIOTests.dbl`: unit tests (`{TestClass}`,
  `{TestMethod}`, `Assert` from `Synergex.TestFramework`).
- `data\parts.txt`: seed data, `partno|description|qty|reorder|price`.
- `demo\`: material for the conference demo, not part of the program. Leave it alone.

## Synergy rules that trip people up
- The `.synproj` files list every source file. A new `.dbl` file builds only after you add
  `<Compile Include="..." />` to its project, so prefer adding code to the existing files.
- Identifiers are at most 30 characters. Longer ones are cut off with warning `DBL-W-BIGIDEN`;
  treat that warning as an error.
- The library's functions return `^val` (1 or 0) and are called as `%name(...)`. Test them
  with `Assert.AreEqual(1, %name(...))` or `Assert.AreEqual(0, %name(...))`.
- Alpha fields are blank-padded: `%atrim()` before concatenating. Compare text in tests with
  `Assert.AreEqual("text", %atrim(field), false)`.
- Print numbers with `%string()` masks: `X` is a digit, `Z` a zero-suppressed digit. `price` is
  d8.2 and prints with `'ZZZZZX.XX'`.
- Follow the existing code: labels in column 1, I/O errors handled with `[err=label]` and
  `[eof=label]`, no output in PartsInventoryLib.
- A run of the program may end with `%DBR-S-STPMSG, STOP` and a `%DBR-I-ATLINE` line. That's the
  runtime, not a bug; leave it alone.

## Definition of done
1. The tests for the change come first, and the user approves them before any other code changes.
2. The build is clean (no errors, no new warnings), and the test run passes with the new tests in the total.
3. A new command is in the usage text and header comment of `Program.dbl` and in the command list in `README.md`.
4. Never weaken, skip, or delete an existing test to get a green run. If a test looks wrong, stop and say so.
