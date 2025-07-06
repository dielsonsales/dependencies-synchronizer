# Dependencies Synchronizer

This project is supposed to be a command line tool to update the dependencies
of a module in an iOS application to match the dependencies of the main
application.

**The problem:** the module is not a standalone project, it is part of a larger
iOS application, and the module's dependencies are managed by the main
application. The module has files such as `Podfile`, `Package.swift` and a
`<ModuleName>.podspec` that need to be updated constantly when the main app does
it.

It will use the macOS native Ruby installation to run the code, since the
machines that will run it have strict security policies and do not allow
installing new software without admin rights, although Ruby gems can be
installed.

**How the files are structured:**
- `Podfile`: the Podfile of the module, which needs to be updated to match the
  dependencies of the main application. The Podfile is used by the pipeline
  to install the dependencies of the module, and it can specify exact versions
  of dependencies.
- `Package.swift`: the Swift Package Manager manifest file for the module,
  which also needs to be updated to match the dependencies of the main
  application. It can specify exact versions of dependencies, since it is used
  to open the module in Xcode.
- `<ModuleName>.podspec`: the podspec file for the module, which also needs
  to be updated to match the dependencies of the main application. However,
  it cannot force a specific version of a dependency, hence why it has
  dependencies in a format like `s.dependency 'DependencyName', '~> 1.0'`.

**The goal:** to create a command line tool that can be run from the module's
main directory, which will read the dependencies from the main application
and update the `Podfile`, `Package.swift` and `<ModuleName>.podspec` files
to match the dependencies of the main application.

**The stack:** the tool will be a single command written in Ruby and supporting
the version that comes bundled on macOS. It will ask for the path to the main
application and keep it in the $HOME/.dependencies_sync.yml to read the correct
dependencies. It will then override the dependencies in the module's files to
match the dependencies of the main application.

Always act like a professional software engineer, and write code that is
well-structured, maintainable, and follows best practices. Use appropriate
naming conventions, comments, and documentation. Ensure that the code is
modular and reusable, and that it adheres to good Ruby standards.

Also, since I'm not a Ruby expert, please don't feel shy about correcting me
in case I give instructions that shouldn't be carried out that way.

Also, don't show me diffs, but the final result, since I will be able to see
the diff anyway from my personal version control system.
