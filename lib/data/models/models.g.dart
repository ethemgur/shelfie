// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Profile _$ProfileFromJson(Map<String, dynamic> json) => _Profile(
  id: json['id'] as String,
  username: json['username'] as String,
  displayName: json['displayName'] as String,
  avatarPath: json['avatarPath'] as String?,
  avatarUrl: json['avatarUrl'] as String?,
  bio: json['bio'] as String?,
  weeklyPageGoal: (json['weeklyPageGoal'] as num?)?.toInt() ?? 150,
  defaultVisibility:
      $enumDecodeNullable(_$VisibilityEnumMap, json['defaultVisibility']) ??
      Visibility.followers,
  timezone: json['timezone'] as String? ?? 'UTC',
  onboardingCompletedAt: const TimestampConverter().fromJson(
    json['onboardingCompletedAt'],
  ),
);

Map<String, dynamic> _$ProfileToJson(_Profile instance) => <String, dynamic>{
  'id': instance.id,
  'username': instance.username,
  'displayName': instance.displayName,
  'avatarPath': instance.avatarPath,
  'avatarUrl': instance.avatarUrl,
  'bio': instance.bio,
  'weeklyPageGoal': instance.weeklyPageGoal,
  'defaultVisibility': _$VisibilityEnumMap[instance.defaultVisibility]!,
  'timezone': instance.timezone,
  'onboardingCompletedAt': const TimestampConverter().toJson(
    instance.onboardingCompletedAt,
  ),
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
  firstPublishedYear: (json['firstPublishedYear'] as num?)?.toInt(),
  coverUrl: json['coverUrl'] as String?,
  openLibraryWorkKey: json['openLibraryWorkKey'] as String?,
);

Map<String, dynamic> _$WorkToJson(_Work instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'subtitle': instance.subtitle,
  'authors': instance.authors,
  'firstPublishedYear': instance.firstPublishedYear,
  'coverUrl': instance.coverUrl,
  'openLibraryWorkKey': instance.openLibraryWorkKey,
};

_Edition _$EditionFromJson(Map<String, dynamic> json) => _Edition(
  id: json['id'] as String,
  workId: json['workId'] as String,
  isbn13: json['isbn13'] as String?,
  isbn10: json['isbn10'] as String?,
  format:
      $enumDecodeNullable(_$BookFormatEnumMap, json['format']) ??
      BookFormat.print,
  pageCount: (json['pageCount'] as num?)?.toInt(),
  publisher: json['publisher'] as String?,
  publishedDate: json['publishedDate'] as String?,
  language: json['language'] as String?,
  coverUrl: json['coverUrl'] as String?,
  source: $enumDecode(_$BookSourceEnumMap, json['source']),
);

Map<String, dynamic> _$EditionToJson(_Edition instance) => <String, dynamic>{
  'id': instance.id,
  'workId': instance.workId,
  'isbn13': instance.isbn13,
  'isbn10': instance.isbn10,
  'format': _$BookFormatEnumMap[instance.format]!,
  'pageCount': instance.pageCount,
  'publisher': instance.publisher,
  'publishedDate': instance.publishedDate,
  'language': instance.language,
  'coverUrl': instance.coverUrl,
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
  userId: json['userId'] as String,
  workId: json['workId'] as String,
  editionId: json['editionId'] as String?,
  pageCountOverride: (json['pageCountOverride'] as num?)?.toInt(),
  shelf: $enumDecode(_$ShelfEnumMap, json['shelf']),
  currentPage: (json['currentPage'] as num?)?.toInt() ?? 0,
  startedAt: json['startedAt'] as String?,
  finishedAt: json['finishedAt'] as String?,
  rating: (json['rating'] as num?)?.toDouble(),
  reviewLine: json['reviewLine'] as String?,
  source: json['source'] as String? ?? 'app',
  updatedAt: const TimestampConverter().fromJson(json['updatedAt']),
);

Map<String, dynamic> _$UserBookToJson(_UserBook instance) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'workId': instance.workId,
  'editionId': instance.editionId,
  'pageCountOverride': instance.pageCountOverride,
  'shelf': _$ShelfEnumMap[instance.shelf]!,
  'currentPage': instance.currentPage,
  'startedAt': instance.startedAt,
  'finishedAt': instance.finishedAt,
  'rating': instance.rating,
  'reviewLine': instance.reviewLine,
  'source': instance.source,
  'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
};

const _$ShelfEnumMap = {
  Shelf.wantToRead: 'want_to_read',
  Shelf.currentlyReading: 'currently_reading',
  Shelf.read: 'read',
  Shelf.dnf: 'dnf',
};
