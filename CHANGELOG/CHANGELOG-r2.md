# Changelog ApplicationEndpointRegistration

<!-- TOC:START -->
## Table of Contents
- [r2.2](#r22)
- [r2.1](#r21)
<!-- TOC:END -->

**Please be aware that the project will have frequent updates to the main branch. There are no compatibility guarantees associated with code in any branch, including main, until it has been released. For example, changes may be reverted before a release is published. For the best results, use the latest published release.**

The below sections record the changes for each API version in each release as follows:

* for an alpha release, the delta with respect to the previous release
* for the first release-candidate, all changes since the last public release
* for subsequent release-candidate(s), only the delta to the previous release-candidate
* for a public release, the consolidated changes since the previous public release

# r2.2

## Release Notes

This release candidate contains the definition and documentation of
* application-endpoint-registration 0.2.0-rc.2

The API definition(s) are based on
* Commonalities r4.4 (0.9.0)
* Identity and Consent Management r4.2 (0.5.0)

## application-endpoint-registration 0.2.0-rc.2

**application-endpoint-registration 0.2.0-rc.2 is a release-candidate version of this API.**

Changes documented below are compared to version 0.2.0-rc.1.

- API definition **with inline documentation**:
  - [View it on ReDoc](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/camaraproject/ApplicationEndpointRegistration/r2.2/code/API_definitions/application-endpoint-registration.yaml&nocors)
  - [View it on Swagger Editor](https://camaraproject.github.io/swagger-ui/?url=https://raw.githubusercontent.com/camaraproject/ApplicationEndpointRegistration/r2.2/code/API_definitions/application-endpoint-registration.yaml)
  - OpenAPI [YAML spec file](https://github.com/camaraproject/ApplicationEndpointRegistration/blob/r2.2/code/API_definitions/application-endpoint-registration.yaml)

### Breaking changes

* N/A

### Added

* Added Errors section to the API description, documenting when each error response is returned by @maheshc01 in https://github.com/camaraproject/ApplicationEndpointRegistration/pull/55
* Added test scenarios covering all operations and documented error codes by @maheshc01 in https://github.com/camaraproject/ApplicationEndpointRegistration/pull/55

### Changed

* Synced with CAMARA Commonalities r4.4 / 0.9.0: error responses aligned with the r4.4 response catalogue, `info.description` mandatory sections updated by @maheshc01 in https://github.com/camaraproject/ApplicationEndpointRegistration/pull/55
* Expanded the Introduction to explain how registered endpoints are used with the Application Endpoint Discovery API by @maheshc01 in https://github.com/camaraproject/ApplicationEndpointRegistration/pull/55
* `port` and `ipv6Address` now reference the common `Port` and `SingleIpv6Address` schemas by @maheshc01 in https://github.com/camaraproject/ApplicationEndpointRegistration/pull/55

### Fixed

* Removed the "Further info and support" section, which referenced the GSMA Mobile Connect Account Takeover Protection specification and did not apply to this API by @maheshc01 in https://github.com/camaraproject/ApplicationEndpointRegistration/pull/55
* Corrected `externalDocs` description and the `getApplicationEndpointsById` operation name in the API description by @maheshc01 in https://github.com/camaraproject/ApplicationEndpointRegistration/pull/55

### Removed

* Removed `400 OUT_OF_RANGE`, `403 INVALID_TOKEN_CONTEXT` and `404 IDENTIFIER_NOT_FOUND` error codes, which are not applicable to this API by @maheshc01 in https://github.com/camaraproject/ApplicationEndpointRegistration/pull/55

**Full Changelog**: https://github.com/camaraproject/ApplicationEndpointRegistration/compare/r2.1...r2.2

# r2.1

## Release Notes

This release candidate contains the definition and documentation of
* application-endpoint-registration 0.2.0-rc.1

The API definition(s) are based on
* Commonalities r4.3 (0.8.0)
* Identity and Consent Management r4.2 (0.5.0)

## application-endpoint-registration 0.2.0-rc.1

**application-endpoint-registration 0.2.0-rc.1 is a release-candidate version of this API.**

Changes documented below are compared to version 0.1.0.

- API definition **with inline documentation**:
  - [View it on ReDoc](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/camaraproject/ApplicationEndpointRegistration/r2.1/code/API_definitions/application-endpoint-registration.yaml&nocors)
  - [View it on Swagger Editor](https://camaraproject.github.io/swagger-ui/?url=https://raw.githubusercontent.com/camaraproject/ApplicationEndpointRegistration/r2.1/code/API_definitions/application-endpoint-registration.yaml)
  - OpenAPI [YAML spec file](https://github.com/camaraproject/ApplicationEndpointRegistration/blob/r2.1/code/API_definitions/application-endpoint-registration.yaml)

### Breaking changes

* N/A

### Added

* N/A

### Changed

* N/A

### Fixed

* fix: align API with CAMARA Commonalities r4.3 validation requirements by @maheshc01 in https://github.com/camaraproject/ApplicationEndpointRegistration/pull/40
* fix: correct schema references in test feature file by @maheshc01 in https://github.com/camaraproject/ApplicationEndpointRegistration/pull/42
* fix: remove inapplicable error response codes per Commonalities r4.3 by @maheshc01 in https://github.com/camaraproject/ApplicationEndpointRegistration/pull/49

### Removed

* N/A

**Full Changelog**: https://github.com/camaraproject/ApplicationEndpointRegistration/compare/r1.2...r2.1

