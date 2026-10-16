# The DevPartner 2026 demo

The project outside this folder has no instructions for a coding agent. The demo
adds them, then has the agent build a feature test-first.

| File | What it is |
|------|------------|
| `ai\CLAUDE.md` | instructions for the agent: how to build and test, where things live, the Synergy rules an agent gets wrong, and what "done" means |
| `ai\.claude\settings.json` | Claude Code settings: the agent can edit files and run `msbuild`, `vstest.console` and `nuget restore` without asking; any other command still asks |
| `prompt-reorder.txt` | the prompt: add a reorder rule, test first |

## Steps

You need Synergy/DE, Visual Studio with SDI, and Claude Code.

1. Clone the repository:

   ```
   git clone https://github.com/playlend/synergy-parts-inventory-demo
   cd synergy-parts-inventory-demo
   ```

2. Build it and run the tests, either way. Both pass 8 tests.
   - In Visual Studio: open `PartsInventory.slnx` (this also restores the NuGet
     package), build the Debug x64 configuration, and run all tests in Test Explorer.
   - From a Developer PowerShell for Visual Studio in the repository root:

     ```
     nuget restore PartsInventory.slnx
     msbuild PartsInventory.slnx -p:Configuration=Debug -p:Platform=x64 -v:minimal
     vstest.console Debug\x64\PartsInventoryTests.elb
     ```

     The restore needs nuget.exe. Without it, open the solution in Visual Studio
     once instead.

3. Make the project AI-friendly by copying the agent files to the root:

   ```
   xcopy demo\ai . /E /Y
   ```

4. Start Claude Code with `claude` from the Developer PowerShell, so it can run
   `msbuild` and `vstest.console`. When it asks whether you trust the folder, say
   yes; the settings only apply in a trusted folder.

5. Paste the contents of `prompt-reorder.txt`.

6. The agent adds three tests (below, at and above the reorder level) and stops.
   Check them, the one at the level most of all, then tell it to go ahead.

7. It adds the function, builds, and runs the tests. It should finish with 11
   tests passing. Run them yourself in Test Explorer or with `vstest.console` to
   see the same result.

To run it again, undo the agent's work with `git checkout -- .` and
`git clean -fd`, or delete the clone and start over.
