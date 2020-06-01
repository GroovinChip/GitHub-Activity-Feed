# github_activity_feed

A Flutter application for viewing a rich feed of GitHub activity.

[![Generic badge](https://badgen.net/badge/support/GitHub%20Spronsors/blue?icon=github())](https://github.com/sponsors/GroovinChip)

## Project status:
**Public Preview**: Version 0.2.6

**Supported platforms**: Android

Please note that apk's posted to [releases](https://github.com/GroovinChip/GitHub-Activity-Feed/releases) are not signed during the public preview phase.

### Implemented Features:
- View the activity for all users you follow in one place. Tapping on an activity card or a user will
open that item in the browser (or another github application installed on your device).
- Search for users
- Send direct feedback to the developer within the app

### General Roadmap:
- [ ] Follow/unfollow users (being tracked by [#52](https://github.com/GroovinChip/GitHub-Activity-Feed/issues/52))
- [X] [ThemeMode switcher](https://github.com/GroovinChip/GitHub-Activity-Feed/issues/8)
- [ ] [Discovery service](https://github.com/GroovinChip/GitHub-Activity-Feed/issues/56)
- [ ] Paginated activity feed ([#57](https://github.com/GroovinChip/GitHub-Activity-Feed/issues/57) , [#58](https://github.com/GroovinChip/GitHub-Activity-Feed/issues/58))
- [ ] [Filter activity feed](https://github.com/GroovinChip/GitHub-Activity-Feed/issues/51)
- [ ] [Actionable markdown](https://github.com/GroovinChip/GitHub-Activity-Feed/issues/48)
- [X] [Show gists created by a user in the activity feed](https://github.com/GroovinChip/GitHub-Activity-Feed/issues/38)
- [ ] [Pull to refresh for all feeds](https://github.com/GroovinChip/GitHub-Activity-Feed/issues/21)

For a complete list, please see [this project board](https://github.com/GroovinChip/GitHub-Activity-Feed/projects/3)

### Contributing:
- This project uses the GitHub api. It uses the [v3 REST api](https://developer.github.com/v3/) for authentication through the [github package on pub](https://pub.dev/packages/github)
and the [v4 graphql api](https://developer.github.com/v4/) for everything else. Consequently, you will need to do the following to use the API:
    1. Create an OAuth app in the developer settings of your GitHub account
    2. Create a `keys.dart` file in `/lib` with the following variables:
```dart
const clientId = 'yourClientId';
const clientSecret = 'yourClientSecret';
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
