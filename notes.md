# eventernote app

## sections

### seiyuu/artists

#### individual

* favorite
* events
  + add new event
* registrant
* edit info
* fans
* user ranking

#### search

* keyword
* popular
* newest
* by abc

### events

#### individual

* date
* time: opening, start, end (estimated)
* location
* performers
* link(s)
* description
* image
* hashtag
* last edited by
* view edit history
* edit info
* duplicate event
* share to social media
* reviews
* attendees
* unregistered
  + add note
* registered
  + write review
  + tweet attendance
  + edit note
    - total cost
    - itemized cost
    - memo (private)
    - review (public)
  + delete note

#### search

* keyword
* date
  + calendar
* prefecture
* today's events
* new events
* events from your artists
* past events
* new event
* recent reviews
* events by month

### venues

#### individual

* address
* phone
* website
* capacity
* seating chart link
* tips
* registrant
* events
* check on map

#### search

* keyword
* by prefecture

### user

#### self

* upcoming events
* events from your artists
* following/followers/events
* badges
* money spent
* favorite artists
* (oshirase) notifs from favorite artists
* (dashboard) notifs from following
* settings
  + change email/pw
  + edit profile
  + manage following/followers
  + manage favorite artists
  + account integrations
  + calendar integrations
  + enter serial code
  + delete account
* logout

#### other

* upcoming events
* overlapping events
* follow/followers/events/overlap
* follow/unfollow
* favorite artists
* event calendar

## potential layouts

* nav drawer
  + header: account
  + profile: following/followers/events, upcoming events
  + oshirase
  + dashboard
  + settings
* bottom nav
  + events
  + artists
  + venues
  + self
* backdrop
* tabs

## scraping

* https://github.com/Skk-nsmt/eventernote-api
* https://github.com/KTachibanaM/eventernote-api
* https://github.com/stfate/EventernoteCrawler

## REDESIGN: focus on existing apis

goodbye tabs

* bottom nav with 3 screens
  + calendar: basically https://www.eventernote.com/events/calendar
  + artist ranking: basically done
  + venue map: map of all venues across jp? thats a lot of venues... 
    - workaround: have a prefecture dropdown above map, only load venues from that prefecture
    - either way, aggressively cache results (venues dont change often)
* shared appbar with quicksearch
* single item pages
  + event page: event details
  + artist page: w/ list of events
  + venue page: w/ list of events

## redesign (3)

* bottom nav pages (_requires new api_, ~~done~~)
  + ~~calendar~~
  + search
    - explore
      - _chuumoku events_
      - _chuumoku artists_
      - _new events_
      - (today's events)
      - top artists
      - new artists
    - suggestions: vertical results
    - results: each object search, separated
  + _notifs/home_: separate tabs? combined?
    - _my artists_ (あなたへのお知らせ/notice)
    - _following_ (友達の活動/dashboard/timeline)
  + _likes_
    - _my artists_
    - _my artists' events_
  + _profile (actions: settings)_
    - _my events (past/future)_
    - _following/followers_

### todos

#### v0

* calendar
  + today = black/dark grey circle border
  + selected = gray transparency? circle
  + both = both

* place page: for events in event list, hide venue?
* [event, place pages] inkwell in expanded SliverAppBar

* about/settings page
  + licenses
  + cache duration

* administrative
  + app name
  + error handling
  + general code organization/naming
  + tests
  + readme
  + license
  + ask about data use

* calendar page
  + add animation to horizontal swipe

#### v1+

* support for web
  + remove packages that depend on sqflite
    - flutter_map -> map https://pub.dev/packages/map
      * doesn't support pins but you can just stack a pin on top? lmao
    - flutter_cache_manager -> just remove entirely?
    - cached_network_image -> Image.network https://api.flutter.dev/flutter/widgets/Image-class.html

* custom statusbar + navigation bar background color
  + generally make sure works with various hole punches etc
  + https://stackoverflow.com/questions/52489458/how-to-change-status-bar-color-in-flutter

* actor carousel card: add color
  + random from logo?
  + dark theme -> just use default dark canvas color?

* theme selector
  + custom themes based on colors in logo?
    - https://pub.dev/packages/flutter_material_color_picker
    - (site or twitter)
    - #F6C8DD or #FFBCFF
    - #E74E95 or #F367DA
    - #7DCCF3 or #7EE2FF
    - #30B49F or #00C9A9
    - #A586BC or #B189FF
    - #E7372F or #EC5163
    - #F2984F or #FFA457
    - #3CA0CD or #679FF2
    - #FFE100 or #F2DD42
    - #ED86B3 or #F49ED0
    - #6CBA5A or #59F35E

* how to indicate past events on event tile? (and what about dark theme?)

* launch/splash screen
  + use https://pub.dev/packages/flutter_native_splash to set static launch image
  + transition launch image into same image in flutter, then play animation implemented in flutter ("splash screen")
    - as described: https://stackoverflow.com/a/12916167
  + alternatively: https://pub.dev/packages/flare_splash_screen
  + docs
    - https://flutter.dev/docs/development/ui/assets-and-images#updating-the-launch-screen
    - https://flutter.dev/docs/development/ui/splash-screen/android-splash-screen

* loading animations: skeleton views
  + https://www.filledstacks.com/snippet/using-shimmer-for-loading-indication-in-flutter/

* allow users to select which fields to show in event card

#### wont do / currently not possible

* icons: stick with outlines
  + venue icon vs address icon (currently pin vs map)
  + event icon (currently music note)

* search
  + search suggestions: sort by edit distance?
    - having api support would be better
  + reimplement search page (searchdelegate)
    - use OpenContainer for transition between searchbar and search page
    - results: save selected tab on navigator back

* allow for opening arbitrary eventernote links in app
  + rearchitect json handling to handle pages based on url
    - https://www.eventernote.com/api/events/search?event_id=id
    - ^ doesn't work for actors or places...
  + named routes: https://medium.com/flutter/flutter-web-navigating-urls-using-named-routes-307e1b1e2050

* textstyles, custom fonts?
  + http://blog.gskinner.com/archives/2020/03/flutter-tame-those-textstyles.html

* enable pull to refresh on pagewise lists, pages
  + https://api.flutter.dev/flutter/material/RefreshIndicator-class.html
  + https://github.com/AbdulRahmanAlHamali/flutter_pagewise/issues/12

* app locale / english translation
