/// Route paths. Tabs are top-level so they deep-link on web.
abstract final class Routes {
  static const loading = '/loading';
  static const sessionError = '/session-error';
  static const signIn = '/sign-in';
  static const onboardingProfile = '/onboarding/profile';

  static const feed = '/feed';
  static const search = '/search';
  static const update = '/update';
  static const library = '/library';
  static const you = '/you';

  static const scan = '/scan';
  static const manualAdd = '/books/new';
  static const settings = '/settings';
  static const devSpike = '/dev/spike';

  static const bookPattern = '/book/:workId';
  static String book(String workId, {String? editionId}) => Uri(
    path: '/book/$workId',
    queryParameters: editionId == null ? null : {'edition': editionId},
  ).toString();

  /// Pages that belong to the signed-out / onboarding flow.
  static const preApp = {loading, sessionError, signIn, onboardingProfile};
}
