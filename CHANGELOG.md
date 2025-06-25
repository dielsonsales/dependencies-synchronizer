# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),  
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [0.1.2] - 2025-06-25
### Added
- Initial working CLI tool to sync module dependencies with the main iOS app.
- Support for parsing `Core.rb` to extract dependency names and versions.
- Automatic updates for:
  - `Podfile` (exact versions),
  - `Package.swift` (exact versions),
  - `<ModuleName>.podspec` (pessimistic `~>` versioning).
