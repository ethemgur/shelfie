import 'package:flutter_test/flutter_test.dart';
import 'package:shelfie/app/router.dart';
import 'package:shelfie/app/routes.dart';
import 'package:shelfie/features/auth/session_gate.dart';

void main() {
  String? go(SessionStatus status, String location) =>
      sessionRedirect(status, Uri.parse(location));

  test('signed-out users go to sign-in, remembering deep links', () {
    expect(go(SessionStatus.signedOut, '/feed'), '/sign-in?from=%2Ffeed');
    expect(
      go(SessionStatus.signedOut, '/book/abc?edition=e1'),
      '/sign-in?from=%2Fbook%2Fabc%3Fedition%3De1',
    );
    expect(go(SessionStatus.signedOut, '/'), Routes.signIn);
    expect(go(SessionStatus.signedOut, Routes.signIn), isNull);
  });

  test('users without a profile must finish profile setup', () {
    expect(
      go(SessionStatus.needsProfile, Routes.signIn),
      Routes.onboardingProfile,
    );
    expect(go(SessionStatus.needsProfile, Routes.onboardingProfile), isNull);
    expect(
      go(SessionStatus.needsProfile, '/library'),
      '/onboarding/profile?from=%2Flibrary',
    );
  });

  test('ready users leave the onboarding pages, back to where they were', () {
    expect(go(SessionStatus.ready, Routes.signIn), Routes.feed);
    expect(go(SessionStatus.ready, '/'), Routes.feed);
    expect(
      go(SessionStatus.ready, '/onboarding/profile?from=%2Fbook%2Fabc'),
      '/book/abc',
    );
    expect(go(SessionStatus.ready, '/library'), isNull);
  });

  test('keeps the destination across onboarding steps', () {
    expect(
      go(SessionStatus.needsProfile, '/sign-in?from=%2Flibrary'),
      '/onboarding/profile?from=%2Flibrary',
    );
    expect(
      go(SessionStatus.signedOut, '/loading?from=%2Fbook%2Fx'),
      '/sign-in?from=%2Fbook%2Fx',
    );
  });

  test('ignores off-site "from" targets', () {
    expect(
      go(SessionStatus.ready, '/sign-in?from=%2F%2Fevil.example'),
      Routes.feed,
    );
    expect(
      go(SessionStatus.ready, '/sign-in?from=https%3A%2F%2Fevil.example'),
      Routes.feed,
    );
  });

  test('loading and error states hold on their own pages', () {
    expect(go(SessionStatus.loading, '/feed'), '/loading?from=%2Ffeed');
    expect(go(SessionStatus.loading, Routes.loading), isNull);
    expect(go(SessionStatus.error, '/feed'), Routes.sessionError);
  });
}
