# Project Overview

This project is a **Ruby command-line tool** designed to synchronize a module’s
dependency files with those of its parent iOS application.

## Context

- The module is **not a standalone project** — it lives inside a larger iOS application.
- Its dependencies are managed by the **main app**, but the module includes its own:
  - `Podfile` — used in CI to install dependencies locally.
  - `Package.swift` — used to open the module independently in Xcode.
  - `<ModuleName>.podspec` — for publishing or linking as a pod.

All three files must stay in sync with the main app’s dependencies.

## Constraints

- The CLI tool will be run on **macOS machines** using the **system Ruby**.
- **No new software can be installed**, but Ruby gems can be.
- The tool must run using only what is available by default + Ruby gems.

## Purpose

Create a **CLI tool** that:
- Runs from the module’s root directory.
- Asks once for the path to the main application and stores it in `$HOME/.dependencies_sync.yml`.
- Reads the main app's dependency definitions.
- Updates the module’s `Podfile`, `Package.swift`, and `<ModuleName>.podspec` to reflect the same dependencies.

## File Handling Summary

- `Podfile`: Must match the main app’s versions **exactly**. Used in CI.
- `Package.swift`: Must reflect exact versions, so the module opens in Xcode with correct dependencies.
- `<ModuleName>.podspec`: Cannot pin exact versions — must use fuzzy constraints like `'~> 1.0'`.

## Development Guidelines for the Assistant

- Always act like a **professional software engineer**.
- Write **clean, modular, and idiomatic Ruby**, as detailed below.
- Use good naming conventions, clear structure, and helpful comments.
- When generating code, **output the full file**, not a diff.
- Correct me if I propose something that goes against best Ruby practices.
- Prefer readability over cleverness. This is a maintainable internal tool.


# Ruby CLI Tool Conventions

## Ruby Instructions

- Use clear, descriptive method names and organize logic into small, testable methods.
- Keep CLI entrypoints (`bin/`) minimal — delegate to classes/modules in `lib/`.
- Accept input via arguments, environment variables, or standard input — document this clearly.
- Exit with appropriate status codes (`0` for success, `1+` for errors).
- For CLI argument parsing, use built-in `OptionParser`, `Thor`, or `Slop` for clarity.

## General Instructions

- Favor explicitness over cleverness in user-facing code.
- Log or print user-facing messages only from CLI layer — avoid putting `puts` in core logic.
- Handle common user errors gracefully (e.g., missing files, invalid flags).
- Use `begin...rescue` to provide meaningful feedback and avoid raw stack traces.
- When relying on third-party tools or environment setup, validate and fail fast with clear messages.

## Code Style and Structure

- Follow the [Ruby Style Guide](https://rubystyle.guide).
- Use 2-space indentation.
- Keep lines under 100 characters when possible.
- Organize your code using `lib/your_tool_name/` structure.
- Document public classes and methods with YARD comments (`@param`, `@return`).
- Use `attr_reader` for immutable config or dependencies passed into classes.

## Logging and Output

- Use `warn` for errors (writes to `stderr`) and `puts` for regular output (`stdout`).
- Consider a `Logger` instance for verbose or debug modes.
- Always include a `--help` option with clear usage examples.

## Edge Cases and Testing

- Use **RSpec** or **Minitest** for both unit and integration tests.
- For CLI behavior, use `aruba`, `open3`, or `thor` specs to simulate command-line execution.
- Cover invalid input, missing files, bad flags, and permission errors.
- Use `tmpdir` for safe filesystem-related tests.

## Example of Proper Documentation

```ruby
# Calculates the area of a circle given the radius.
#
# @param radius [Float] the radius of the circle
# @return [Float] the area of the circle
def calculate_area(radius)
  Math::PI * radius**2
end
```

## Optional Typing with Sorbet (if applicable)

```ruby
# typed: true
extend T::Sig

sig { params(radius: Float).returns(Float) }
def calculate_area(radius)
  Math::PI * radius**2
end
```
