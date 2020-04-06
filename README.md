# Eventersearch

Eventersearch is a proof-of-concept [Eventernote](https://www.eventernote.com/) client written in [Flutter](https://flutter.dev/), supporting Android and theoretically iOS.

Note that the authors of Eventersearch have no relation to the owners of Eventernote. Eventersearch uses undocumented APIs which may break at any time, and, due to the limited scope of said APIs, many site features are unavailable.

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

## Installation

### Android

Download the APK file from the [latest release](https://github.com/usashiki/Eventersearch/releases/latest). Alternatively, clone the repo and build the APK yourself with `flutter build apk`.

### iOS

TODO (Unfortunately, I currently do not have a suitable iOS device to test iOS on.)

## Development

To get started with Flutter, follow Flutter's [official documentation](https://flutter.dev/docs/get-started/install).

## Meta

Written by fc ([@usashiki7](https://twitter.com/usashiki7)).
