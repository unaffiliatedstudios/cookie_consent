# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.2] - 2025-11-19
### Fixed
- Fixed banner staying on page by hiding banner by default and showing only when needed
- Corrected CSS selector from `.cookie-consent-banner .cookie-consent-visible` to `.cookie-consent-visible .cookie-consent-banner`
- Improved asset pipeline integration for consuming Phoenix applications

### Added
- `CookieConsent.RouterIntegration` module for easy router pipeline integration
- `CookieConsent.PlugSessionMirror` plug to mirror cookie consent data from cookies to session
- Server-side consent state access for LiveView components and controllers
- Enhanced documentation for server-side integration patterns

### Changed
- Updated JavaScript hook to use `cookie-consent-visible` class pattern for better control
- Improved CSS organization and banner visibility logic
- Enhanced integration examples in documentation

## [1.0.1] - 2025-11-07

### Fixed
- Toggle switches in preferences modal now properly save individual cookie preferences
- Modal no longer closes when clicking inside the preferences dialog
- Removed debug console.log statements from production JavaScript code

### Changed
- Added `toggle_preference` event handler for granular preference control
- Added `analytics_enabled` and `marketing_enabled` to component state tracking
- Improved event handling with `phx-click="noop"` pattern to prevent unwanted event bubbling

### Added
- `.tool-versions` to gitignore

## [1.0.0] - 2025-11-07

### Added
- Initial release of Cookie Consent component for Phoenix LiveView
- GDPR/CCPA compliant cookie consent banner with opt-in by default
- Customizable preferences modal for granular cookie control
- Google Analytics integration with consent-based loading
- Meta Pixel integration with consent-based loading
- 50+ CSS variables for complete visual customization
- Light and dark theme support
- Accessible design with proper ARIA labels and keyboard navigation
- Responsive mobile-friendly layout
- Zero external dependencies (no Tailwind or other CSS frameworks required)
- Phoenix LiveView hook for consent management
- sessionStorage-based consent persistence
- Auto z-index fixes for Phoenix LiveView topbar compatibility

[Unreleased]: https://github.com/unaffiliatedstudios/cookie_consent/compare/v1.0.1...HEAD
[1.0.2]: https://github.com/unaffiliatedstudios/cookie_consent/compare/v1.0.1...v1.0.2
[1.0.1]: https://github.com/unaffiliatedstudios/cookie_consent/compare/v1.0.0...v1.0.1
[1.0.0]: https://github.com/unaffiliatedstudios/cookie_consent/releases/tag/v1.0.0