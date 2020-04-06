# Eventersearch

Eventersearch is a proof-of-concept [Eventernote](https://www.eventernote.com/) client written using [Flutter](https://flutter.dev/), supporting Android and theoretically iOS.

Note that the authors of Eventersearch have no relation to the owners of Eventernote. Eventersearch uses [undocumented APIs](https://www.eventernote.com/javascripts/eventernote.js) which may break at any time, and, due to the limited scope of said APIs, many site features are unavailable.

## Features / Screenshots

### Searching

| Explore (Dark mode) | Suggestions (Light mode) | Results |
| --- | --- | --- |
| <img src="images/dark/explore.png" width="300px" /> | <img src="images/light/suggestions.png" width="300px" /> | <img src="images/dark/results.png" width="300px" /> |

As the name suggests, Eventersearch's primary feature is to search Eventernote.

### Calendar view

| Calendar (week) | Calendar (month) | Choose date |
| --- | --- | --- |
| <img src="images/light/week.png" width="300px" /> | <img src="images/dark/month.png" width="300px" /> | <img src="images/light/date.png" width="300px" /> |

Eventersearch also supports a calendar view, [similar to Eventernote](https://www.eventernote.com/events/calendar).

### Favorites

| Favorite seiyuu/artists | Favorite artists' events | Favorite events |
| --- | --- | --- |
| <img src="images/dark/fav_artists.png" width="300px" /> | <img src="images/light/fav_artist_events.png" width="300px" /> | <img src="images/dark/fav_events.png" width="300px" /> |

As a proof of concept you can mark favorite artists and events, but due to lack of a login API, there is no way to connect your Eventernote account to the app. Additionally, all favorites are cleared on app close (read: I got a bit lazy).

### Details pages

| Seiyuu/artist | Event | Venue |
| --- | --- | --- |
| <img src="images/light/artist.png" width="300px" /> | <img src="images/dark/event.png" width="300px" /> | <img src="images/light/venue.png" width="300px" /> |

Eventersearch can also display most artist, event, and venue information available on Eventernote (not including user information, eg event attendees).

(Both light and dark themes of each of the above screenshots can be found in [`images/`](images/) long with a recording of the UI.)

## Installation

### Android

Download the APK file from the [latest release](https://github.com/usashiki/Eventersearch/releases/latest). Alternatively, clone the repo and build the APK yourself with `flutter build apk`.

### iOS

TODO (Unfortunately, I currently do not have a suitable iOS device to test iOS on.)

## Development

Eventersearch is written in Dart using Flutter. To install Dart/Flutter, follow Flutter's [official documentation](https://flutter.dev/docs/get-started/install).

At time of writing Eventersearch is built using Flutter 1.15.17, the latest beta channel version, so after installation you will need to run

```
flutter channel beta
flutter upgrade
```

See the [Flutter Wiki](https://github.com/flutter/flutter/wiki/Flutter-build-release-channels) for more info on Flutter's release channels.

Once you've done that, clone the repo then run

```
flutter pub get
```

to download the necessary dependencies. (Alternatively just open your preferred IDE, with the proper Flutter extensions it should be able to do that for you.)

### Code layout

The Flutter app code lives in `lib/`. Within `lib/` there is:
* `models/` containing JSON serializable classes and corresponding generated code using [json_serializable](https://pub.dev/packages/json_serializable) based on Eventernote's API,
* `pages/` containing full pages (complete `Scaffold`s),
* `services/` containing API-interfacing code and state code,
* `widgets/` containing all the custom widgets,
* and `main.dart`.

There are no tests.

## Meta

Written by fc ([@usashiki7](https://twitter.com/usashiki7)).
