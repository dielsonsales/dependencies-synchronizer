# Dependencies Synchronizer

A command-line tool to sync your iOS module’s dependencies (`Podfile`, `Package.swift`, and `<ModuleName>.podspec`) with those of the main application.

## Overview

The Dependencies Synchronizer addresses the challenge of maintaining consistent dependencies across iOS modules that are not standalone projects. It ensures your module always matches the main app’s dependency versions, keeping your CI and local builds in sync.

## Project Structure

- `Gemfile`: Specifies the required gems for development and testing.
- `Makefile`: Defines common tasks (`run`, `test`, `build`, etc.).
- `README.md`: Project documentation.
- `CHANGELOG.md`: Version history and notable changes.
- `bin/dependencies-synchronizer`: The executable CLI script.
- `lib/dependencies_synchronizer/`: Core logic, CLI interface, and updaters.
- `spec/`: RSpec test suite.
- `mock_main_app/Core.rb`: Example used to simulate main app dependencies.

## Installation

You can either install dependencies locally for development, or build and install the gem system-wide.

### Option 1: Local Development Setup

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd dependencies-synchronizer
   ```

2. Install dependencies:
   ```bash
   bundle install --path vendor/bundle
   ```

3. Run via:
   ```bash
   bundle exec ruby bin/dependencies-synchronizer
   ```

### Option 1: Local Development Setup

1. Build the gem:
   ```bash
   make build
   ```

2. Install the gem:
   ```bash
   gem install --local ./dependencies_synchronizer-0.1.2.gem
   ```

3. Now you can run the tool globally:
   ```bash
   dependencies-synchronizer
   ```

## Usage

Run the tool from your module’s root directory:
```bash
dependencies-synchronizer
```

You’ll be prompted to provide the path to the main app on first use, which will be saved to `~/.dependencies_sync.yml`.

Or run with explicit path:

```bash
dependencies-synchronizer --dir /path/to/main/app
```

This command will read the dependencies from the main application (by scanning `Core.rb`) and update the module's `Podfile`, `Package.swift`, and `.podspec` files accordingly.

## Contributing

Pull requests and issues are welcome! If you find a bug or have a feature request, feel free to open a discussion or PR.

## License

This project is licensed under the MIT License. See the [LICENSE](https://github.com/dielsonsales/dependencies-synchronizer/blob/main/LICENSE) file for details.
