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

### todos

* improve item pages
  + ~~open in website links~~
  + eventpage, venuepage: dont use built-in listviews
  + eventpage, venuepage: move links to body?
  + eventpage: show people going more prominently?
  + pull down to dismiss page
  + eventpage: color appbar based on image? https://github.com/flutter/packages/tree/master/packages/palette_generator
    - would be best to get the color before loading the page, but how???

* map
  + https://pub.dev/packages/flutter_map, https://pub.dev/packages/latlong
  + per prefecture: https://www.eventernote.com/api/places/search?prefecture=13
  + popup per location
    - https://github.com/johnpryan/flutter_map/issues/184
    - https://github.com/johnpryan/flutter_map/issues/354
  + clustering per pref: https://pub.dev/packages/flutter_map_marker_cluster
  + user location? https://pub.dev/packages/user_location
  + or maybe something else entirely

* settings page?
  + theme selector
  + customize event card: what fields to show?
  + licenses

* themeing......... 
  + dark theme??
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

* pull to refresh on pagewise lists, pages
  + https://api.flutter.dev/flutter/material/RefreshIndicator-class.html
  + https://github.com/AbdulRahmanAlHamali/flutter_pagewise/issues/12
  + or maybe pull down to close single item pages

* search (neither of these things are possible??? lmao)
  + replace title appbar with a persistent search bar
    - https://github.com/flutter/flutter/issues/17119 lol
  + dont refresh on submit <- this doesnt seem possible with SearchDelegate

* tests lel
* ask about data use

お返事お待ちしております。

## app layout (3)

* bottom nav pages (_requires new api_, ~~done~~)
  + artist: (actions: quicksearch)
    - ~~ranking~~
    - _chuumoku_
    - new: https://www.eventernote.com/api/actors/search?sort=created_at
  + ~~calendar: (actions: quicksearch)~~
  + search (no quicksearch action?)
    - events: keyword, date, area/prefecture
    - actors: keyword, kana
    - places: keyword, prefecture (also do area?)
  + _notifs (actions: quicksearch)_
    - _my artists_
    - _following_
  + _profile (actions: settings)_
    - _past events_
    - _my artists' events_
