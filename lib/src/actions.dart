/// A declarative action fired by a server-driven component.
sealed class BlinklinkAction {
  const BlinklinkAction();

  factory BlinklinkAction.fromMap(Map<String, dynamic> map) {
    switch (map['type'] as String?) {
      case 'openURL':
        return BlinklinkOpenUrlAction(Uri.parse(map['url'] as String));
      case 'navigate':
        return BlinklinkNavigateAction(
          screenId: map['screenId'] as String? ?? '',
          params: _stringMap(map['params']),
        );
      case 'openSheet':
        return BlinklinkOpenSheetAction(
          kind: map['kind'] as String? ?? '',
          contentId: map['contentId'] as String? ?? '',
        );
      case 'fireEvent':
        return BlinklinkFireEventAction(
          name: map['name'] as String? ?? '',
          attributes: _stringMap(map['attributes']),
        );
      default:
        return BlinklinkUnknownAction(Map<String, dynamic>.from(map));
    }
  }

  static Map<String, String> _stringMap(Object? value) {
    if (value is Map) {
      return value.map((k, v) => MapEntry(k.toString(), v.toString()));
    }
    return const {};
  }
}

/// Open an external / universal link (e.g. a banner or product CTA).
class BlinklinkOpenUrlAction extends BlinklinkAction {
  const BlinklinkOpenUrlAction(this.url);
  final Uri url;
}

/// Navigate to another server-driven screen.
class BlinklinkNavigateAction extends BlinklinkAction {
  const BlinklinkNavigateAction({required this.screenId, required this.params});
  final String screenId;
  final Map<String, String> params;
}

/// Present a sheet (comments / share / description).
class BlinklinkOpenSheetAction extends BlinklinkAction {
  const BlinklinkOpenSheetAction({required this.kind, required this.contentId});
  final String kind;
  final String contentId;
}

/// An analytics event.
class BlinklinkFireEventAction extends BlinklinkAction {
  const BlinklinkFireEventAction({required this.name, required this.attributes});
  final String name;
  final Map<String, String> attributes;
}

/// A forward-compatibility fallback for action types this package version
/// doesn't know yet.
class BlinklinkUnknownAction extends BlinklinkAction {
  const BlinklinkUnknownAction(this.raw);
  final Map<String, dynamic> raw;
}
