import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'models.freezed.dart';
part 'models.g.dart';

/// Firestore stores times as [Timestamp]; tests and JSON may use strings.
class TimestampConverter implements JsonConverter<DateTime?, Object?> {
  const TimestampConverter();

  @override
  DateTime? fromJson(Object? json) => switch (json) {
    Timestamp t => t.toDate(),
    DateTime d => d,
    String s => DateTime.parse(s),
    _ => null,
  };

  @override
  Object? toJson(DateTime? date) =>
      date == null ? null : Timestamp.fromDate(date);
}

/// Builds a model map from a Firestore document, adding its id.
Map<String, dynamic> withId(DocumentSnapshot<Map<String, dynamic>> doc) => {
  ...?doc.data(),
  'id': doc.id,
};

enum Shelf {
  @JsonValue('want_to_read')
  wantToRead,
  @JsonValue('currently_reading')
  currentlyReading,
  @JsonValue('read')
  read,
  @JsonValue('dnf')
  dnf;

  String get dbValue => const {
    Shelf.wantToRead: 'want_to_read',
    Shelf.currentlyReading: 'currently_reading',
    Shelf.read: 'read',
    Shelf.dnf: 'dnf',
  }[this]!;
}

enum BookFormat { print, ebook, audiobook }

enum Visibility { public, followers, private }

/// Where a catalogue entry came from (`editions.source`).
enum BookSource {
  @JsonValue('open_library')
  openLibrary,
  @JsonValue('google_books')
  googleBooks,
  @JsonValue('user')
  user;

  String get dbValue => const {
    BookSource.openLibrary: 'open_library',
    BookSource.googleBooks: 'google_books',
    BookSource.user: 'user',
  }[this]!;
}

@freezed
abstract class Profile with _$Profile {
  const factory Profile({
    required String id,
    required String username,
    required String displayName,
    String? avatarPath,
    String? avatarUrl,
    String? bio,
    @Default(150) int weeklyPageGoal,
    @Default(Visibility.followers) Visibility defaultVisibility,
    @Default('UTC') String timezone,
    @TimestampConverter() DateTime? onboardingCompletedAt,
  }) = _Profile;

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);
}

@freezed
abstract class Work with _$Work {
  const factory Work({
    required String id,
    required String title,
    String? subtitle,
    @Default(<String>[]) List<String> authors,
    int? firstPublishedYear,
    String? coverUrl,
    String? openLibraryWorkKey,
  }) = _Work;

  factory Work.fromJson(Map<String, dynamic> json) => _$WorkFromJson(json);
}

@freezed
abstract class Edition with _$Edition {
  const factory Edition({
    required String id,
    required String workId,
    String? isbn13,
    String? isbn10,
    @Default(BookFormat.print) BookFormat format,
    int? pageCount,
    String? publisher,
    String? publishedDate,
    String? language,
    String? coverUrl,
    required BookSource source,
  }) = _Edition;

  factory Edition.fromJson(Map<String, dynamic> json) =>
      _$EditionFromJson(json);
}

@freezed
abstract class UserBook with _$UserBook {
  const UserBook._();

  const factory UserBook({
    required String id,
    required String userId,
    required String workId,
    String? editionId,
    int? pageCountOverride,
    required Shelf shelf,
    @Default(0) int currentPage,

    /// Local calendar dates, `yyyy-MM-dd`.
    String? startedAt,
    String? finishedAt,
    double? rating,
    String? reviewLine,
    @Default('app') String source,
    @TimestampConverter() DateTime? updatedAt,
  }) = _UserBook;

  factory UserBook.fromJson(Map<String, dynamic> json) =>
      _$UserBookFromJson(json);
}

/// A book as shown in lists: the user's shelf entry with its work and edition.
@freezed
abstract class ShelvedBook with _$ShelvedBook {
  const ShelvedBook._();

  const factory ShelvedBook({
    required UserBook userBook,
    required Work work,
    Edition? edition,
  }) = _ShelvedBook;

  /// Section 8.1: `page_count_override ?? editions.page_count`.
  int? get effectivePageCount =>
      userBook.pageCountOverride ?? edition?.pageCount;

  String? get coverUrl => edition?.coverUrl ?? work.coverUrl;
}
