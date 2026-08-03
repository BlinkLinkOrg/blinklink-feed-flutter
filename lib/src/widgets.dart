import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Layout of a referrer feed embed.
enum FeedLayout { carousel, carousel3D, grid }

bool get _isIOS => !kIsWeb && Platform.isIOS;

/// An embeddable referrer feed (carousel / 3D carousel / grid). Give it an
/// explicit height (e.g. `SizedBox(height: 320)`) when used in a scroll
/// view or `Column`.
class BlinklinkFeedView extends StatelessWidget {
  const BlinklinkFeedView({
    super.key,
    this.stream = 'videos',
    this.placement = 'videos-tab',
    this.layout = FeedLayout.carousel,
    this.title,
  });

  /// Reserved for 1.0 — per-view stream (currently set globally in initialize).
  final String stream;

  /// Reserved for 1.0 — per-view placement (currently set globally in initialize).
  final String placement;

  /// Embed style; the marketer "Type" setting overrides it when configured.
  final FeedLayout layout;

  /// Feed title rendered above the videos (the "Today" header).
  final String? title;

  @override
  Widget build(BuildContext context) => _isIOS
      ? UiKitView(
          viewType: 'blinklink_feed/feed',
          creationParams: {
            'layout': layout.name,
            'title': title,
            'stream': stream,
            'placement': placement,
          },
          creationParamsCodec: const StandardMessageCodec(),
        )
      : const _AndroidPlaceholder();
}

/// A directly scrollable player surface for a whole tab.
class BlinklinkSuperFeed extends StatelessWidget {
  const BlinklinkSuperFeed({super.key});

  @override
  Widget build(BuildContext context) => _isIOS
      ? const UiKitView(viewType: 'blinklink_feed/superfeed')
      : const _AndroidPlaceholder();
}

class _AndroidPlaceholder extends StatelessWidget {
  const _AndroidPlaceholder();

  @override
  Widget build(BuildContext context) => Container(
        color: const Color(0xFF101014),
        alignment: Alignment.center,
        child: const Text(
          'Blinklink\nAndroid renderer coming soon',
          textAlign: TextAlign.center,
          style: TextStyle(color: Color(0xFFB8B8C0), fontSize: 14),
        ),
      );
}
