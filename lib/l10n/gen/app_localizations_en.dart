// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Shelfie';

  @override
  String get devSpikeEntry => 'Rendering spike';

  @override
  String sharePagesDelta(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pages',
      one: '1 page',
    );
    return '+$_temp0';
  }

  @override
  String sharePageRange(int from, int to) {
    return 'p.$from → $to';
  }

  @override
  String shareProgressPercent(String percent) {
    return '$percent%';
  }

  @override
  String shareWeeklyStreak(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count week streak',
      one: '1 week streak',
    );
    return '$_temp0';
  }

  @override
  String shareProfileFooter(String domain, String username) {
    return '$domain/@$username';
  }

  @override
  String shareSlideCounter(int index, int total) {
    return '$index / $total';
  }

  @override
  String get spikeTitle => 'Rendering spike';

  @override
  String get spikeRenderStory => 'Render session_minimal (story)';

  @override
  String get spikeRenderCarousel => 'Render 3-slide carousel';

  @override
  String get spikeShareInstagram => 'Instagram Stories';

  @override
  String get spikeShareSystem => 'Share…';

  @override
  String get spikeRendering => 'Rendering…';

  @override
  String spikeResult(int count, int width, int height, int millis) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count images',
      one: '1 image',
    );
    return '$_temp0 · $width×$height · $millis ms';
  }

  @override
  String spikeError(String message) {
    return 'Render failed: $message';
  }

  @override
  String spikeCarouselHeadline(int index) {
    return 'Slide $index';
  }

  @override
  String get genericError => 'Something went wrong. Please try again.';

  @override
  String get retry => 'Retry';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get continueLabel => 'Continue';

  @override
  String get optional => 'Optional';

  @override
  String get fieldRequired => 'Required';

  @override
  String notConfigured(String flavor) {
    return 'This build has no backend configured ($flavor). Build with --dart-define-from-file=env/<flavor>.json.';
  }

  @override
  String get sessionLoadError =>
      'Couldn\'t load your account. Check your connection.';

  @override
  String get tabFeed => 'Feed';

  @override
  String get tabSearch => 'Search';

  @override
  String get tabUpdate => 'Update';

  @override
  String get tabLibrary => 'Library';

  @override
  String get tabYou => 'You';

  @override
  String get signInTagline => 'Log your page. Share it. Get kudos.';

  @override
  String get signInWithApple => 'Continue with Apple';

  @override
  String get signInWithGoogle => 'Continue with Google';

  @override
  String get signInOr => 'or';

  @override
  String get signInEmailLabel => 'Email';

  @override
  String get signInEmailInvalid => 'Enter a valid email address';

  @override
  String get signInSendLink => 'Email me a sign-in link';

  @override
  String signInCheckInbox(String email) {
    return 'We sent a sign-in link to $email. Open it on this device, or enter the code from the email.';
  }

  @override
  String get signInCodeLabel => 'Code from the email';

  @override
  String get signInVerifyCode => 'Sign in with code';

  @override
  String get signInUseDifferentEmail => 'Use a different email';

  @override
  String get signOut => 'Sign out';

  @override
  String get profileSetupTitle => 'Create your profile';

  @override
  String get profileSetupAvatar => 'Choose a profile photo';

  @override
  String get profileSetupAvatarHint => 'Add a photo (optional)';

  @override
  String get profileSetupUsername => 'Username';

  @override
  String get profileSetupUsernameRules =>
      '3–20 characters: lowercase letters, numbers and _';

  @override
  String get profileSetupUsernameTaken => 'That username is taken';

  @override
  String get profileSetupUsernameAvailable => 'Username available';

  @override
  String get profileSetupDisplayName => 'Display name';

  @override
  String get searchHint => 'Title, author or ISBN';

  @override
  String get searchClear => 'Clear';

  @override
  String get searchScan => 'Scan barcode';

  @override
  String get searchEmptyHint =>
      'Search for a book, or scan the barcode on the back.';

  @override
  String get searchNoResults => 'No books found.';

  @override
  String get searchError =>
      'Couldn\'t search right now. Check your connection.';

  @override
  String get searchCantFindIt => 'Can\'t find it?';

  @override
  String get searchAddManually => 'Add a book manually';

  @override
  String get searchFromGoogleBooks => 'From Google Books';

  @override
  String get scanTitle => 'Scan ISBN';

  @override
  String get scanTypeIsbn => 'Or type the ISBN';

  @override
  String get scanLookUp => 'Look up';

  @override
  String get scanInvalidIsbn => 'That isn\'t a valid ISBN';

  @override
  String get scanCameraUnavailable =>
      'Camera unavailable. Type the ISBN below instead.';

  @override
  String get manualAddTitle => 'Add a book';

  @override
  String get manualAddBookTitle => 'Title';

  @override
  String get manualAddAuthor => 'Author';

  @override
  String get manualAddPageCount => 'Number of pages';

  @override
  String get manualAddPageCountInvalid => 'Enter a number between 1 and 20,000';

  @override
  String get manualAddCoverPhoto => 'Add a cover photo';

  @override
  String get manualAddChangeCover => 'Change cover photo';

  @override
  String get bookFormat => 'Format';

  @override
  String formatName(String format) {
    String _temp0 = intl.Intl.selectLogic(format, {
      'print': 'Print',
      'ebook': 'Ebook',
      'audiobook': 'Audiobook',
      'other': 'Other',
    });
    return '$_temp0';
  }

  @override
  String shelfName(String shelf) {
    String _temp0 = intl.Intl.selectLogic(shelf, {
      'wantToRead': 'Want to read',
      'currentlyReading': 'Currently reading',
      'read': 'Read',
      'dnf': 'Did not finish',
      'other': 'Other',
    });
    return '$_temp0';
  }

  @override
  String shelfWithCount(String shelf, int count) {
    return '$shelf ($count)';
  }

  @override
  String get bookEdition => 'Edition';

  @override
  String get bookChangeEdition => 'Change edition';

  @override
  String bookPageCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pages',
      one: '1 page',
    );
    return '$_temp0';
  }

  @override
  String get bookPageCountUnknown => 'Page count unknown';

  @override
  String bookIsbn(String isbn) {
    return 'ISBN $isbn';
  }

  @override
  String get bookAddToShelf => 'Add to a shelf';

  @override
  String get bookOnShelf => 'Your shelf';

  @override
  String bookProgress(int page, int total) {
    return 'p.$page of $total';
  }

  @override
  String get bookProgressLabel => 'Reading progress';

  @override
  String get bookRemove => 'Remove from library';

  @override
  String get bookRemoveConfirmTitle => 'Remove this book?';

  @override
  String get bookRemoveConfirmBody => 'It will be removed from your shelves.';

  @override
  String get bookYourRating => 'Your rating';

  @override
  String get bookOneLineTake => 'Your one-line take';

  @override
  String get editionsLoadError => 'Couldn\'t load more editions.';

  @override
  String get libraryEmpty => 'Nothing on this shelf yet.';

  @override
  String get findABook => 'Find a book';

  @override
  String get openLibrary => 'Go to your library';

  @override
  String get feedComingSoon =>
      'Updates from readers you follow will show up here. For now, add the books you\'re reading.';

  @override
  String get updateComingSoon =>
      'Logging your page is coming next. Add your books to your shelves now so they are ready.';

  @override
  String get youNothingReading => 'You\'re not reading anything right now.';

  @override
  String followCounts(int followers, int following) {
    return '$followers followers · $following following';
  }

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsNoAiTitle => 'No generative AI';

  @override
  String get settingsNoAiBody =>
      'Shelfie doesn\'t use generative AI: no summaries, recaps or AI recommendations.';

  @override
  String get spikeCoverBlocked =>
      'The cover host doesn\'t allow cross-origin reads on web, so this export has no cover.';

  @override
  String get spikeDownload => 'Download';
}
