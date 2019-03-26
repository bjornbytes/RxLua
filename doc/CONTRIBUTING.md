Contributing
===

Organization
---

Source is contained in the `src` directory.  There is roughly one Lua file for each class, though the operators are stored in their own files in the `src/operators` directory.

Tooling
---

There are a number of scripts in the `tools` folder that automate certain tasks.  In general, they are run using `lua tools/<file>.lua` from the project root and take no arguments.

- Everything in the `src` directory is concatenated into a single `rx.lua` file in the project root.  The file `tools/build.lua` does this concatenation.  It strips out both the requires at the top of files and the return values at the bottom.
  - If you want to create a luvit build with additional features, you can run `lua tools/build.lua luvit`.
- The documentation in `doc/README.md` is automatically generated based on comments in the source.  The file `tools/update_documentation.lua` performs this generation.  Internally it uses `docroc`, which is a library that parses Lua comments and returns them in a table.  From here, `update_documentation` converts the table to markdown and writes it to the `doc` directory.
- Currently, you should run both of these scripts and include an updated `rx.lua` and `doc/README.md` as part of a pull request.  If you've added a new file you'll have to add it (alphabetized) to the file list in `tools/build.lua`.

Tests
---

- Tests are recommended when adding new functionality.  The reason is that they demonstrate correct behavior, provide a form of documentation, and protect against future bugs.
- RxLua uses [lust](https://github.com/bjornbytes/lust) for testing.
- To run the tests, run `lua tests/runner.lua` from the project root.
- To run a specific test file, run `lua tests/runner.lua average` to just run the tests in `tests/average.lua`.
- In addition to lust's default operators, there are also a few additional utilities available via `runner.lua`:
  - `expect(Observable).to.produce(...)` will assert that the Observable produces the specified values, in order.  If you need to assert against multiple values emitted by a single `onNext`, you can pass in a table (i.e. `{{1, 2, 3}, {4, 5, 6}}` to check that an Observable calls `onNext` twice with 3 values each).
  - `expect(Observable).to.produce.error()` will assert that the Observable produces an error.
  - There is also `expect(Observable).to.produce.nothing()`.
  - `local onNext, onError, onCompleted = observableSpy(observable)` will create three spies for each of the three events.  You can read more about spies on lust's README.

Style
---

Aim for a consistent style.

- Wrap lines to 100 characters.
- Indent using two spaces.
- Document functions using `docroc` syntax so documentation gets automatically generated.  In general this means starting your first comment with three dashes, then using `@arg` and `@returns`.
- Tend to avoid single line `if`s (i.e. `if condition then action end`).
- Files should end in a single trailing newline with no extra blank lines.  This ensures that the base `rx.lua` file gets concatenated correctly.
