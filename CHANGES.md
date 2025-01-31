# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.1] - 2025-01-31

### Changed

- Replace local unit testing module with lovecase

### Removed

- Unused `clamp()` function 

## [1.1.0] - 2023-11-23

### Added

- The `NinePatch` class can now be accessed through `quilt.NinePatch` directly
- Unit tests based on loveunit
- `NinePatch:setColor` to set the colors of all 9-patch vertices

### Changed

- Renamed library from "ninepatch" to "quilt"
- Parameters `width` and `height` for the `NinePatch:setSize` method are not optional anymore

### Fixed

- Potential issue with require path
- `NinePatch.fromOptions` expected `left` and `top` instead of `x` and  `y`

## [1.0.0] - 2023-11-03

Initial release
