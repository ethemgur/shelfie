import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// Working app name. Replace once the final name is chosen.
  ///
  /// In en, this message translates to:
  /// **'Shelfie'**
  String get appName;

  /// No description provided for @devSpikeEntry.
  ///
  /// In en, this message translates to:
  /// **'Rendering spike'**
  String get devSpikeEntry;

  /// No description provided for @sharePagesDelta.
  ///
  /// In en, this message translates to:
  /// **'+{count, plural, =1{1 page} other{{count} pages}}'**
  String sharePagesDelta(int count);

  /// No description provided for @sharePageRange.
  ///
  /// In en, this message translates to:
  /// **'p.{from} → {to}'**
  String sharePageRange(int from, int to);

  /// No description provided for @shareProgressPercent.
  ///
  /// In en, this message translates to:
  /// **'{percent}%'**
  String shareProgressPercent(String percent);

  /// No description provided for @shareWeeklyStreak.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 week streak} other{{count} week streak}}'**
  String shareWeeklyStreak(int count);

  /// No description provided for @shareProfileFooter.
  ///
  /// In en, this message translates to:
  /// **'{domain}/@{username}'**
  String shareProfileFooter(String domain, String username);

  /// No description provided for @shareSlideCounter.
  ///
  /// In en, this message translates to:
  /// **'{index} / {total}'**
  String shareSlideCounter(int index, int total);

  /// No description provided for @spikeTitle.
  ///
  /// In en, this message translates to:
  /// **'Rendering spike'**
  String get spikeTitle;

  /// No description provided for @spikeRenderStory.
  ///
  /// In en, this message translates to:
  /// **'Render session_minimal (story)'**
  String get spikeRenderStory;

  /// No description provided for @spikeRenderCarousel.
  ///
  /// In en, this message translates to:
  /// **'Render 3-slide carousel'**
  String get spikeRenderCarousel;

  /// No description provided for @spikeShareInstagram.
  ///
  /// In en, this message translates to:
  /// **'Instagram Stories'**
  String get spikeShareInstagram;

  /// No description provided for @spikeShareSystem.
  ///
  /// In en, this message translates to:
  /// **'Share…'**
  String get spikeShareSystem;

  /// No description provided for @spikeRendering.
  ///
  /// In en, this message translates to:
  /// **'Rendering…'**
  String get spikeRendering;

  /// No description provided for @spikeResult.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 image} other{{count} images}} · {width}×{height} · {millis} ms'**
  String spikeResult(int count, int width, int height, int millis);

  /// No description provided for @spikeError.
  ///
  /// In en, this message translates to:
  /// **'Render failed: {message}'**
  String spikeError(String message);

  /// No description provided for @spikeCarouselHeadline.
  ///
  /// In en, this message translates to:
  /// **'Slide {index}'**
  String spikeCarouselHeadline(int index);

  /// No description provided for @genericError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get genericError;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @continueLabel.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueLabel;

  /// No description provided for @optional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get optional;

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get fieldRequired;

  /// No description provided for @notConfigured.
  ///
  /// In en, this message translates to:
  /// **'This build has no Firebase project configured ({flavor}). On Firebase Hosting, register a Web app in the Firebase project; elsewhere, build with --dart-define-from-file=env/<flavor>.json.'**
  String notConfigured(String flavor);

  /// No description provided for @sessionLoadError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load your account. Check your connection.'**
  String get sessionLoadError;

  /// No description provided for @tabFeed.
  ///
  /// In en, this message translates to:
  /// **'Feed'**
  String get tabFeed;

  /// No description provided for @tabSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get tabSearch;

  /// No description provided for @tabUpdate.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get tabUpdate;

  /// No description provided for @tabLibrary.
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get tabLibrary;

  /// No description provided for @tabYou.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get tabYou;

  /// No description provided for @signInTagline.
  ///
  /// In en, this message translates to:
  /// **'Log your page. Share it. Get kudos.'**
  String get signInTagline;

  /// No description provided for @signInWithApple.
  ///
  /// In en, this message translates to:
  /// **'Continue with Apple'**
  String get signInWithApple;

  /// No description provided for @signInWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get signInWithGoogle;

  /// No description provided for @signInOr.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get signInOr;

  /// No description provided for @signInEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get signInEmailLabel;

  /// No description provided for @signInEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address'**
  String get signInEmailInvalid;

  /// No description provided for @signInSendLink.
  ///
  /// In en, this message translates to:
  /// **'Email me a sign-in link'**
  String get signInSendLink;

  /// No description provided for @signInCheckInbox.
  ///
  /// In en, this message translates to:
  /// **'We sent a sign-in link to {email}. Open it on this device to sign in.'**
  String signInCheckInbox(String email);

  /// No description provided for @signInUseDifferentEmail.
  ///
  /// In en, this message translates to:
  /// **'Use a different email'**
  String get signInUseDifferentEmail;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// No description provided for @profileSetupTitle.
  ///
  /// In en, this message translates to:
  /// **'Create your profile'**
  String get profileSetupTitle;

  /// No description provided for @profileSetupAvatar.
  ///
  /// In en, this message translates to:
  /// **'Choose a profile photo'**
  String get profileSetupAvatar;

  /// No description provided for @profileSetupAvatarHint.
  ///
  /// In en, this message translates to:
  /// **'Add a photo (optional)'**
  String get profileSetupAvatarHint;

  /// No description provided for @profileSetupUsername.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get profileSetupUsername;

  /// No description provided for @profileSetupUsernameRules.
  ///
  /// In en, this message translates to:
  /// **'3–20 characters: lowercase letters, numbers and _'**
  String get profileSetupUsernameRules;

  /// No description provided for @profileSetupUsernameTaken.
  ///
  /// In en, this message translates to:
  /// **'That username is taken'**
  String get profileSetupUsernameTaken;

  /// No description provided for @profileSetupUsernameAvailable.
  ///
  /// In en, this message translates to:
  /// **'Username available'**
  String get profileSetupUsernameAvailable;

  /// No description provided for @profileSetupDisplayName.
  ///
  /// In en, this message translates to:
  /// **'Display name'**
  String get profileSetupDisplayName;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Title, author or ISBN'**
  String get searchHint;

  /// No description provided for @searchClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get searchClear;

  /// No description provided for @searchScan.
  ///
  /// In en, this message translates to:
  /// **'Scan barcode'**
  String get searchScan;

  /// No description provided for @searchEmptyHint.
  ///
  /// In en, this message translates to:
  /// **'Search for a book, or scan the barcode on the back.'**
  String get searchEmptyHint;

  /// No description provided for @searchNoResults.
  ///
  /// In en, this message translates to:
  /// **'No books found.'**
  String get searchNoResults;

  /// No description provided for @searchError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t search right now. Check your connection.'**
  String get searchError;

  /// No description provided for @searchCantFindIt.
  ///
  /// In en, this message translates to:
  /// **'Can\'t find it?'**
  String get searchCantFindIt;

  /// No description provided for @searchAddManually.
  ///
  /// In en, this message translates to:
  /// **'Add a book manually'**
  String get searchAddManually;

  /// No description provided for @searchFromGoogleBooks.
  ///
  /// In en, this message translates to:
  /// **'From Google Books'**
  String get searchFromGoogleBooks;

  /// No description provided for @scanTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan ISBN'**
  String get scanTitle;

  /// No description provided for @scanTypeIsbn.
  ///
  /// In en, this message translates to:
  /// **'Or type the ISBN'**
  String get scanTypeIsbn;

  /// No description provided for @scanLookUp.
  ///
  /// In en, this message translates to:
  /// **'Look up'**
  String get scanLookUp;

  /// No description provided for @scanInvalidIsbn.
  ///
  /// In en, this message translates to:
  /// **'That isn\'t a valid ISBN'**
  String get scanInvalidIsbn;

  /// No description provided for @scanCameraUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Camera unavailable. Type the ISBN below instead.'**
  String get scanCameraUnavailable;

  /// No description provided for @manualAddTitle.
  ///
  /// In en, this message translates to:
  /// **'Add a book'**
  String get manualAddTitle;

  /// No description provided for @manualAddBookTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get manualAddBookTitle;

  /// No description provided for @manualAddAuthor.
  ///
  /// In en, this message translates to:
  /// **'Author'**
  String get manualAddAuthor;

  /// No description provided for @manualAddPageCount.
  ///
  /// In en, this message translates to:
  /// **'Number of pages'**
  String get manualAddPageCount;

  /// No description provided for @manualAddPageCountInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a number between 1 and 20,000'**
  String get manualAddPageCountInvalid;

  /// No description provided for @manualAddCoverPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add a cover photo'**
  String get manualAddCoverPhoto;

  /// No description provided for @manualAddChangeCover.
  ///
  /// In en, this message translates to:
  /// **'Change cover photo'**
  String get manualAddChangeCover;

  /// No description provided for @bookFormat.
  ///
  /// In en, this message translates to:
  /// **'Format'**
  String get bookFormat;

  /// No description provided for @formatName.
  ///
  /// In en, this message translates to:
  /// **'{format, select, print{Print} ebook{Ebook} audiobook{Audiobook} other{Other}}'**
  String formatName(String format);

  /// No description provided for @shelfName.
  ///
  /// In en, this message translates to:
  /// **'{shelf, select, wantToRead{Want to read} currentlyReading{Currently reading} read{Read} dnf{Did not finish} other{Other}}'**
  String shelfName(String shelf);

  /// No description provided for @shelfWithCount.
  ///
  /// In en, this message translates to:
  /// **'{shelf} ({count})'**
  String shelfWithCount(String shelf, int count);

  /// No description provided for @bookEdition.
  ///
  /// In en, this message translates to:
  /// **'Edition'**
  String get bookEdition;

  /// No description provided for @bookChangeEdition.
  ///
  /// In en, this message translates to:
  /// **'Change edition'**
  String get bookChangeEdition;

  /// No description provided for @bookPageCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 page} other{{count} pages}}'**
  String bookPageCount(int count);

  /// No description provided for @bookPageCountUnknown.
  ///
  /// In en, this message translates to:
  /// **'Page count unknown'**
  String get bookPageCountUnknown;

  /// No description provided for @bookIsbn.
  ///
  /// In en, this message translates to:
  /// **'ISBN {isbn}'**
  String bookIsbn(String isbn);

  /// No description provided for @bookAddToShelf.
  ///
  /// In en, this message translates to:
  /// **'Add to a shelf'**
  String get bookAddToShelf;

  /// No description provided for @bookOnShelf.
  ///
  /// In en, this message translates to:
  /// **'Your shelf'**
  String get bookOnShelf;

  /// No description provided for @bookProgress.
  ///
  /// In en, this message translates to:
  /// **'p.{page} of {total}'**
  String bookProgress(int page, int total);

  /// No description provided for @bookProgressLabel.
  ///
  /// In en, this message translates to:
  /// **'Reading progress'**
  String get bookProgressLabel;

  /// No description provided for @bookRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove from library'**
  String get bookRemove;

  /// No description provided for @bookRemoveConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove this book?'**
  String get bookRemoveConfirmTitle;

  /// No description provided for @bookRemoveConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'It will be removed from your shelves.'**
  String get bookRemoveConfirmBody;

  /// No description provided for @bookYourRating.
  ///
  /// In en, this message translates to:
  /// **'Your rating'**
  String get bookYourRating;

  /// No description provided for @bookOneLineTake.
  ///
  /// In en, this message translates to:
  /// **'Your one-line take'**
  String get bookOneLineTake;

  /// No description provided for @editionsLoadError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load more editions.'**
  String get editionsLoadError;

  /// No description provided for @libraryEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing on this shelf yet.'**
  String get libraryEmpty;

  /// No description provided for @findABook.
  ///
  /// In en, this message translates to:
  /// **'Find a book'**
  String get findABook;

  /// No description provided for @openLibrary.
  ///
  /// In en, this message translates to:
  /// **'Go to your library'**
  String get openLibrary;

  /// No description provided for @feedComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Updates from readers you follow will show up here. For now, add the books you\'re reading.'**
  String get feedComingSoon;

  /// No description provided for @updateComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Logging your page is coming next. Add your books to your shelves now so they are ready.'**
  String get updateComingSoon;

  /// No description provided for @youNothingReading.
  ///
  /// In en, this message translates to:
  /// **'You\'re not reading anything right now.'**
  String get youNothingReading;

  /// No description provided for @followCounts.
  ///
  /// In en, this message translates to:
  /// **'{followers} followers · {following} following'**
  String followCounts(int followers, int following);

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsNoAiTitle.
  ///
  /// In en, this message translates to:
  /// **'No generative AI'**
  String get settingsNoAiTitle;

  /// No description provided for @settingsNoAiBody.
  ///
  /// In en, this message translates to:
  /// **'Shelfie doesn\'t use generative AI: no summaries, recaps or AI recommendations.'**
  String get settingsNoAiBody;

  /// No description provided for @spikeCoverBlocked.
  ///
  /// In en, this message translates to:
  /// **'The cover host doesn\'t allow cross-origin reads on web, so this export has no cover.'**
  String get spikeCoverBlocked;

  /// No description provided for @spikeDownload.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get spikeDownload;

  /// No description provided for @signInConfirmEmail.
  ///
  /// In en, this message translates to:
  /// **'Confirm the email address you used to sign in.'**
  String get signInConfirmEmail;

  /// No description provided for @signInFinish.
  ///
  /// In en, this message translates to:
  /// **'Finish signing in'**
  String get signInFinish;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
