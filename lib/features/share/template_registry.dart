import 'share_format.dart';
import 'share_template.dart';
import 'templates/session_minimal.dart';

/// Every share template the composer can offer.
abstract final class TemplateRegistry {
  static const List<ShareTemplate> all = [SessionMinimalTemplate()];

  static List<ShareTemplate> forFamily(TemplateFamily family) =>
      all.where((t) => t.family == family).toList(growable: false);

  static ShareTemplate byId(String id) => all.firstWhere((t) => t.id == id);
}
