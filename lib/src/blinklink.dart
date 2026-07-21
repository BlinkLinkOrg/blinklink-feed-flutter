import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'actions.dart';

/// Backend environment the SDK talks to.
enum BlinklinkEnvironment { development, production }

/// The Blinklink Feed SDK entry point.
class Blinklink {
  Blinklink._();

  static const MethodChannel _channel = MethodChannel('blinklink_feed');
  static const EventChannel _actions = EventChannel('blinklink_feed/actions');

  static bool get _isIOS => !kIsWeb && Platform.isIOS;

  /// Configure the SDK once at app startup.
  ///
  /// ⚠️ [environment] defaults to production — during evaluation use
  /// [BlinklinkEnvironment.development] and the clientId provided by
  /// Blinklink.
  ///
  /// [interceptActions] lists action types (`'openURL'`, `'navigate'`,
  /// `'openSheet'`, `'fireEvent'`) the SDK should NOT handle itself; every
  /// action is emitted on [actions] regardless.
  static Future<void> initialize({
    required String clientId,
    BlinklinkEnvironment environment = BlinklinkEnvironment.production,
    String stream = 'videos',
    String placement = 'videos-tab',
    List<String> interceptActions = const [],
  }) async {
    if (!_isIOS) return;
    await _channel.invokeMethod('initialize', {
      'clientId': clientId,
      'environment': environment.name,
      'stream': stream,
      'placement': placement,
      'interceptActions': interceptActions,
    });
  }

  /// Associate your own user reference with this device so likes and
  /// personalization follow the account across devices.
  static Future<void> setUser({required String ref}) async {
    if (!_isIOS) return;
    await _channel.invokeMethod('setUser', {'ref': ref});
  }

  /// Clear the user association (logout).
  static Future<void> clearUser() async {
    if (!_isIOS) return;
    await _channel.invokeMethod('clearUser');
  }

  /// Route a Blinklink share link (universal link) to the video player.
  /// Returns true when the link was a Blinklink share link. Call
  /// [initialize] before forwarding links.
  static Future<bool> handleUniversalLink(Uri url) async {
    if (!_isIOS) return false;
    final handled =
        await _channel.invokeMethod<bool>('handleUniversalLink', {'url': '$url'});
    return handled ?? false;
  }

  /// Component actions (CTAs, navigation, analytics events).
  static Stream<BlinklinkAction> get actions => _isIOS
      ? _actions.receiveBroadcastStream().map(
          (event) => BlinklinkAction.fromMap(
            Map<String, dynamic>.from(event as Map),
          ),
        )
      : const Stream.empty();
}
