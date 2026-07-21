# blinklink_feed

Blinklink server-driven short-form video feeds for Flutter — a thin
passthrough over the native
[Blinklink iOS SDK](https://github.com/BlinkLinkOrg/blinklink-feed-ios).
Layouts, content, and experiments update from the Blinklink marketer app
with **no app release**.

> **Platform status (0.x)**: iOS renders the full experience. Android
> renders a placeholder — the native Android renderer arrives in an
> upcoming release with no integration changes.

## Requirements

- Flutter 3.16+ · iOS 15+ — set `platform :ios, '15.0'` in `ios/Podfile`
  (the Flutter template default is lower).

## Installation

```bash
flutter pub add blinklink_feed
cd ios && pod install
```

## Quickstart

```dart
import 'package:blinklink_feed/blinklink_feed.dart';

// Once, at startup. ⚠️ environment defaults to production —
// during evaluation use development and the clientId provided by Blinklink.
await Blinklink.initialize(
  clientId: 'YOUR_CLIENT_ID',
  environment: BlinklinkEnvironment.development,
  stream: 'YOUR_STREAM',
  placement: 'YOUR_PLACEMENT',
);

// A carousel embed (bounded height in scrollables; also: FeedLayout.carousel3D):
const SizedBox(height: 320, child: BlinklinkFeedView(layout: FeedLayout.carousel, title: 'Today'))

// A grid embed:
const Expanded(child: BlinklinkFeedView(layout: FeedLayout.grid))

// A directly scrollable player surface for a whole tab:
const BlinklinkSuperFeed()
```

## Actions (CTAs)

Every component action is emitted on `Blinklink.actions`. By default the
SDK also performs its default behavior (e.g. CTAs open a fast in-app
browser). List action types in `interceptActions` to handle them yourself:

```dart
await Blinklink.initialize(
  clientId: 'YOUR_CLIENT_ID',
  environment: BlinklinkEnvironment.development,
  interceptActions: ['openURL'],
);

Blinklink.actions.listen((action) {
  if (action is BlinklinkOpenUrlAction) {
    myRouter.open(action.url);
  }
});
```

## Signed-in viewers

```dart
await Blinklink.setUser(ref: 'your-user-id'); // after sign-in
await Blinklink.clearUser();                  // on logout
```

## Share links (universal links)

After the native Associated Domains setup (see the
[iOS SDK README](https://github.com/BlinkLinkOrg/blinklink-feed-ios#share-links-universal-links)
— Blinklink must register your Team ID + bundle ID), forward links with a
package like [`app_links`](https://pub.dev/packages/app_links). Call
`initialize` before forwarding:

```dart
final appLinks = AppLinks();
appLinks.uriLinkStream.listen((uri) => Blinklink.handleUniversalLink(uri));
```

`handleUniversalLink` returns `false` for links that aren't Blinklink share
links, so your own deep-link routing keeps working.

## Example app

See [`example/`](example/) — wired to the Blinklink development environment.

## License & support

Distributed under the Blinklink SDK License (source-available) — see
[LICENSE](LICENSE). Questions or a Client ID: **support@blinklink.com**.
