# springcm-sdk changelog

All notable changes to springcm-sdk will be documented in this file.

## [Unreleased]

## [0.3.0]
### Added
* ResourceList class, for managing paged lists of e.g. Folders and Documents

### Changed
* Folder#folders and Folder#documents now return a ResourceList

## [0.2.0]
### Changed
* Restructure code to match gem name

## [0.1.2]
### Added
* Account info retrieval
* CLI tool (not yet functional)
* Folder#folders method
* Document API
* Ability to test against live SpringCM, with provided credentials

### Changed
* Client no longer accepts credentials with keyword arguments
* Improvements to Folder object

## [0.1.1] - 2019-07-17
### Added
* `Client#connect!` method
* Documentation generation
* Test coverage

### Changed
* Fix issues with gemspec file

## [0.1.0] - 2019-07-16
### Added
* Initial release to reserve gem name

[Unreleased]: https://github.com/paulholden2/springcm-sdk/compare/0.1.1...HEAD
[0.1.0]: https://github.com/paulholden2/springcm-sdk/releases/tag/0.1.0
[0.1.1]: https://github.com/paulholden2/springcm-sdk/releases/tag/0.1.1
[0.1.2]: https://github.com/paulholden2/springcm-sdk/releases/tag/0.1.2
[0.2.0]: https://github.com/paulholden2/springcm-sdk/releases/tag/0.2.0
[0.3.0]: https://github.com/paulholden2/springcm-sdk/releases/tag/0.3.0
