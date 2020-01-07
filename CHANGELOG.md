# springcm-sdk changelog

All notable changes to springcm-sdk will be documented in this file.

## [Unreleased]
### Added
* Document versions via #versions method. Document versions behave much like
  normal Documents, but have some different behaviors.

### Changed
* Path is expanded when retrieving individual Folders

### Removed
* `springcm` executable. Will be provided via the springcm-cli gem.

## [0.5.0] - 2020-01-03
### Added
* #patch and #put for Resources.
* #set_attribute for Attribute mixin.
* Safeguard against permanent Document deletions. DeleteRefusedError will be
  be raised on documents that are in the trash folder unless #delete! is used.

### Changed
* Moved attribute-related tests to a separate test file. May need to re-add
  to document/folder specs just for live testing.
* AttributeGroupBuilder JSON now includes IsSystem property.
* Fix property default values on DocumentBuilder
* Raise error on invalid attribute groups or fields.

### Bugfixes
* Fix issue with Resource#resource_params not being applied properly in
  request methods.
* Fix JSON returned from builders when retrieving data in lists, e.g.
  `/folders/<uid>/documents` does not include attribute groups. Tests have
  been modified to call #reload where full data is needed.

## [0.4.0] - 2019-12-27
### Added
* Faraday middleware for authorization expiration and rate limit handling.
* Faraday middleware for retrying on Faraday::ConnectionFailed. Can be
  disabled via new Client options.

### Changed
* Adjust auth window to re-authenticate no more than 5 minutes before
  access token expiration.

## [0.3.6] - 2019-12-23
### Changed
* Fix resource list behavior for history items. Was returning the document's
  $.HistoryItems.Href instead of the next page of HistoryItems

## [0.3.5] - 2019-12-23
### Added
* Document#history
* History items

## [0.3.4] - 2019-12-11
### Added
* Folder#delete
* Document#delete
* Client#document (by path or UID)
* Folder#move (by destination folder path or UID)
* Document#move (by destination folder path or UID)
* Account#attribute_groups
* Mixins::Attributes#get_attribute

### Changed
* Tweaked PageBuilder to support items that don't have a parent folder.
  Instead uses a base HREF to build next/prev/first/last HREFs. Similarly
  modified ResourceBuilder to reference a parent object instead of a parent
  folder. Outside of folders/documents, this parent object will simply be
  the Account.

## [0.3.3] - 2019-11-12
### Changed
* Fix issue with getting root folder by path

## [0.3.2]
### Changed
* Fix issue with JSON library not being required

## [0.3.1]
### Changed
* Folder#documents now properly returns a ResourceList

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

[Unreleased]: https://github.com/paulholden2/springcm-sdk/compare/0.5.0...HEAD
[0.1.0]: https://github.com/paulholden2/springcm-sdk/releases/tag/0.1.0
[0.1.1]: https://github.com/paulholden2/springcm-sdk/releases/tag/0.1.1
[0.1.2]: https://github.com/paulholden2/springcm-sdk/releases/tag/0.1.2
[0.2.0]: https://github.com/paulholden2/springcm-sdk/releases/tag/0.2.0
[0.3.0]: https://github.com/paulholden2/springcm-sdk/releases/tag/0.3.0
[0.3.1]: https://github.com/paulholden2/springcm-sdk/releases/tag/0.3.1
[0.3.2]: https://github.com/paulholden2/springcm-sdk/releases/tag/0.3.2
[0.3.3]: https://github.com/paulholden2/springcm-sdk/releases/tag/0.3.3
[0.3.4]: https://github.com/paulholden2/springcm-sdk/releases/tag/0.3.4
[0.3.5]: https://github.com/paulholden2/springcm-sdk/releases/tag/0.3.5
[0.3.6]: https://github.com/paulholden2/springcm-sdk/releases/tag/0.3.6
[0.4.0]: https://github.com/paulholden2/springcm-sdk/releases/tag/0.4.0
[0.5.0]: https://github.com/paulholden2/springcm-sdk/releases/tag/0.5.0
