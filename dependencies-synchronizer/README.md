# Dependencies Synchronizer

This project is a command line tool designed to update the dependencies of a module in an iOS application to match those of the main application.

## Overview

The Dependencies Synchronizer tool addresses the challenge of managing module dependencies within a larger iOS application. It ensures that the module's `Podfile`, `Package.swift`, and `<ModuleName>.podspec` files are updated to reflect the dependencies used by the main application.

## Project Structure

The project consists of the following files and directories:

- `bin/dependencies-synchronizer`: The executable script for the command line tool.
- `lib/dependencies_synchronizer.rb`: Contains the main logic for reading and updating dependencies.
- `spec/dependencies_synchronizer_spec.rb`: Contains test cases for the tool using RSpec.
- `Gemfile`: Specifies the required gems for the project.
- `.ruby-version`: Specifies the Ruby version compatible with the project.
- `.gitignore`: Lists files and directories to be ignored by Git.
- `README.md`: Documentation for the project.

## Installation

1. Clone the repository:
   ```
   git clone <repository-url>
   cd dependencies-synchronizer
   ```

2. Install the required gems:
   ```
   bundle install
   ```

## Usage

To run the Dependencies Synchronizer tool, use the following command:
```
bin/dependencies-synchronizer
```

This command will read the dependencies from the main application and update the module's dependency files accordingly.

## Contributing

Contributions are welcome! Please open an issue or submit a pull request for any improvements or bug fixes.

## License

This project is licensed under the MIT License. See the LICENSE file for details.