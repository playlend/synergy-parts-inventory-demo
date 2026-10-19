# The DevPartner 2026 demo

The project outside this folder has no instructions for a coding agent. The demo
adds them, then has the agent build a feature test-first.

| File | What it is |
|------|------------|
| `ai\CLAUDE.md` | instructions for the agent: how to build, test and run, where things live, the Synergy rules an agent gets wrong, and what "done" means |
| `ai\.claude\settings.json` | Claude Code settings: the agent can edit files and run `msbuild`, `vstest.console`, `nuget restore` and `dbs` without asking; any other command still asks |
| `prompt-reorder.txt` | the prompt: add a reorder report, test first |

## Steps

You need Synergy/DE, Visual Studio with SDI, and Claude Code. Use a Developer
PowerShell for Visual Studio in the repository root for every command.

1. Clone the repository:

   ```
   git clone https://github.com/playlend/synergy-parts-inventory-demo
   cd synergy-parts-inventory-demo
   ```

2. Build it and run the tests, either way. Both pass 8 tests.
   - In Visual Studio: open `PartsInventory.slnx` (this also restores the NuGet
     package), build the Debug x64 configuration, and run all tests in Test Explorer.
   - On the command line:

     ```
     nuget restore PartsInventory.slnx
     msbuild PartsInventory.slnx -p:Configuration=Debug -p:Platform=x64 -v:minimal
     vstest.console Debug\x64\PartsInventoryTests.elb
     ```

     The restore needs nuget.exe. Without it, open the solution in Visual Studio
     once instead.

3. Set the two logicals the program needs, load the data, and list it:

   ```
   $env:EXEDIR = "$PWD\Debug\x64\"
   $env:DAT = "$PWD\data\"
   dbs Debug\x64\PartsInventory.dbr load
   dbs Debug\x64\PartsInventory.dbr list
   ```

   `dbs` comes with Synergy/DE. If PowerShell can't find it, add it to the path
   first: `$env:PATH += ";$env:SYNERGYDE64\dbl\bin"`.

4. Make the project AI-friendly by copying the agent files to the root:

   ```
   xcopy demo\ai . /E /Y
   ```

5. Start Claude Code with `claude` in the same PowerShell, so it has `msbuild`,
   `vstest.console`, `dbs`, `EXEDIR` and `DAT`. When it asks whether you trust the
   folder, say yes; the settings only apply in a trusted folder.

6. Paste the contents of `prompt-reorder.txt`.

7. The agent adds three tests (below, at and above the reorder level) and stops.
   Check them, the one at the level most of all, then tell it to go ahead.

8. It adds the rule and the `reorder` command, builds, runs the tests, and runs the
   report. It should finish with 11 tests passing and the parts at or below their
   reorder level. Check both yourself: run the tests in Test Explorer or with
   `vstest.console`, and run `dbs Debug\x64\PartsInventory.dbr reorder`.

To run it again, undo the agent's work with `git checkout -- .` and
`git clean -fd`, or delete the clone and start over.
