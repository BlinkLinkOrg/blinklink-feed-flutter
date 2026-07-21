import 'package:blinklink_feed/blinklink_feed.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BlinklinkAction.fromMap', () {
    test('parses openURL', () {
      final action = BlinklinkAction.fromMap({
        'type': 'openURL',
        'url': 'https://example.com/product',
      });
      expect(action, isA<BlinklinkOpenUrlAction>());
      expect((action as BlinklinkOpenUrlAction).url.host, 'example.com');
    });

    test('parses navigate with params', () {
      final action = BlinklinkAction.fromMap({
        'type': 'navigate',
        'screenId': 'videos',
        'params': {'tag': 'food'},
      });
      expect(action, isA<BlinklinkNavigateAction>());
      final navigate = action as BlinklinkNavigateAction;
      expect(navigate.screenId, 'videos');
      expect(navigate.params, {'tag': 'food'});
    });

    test('parses openSheet', () {
      final action = BlinklinkAction.fromMap({
        'type': 'openSheet',
        'kind': 'share',
        'contentId': 'abc',
      });
      expect(action, isA<BlinklinkOpenSheetAction>());
    });

    test('parses fireEvent', () {
      final action = BlinklinkAction.fromMap({
        'type': 'fireEvent',
        'name': 'impression',
        'attributes': {'contentId': 'abc'},
      });
      expect(action, isA<BlinklinkFireEventAction>());
    });

    test('unknown types fall back gracefully', () {
      final action = BlinklinkAction.fromMap({'type': 'somethingNew'});
      expect(action, isA<BlinklinkUnknownAction>());
    });
  });
}
