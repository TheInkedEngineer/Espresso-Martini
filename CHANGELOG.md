# CHANGELOG
All notable changes to this project will be documented in this file. To know better on how to write and maintain a changelog, refer to [this link](https://keepachangelog.com/en/1.0.0/).
Releases will be named after famous illusionists.

## [1.1.0] - Harry Houdini

### Added
- Possibility to add a global delay to all requests
- Possibility to add a delay on a per-networkExchange basis (will override global delay)

## [1.0.0] - David Copperfield

### Added
- Match requests based on method + path components
- Possibility to run a mock server for the following response types:
  - empty
  - string
  - data
  - json
  - fileContent
- Support for iOS 13+
- Support for macOS 12+
