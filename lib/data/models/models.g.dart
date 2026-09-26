// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Profile _$ProfileFromJson(Map<String, dynamic> json) => _Profile(
  id: json['id'] as String,
  username: json['username'] as String,
  displayName: json['display_name'] as String,
  avatarPath: json['avatar_path'] as String?,
  bio: json['bio'] as String?,
  weeklyPageGoal: (json['weekly_page_goal'] as num?)?.toInt() ?? 150,
  defaultVisibility:
      $enumDecodeNullable(_$VisibilityEnumMap, json['default_visibility']) ??
      Visibility.followers,
  timezone: json['timezone'] as String? ?? 'UTC',
  onboardingCompletedAt: json['onboarding_completed_at'] == null
      ? null
      : DateTime.parse(json['onboarding_completed_at'] as String),
);

Map<String, dynamic> _$ProfileToJson(_Profile instance) => <String, dynamic>{
  'id': instance.id,
  'username': instance.username,
  'display_name': instance.displayName,
  'avatar_path': instance.avatarPath,
  'bio': instance.bio,
  'weekly_page_goal': instance.weeklyPageGoal,
  'default_visibility': _$VisibilityEnumMap[instance.defaultVisibility]!,
  'timezone': instance.timezone,
  'onboarding_completed_at': instance.onboardingCompletedAt?.toIso8601String(),
};

const _$VisibilityEnumMap = {
  Visibility.public: 'public',
  Visibility.followers: 'followers',
  Visibility.private: 'private',
};

_Work _$WorkFromJson(Map<String, dynamic> json) => _Work(
  id: json['id'] as String,
  title: json['title'] as String,
  subtitle: json['subtitle'] as String?,
  authors:
      (json['authors'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  firstPublishedYear: (json['first_published_year'] as num?)?.toInt(),
  coverUrl: json['cover_url'] as String?,
  openLibraryWorkKey: json['open_library_work_key'] as String?,
);

Map<String, dynamic> _$WorkToJson(_Work instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'subtitle': instance.subtitle,
  'authors': instance.authors,
  'first_published_year': instance.firstPublishedYear,
  'cover_url': instance.coverUrl,
  'open_library_work_key': instance.openLibraryWorkKey,
};

_Edition _$EditionFromJson(Map<String, dynamic> json) => _Edition(
  id: json['id'] as String,
  workId: json['work_id'] as String,
  isbn13: json['isbn13'] as String?,
  isbn10: json['isbn10'] as String?,
  format:
      $enumDecodeNullable(_$BookFormatEnumMap, json['format']) ??
      BookFormat.print,
  pageCount: (json['page_count'] as num?)?.toInt(),
  publisher: json['publisher'] as String?,
  publishedDate: json['published_date'] as String?,
  language: json['language'] as String?,
  coverUrl: json['cover_url'] as String?,
  source: $enumDecode(_$BookSourceEnumMap, json['source']),
);

Map<String, dynamic> _$EditionToJson(_Edition instance) => <String, dynamic>{
  'id': instance.id,
  'work_id': instance.workId,
  'isbn13': instance.isbn13,
  'isbn10': instance.isbn10,
  'format': _$BookFormatEnumMap[instance.format]!,
  'page_count': instance.pageCount,
  'publisher': instance.publisher,
  'published_date': instance.publishedDate,
  'language': instance.language,
  'cover_url': instance.coverUrl,
  'source': _$BookSourceEnumMap[instance.source]!,
};

const _$BookFormatEnumMap = {
  BookFormat.print: 'print',
  BookFormat.ebook: 'ebook',
  BookFormat.audiobook: 'audiobook',
};

const _$BookSourceEnumMap = {
  BookSource.openLibrary: 'open_library',
  BookSource.googleBooks: 'google_books',
  BookSource.user: 'user',
};

_UserBook _$UserBookFromJson(Map<String, dynamic> json) => _UserBook(
  id: json['id'] as String,
  userId: json['user_id'] as String,
  workId: json['work_id'] as String,
  editionId: json['edition_id'] as String?,
  pageCountOverride: (json['page_count_override'] as num?)?.toInt(),
  shelf: $enumDecode(_$ShelfEnumMap, json['shelf']),
  currentPage: (json['current_page'] as num?)?.toInt() ?? 0,
  startedAt: json['started_at'] == null
      ? null
      : DateTime.parse(json['started_at'] as String),
  finishedAt: json['finished_at'] == null
      ? null
      : DateTime.parse(json['finished_at'] as String),
  rating: (json['rating'] as num?)?.toDouble(),
  reviewLine: json['review_line'] as String?,
  source: json['source'] as String? ?? 'app',
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$UserBookToJson(_UserBook instance) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.userId,
  'work_id': instance.workId,
  'edition_id': instance.editionId,
  'page_count_override': instance.pageCountOverride,
  'shelf': _$ShelfEnumMap[instance.shelf]!,
  'current_page': instance.currentPage,
  'started_at': instance.startedAt?.toIso8601String(),
  'finished_at': instance.finishedAt?.toIso8601String(),
  'rating': instance.rating,
  'review_line': instance.reviewLine,
  'source': instance.source,
  'updated_at': instance.updatedAt?.toIso8601String(),
};

const _$ShelfEnumMap = {
  Shelf.wantToRead: 'want_to_read',
  Shelf.currentlyReading: 'currently_reading',
  Shelf.read: 'read',
  Shelf.dnf: 'dnf',
};
