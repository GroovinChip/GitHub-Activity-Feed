# github_activity_feed

A Flutter application for viewing a rich feed of GitHub activity.

[![Generic badge](<https://badgen.net/badge/support/GitHub%20Spronsors/blue?icon=github()>)](https://github.com/sponsors/GroovinChip)

## Project status:

**Public Preview**: Version 0.6.1

**Supported platforms**: Android, iOS (see notes)

Please note that apk's posted to [releases](https://github.com/GroovinChip/GitHub-Activity-Feed/releases) are not signed during the public preview phase.

Please note that in order to use this application on iOS you will need to build it yourself. I do not yet have an Apple Developer Account and so I cannot put the app on Testflight.

## Implemented Features:

- View activity for all users you follow in one place. Tapping on the repository preview section of an activity card or a user will
  open that repository or user page in the browser (or another GitHub application installed on your device).
- Search for users
- Send direct feedback to the developer within the app

## Initial Release Roadmap:

See the [initial release](https://github.com/GroovinChip/GitHub-Activity-Feed/projects/3) project board

## Contributing:

- This project uses the GitHub api. It uses the [v3 REST api](https://developer.github.com/v3/) for authentication through my fork of the [github package on pub](https://pub.dev/packages/github)
  and the [v4 graphql api](https://developer.github.com/v4/) for everything else. Consequently, you will need to do the following to use the API: 1. Create an OAuth app in the developer settings of your GitHub account 2. Create a `keys.dart` file in `/lib` with the following variables:
  ```dart
  const clientId = 'yourClientId';
  const clientSecret = 'yourClientSecret';
  ```
      3. Depend on the `github` package from git via `https://github.com/GroovinChip/github.dart` like so:
  ```yaml
  github:
    git:
      url: git@github.com:GroovinChip/github.dart.git
  ```
- This application uses [wiredash.io](https://wiredash.io) for user feedback. As such you will need to create an application there and add your keys to `keys.dart` like so:
  ```dart
  const wiredashProjectId = 'yourWiredashProjectId';
  const wiredashSecret = 'yourWiredashSecret';
  ```
- This project uses Firebase to handle authentication redirect so you will need to [create a Firebase
  project](https://console.firebase.google.com), follow the instructions to configure Android and iOS projects,
  and download their respective google-services files.
- File an issue or comment on an existing issue to report what you will be working to fix or add
- When you are ready, open a pull request and request review from me, GroovinChip.
