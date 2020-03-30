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

* cards, listitems, etc
  + ~~ActorCarouselCard - search/explore carousel~~
  + ~~ActorGridCard - event page~~
  + ~~ActorSuggestionTile - search suggestions~~
  + ~~ActorTile - search results~~
  + ~~EventCarouselCard - search/explore carousel~~
  + ~~EventSuggestionTile - search suggestions~~
  + ~~EventTile - search results (not animated), calendar page, actor page, place page~~
  + ~~PlaceSuggestionTile - search suggestions~~
  + ~~PlaceTile - search results~~

* actor page
  + make more like event/place pages
  + make space for like buttom (heart)
  + forgo appbar? move actions into body or dropdown
* event page
  + dont use built-in listviews (gcal)
    - what about eventers going?
  + forgo appbar? move actions into body or dropdown
  + make space for going button
  + color appbar based on image? https://github.com/flutter/packages/tree/master/packages/palette_generator
    - would be best to get the color before loading the page, but how???
* place page
  + dont use built-in listviews (gcal)
  + forgo appbar? move actions into body or dropdown
* [all pages] pull down to dismiss page
  + instead of navigator page, just a stack layer above page?

* search
  + ~~explore results: work on cards~~
  + use OpenContainer for transition between searchbar and searchdelegate?
    - this will require reimplementing searchdelegate lol
  + search suggestions
    - ~~change to leading icons~~
    - sort by edit distance?
  + results
    - ~~show number of results in tab title~~
    - save selected tab on navigator back

* calendar page
  + add animation to horizontal swipe
  + ~~jump to today/date?~~

* themeing......... 
  + color of selected/today on calendar
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
  + textstyles, custom fonts?
  + how to indicate past events on event tile? (and what about dark theme?)
  + custom statusbar + navigation bar background color
    - https://stackoverflow.com/questions/52489458/how-to-change-status-bar-color-in-flutter

* loading animations: skeleton views
  + https://www.filledstacks.com/snippet/using-shimmer-for-loading-indication-in-flutter/

* settings page?
  + theme selector
  + customize event card: what fields to show?
  + licenses
  + app locale / english translation

* launch/splash screen
  + use https://pub.dev/packages/flutter_native_splash to set static launch image
  + transition launch image into same image in flutter, then play animation implemented in flutter ("splash screen")
    - as described: https://stackoverflow.com/a/12916167
  + alternatively: https://pub.dev/packages/flare_splash_screen
  + docs
    - https://flutter.dev/docs/development/ui/assets-and-images#updating-the-launch-screen
    - https://flutter.dev/docs/development/ui/splash-screen/android-splash-screen

* pull to refresh on pagewise lists, pages
  + https://api.flutter.dev/flutter/material/RefreshIndicator-class.html
  + https://github.com/AbdulRahmanAlHamali/flutter_pagewise/issues/12
  + or maybe pull down to close single item pages

* administrative
  + error handling
  + tests
  + readme
  + license
  + ask about data use
