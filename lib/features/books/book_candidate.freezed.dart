// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'book_candidate.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BookCandidate {

 String get title; String? get subtitle; List<String> get authors; int? get firstPublishedYear; String? get coverUrl; String? get openLibraryWorkKey; String? get isbn13; String? get isbn10; int? get pageCount; String? get publisher; String? get publishedDate; String? get language; BookFormat get format; BookSource get source;/// Set when the book is already in our catalogue.
 String? get workId; String? get editionId;
/// Create a copy of BookCandidate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookCandidateCopyWith<BookCandidate> get copyWith => _$BookCandidateCopyWithImpl<BookCandidate>(this as BookCandidate, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as BookCandidate;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookCandidate&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.subtitle, _this.subtitle) || other.subtitle == _this.subtitle)&&const DeepCollectionEquality().equals(other.authors, _this.authors)&&(identical(other.firstPublishedYear, _this.firstPublishedYear) || other.firstPublishedYear == _this.firstPublishedYear)&&(identical(other.coverUrl, _this.coverUrl) || other.coverUrl == _this.coverUrl)&&(identical(other.openLibraryWorkKey, _this.openLibraryWorkKey) || other.openLibraryWorkKey == _this.openLibraryWorkKey)&&(identical(other.isbn13, _this.isbn13) || other.isbn13 == _this.isbn13)&&(identical(other.isbn10, _this.isbn10) || other.isbn10 == _this.isbn10)&&(identical(other.pageCount, _this.pageCount) || other.pageCount == _this.pageCount)&&(identical(other.publisher, _this.publisher) || other.publisher == _this.publisher)&&(identical(other.publishedDate, _this.publishedDate) || other.publishedDate == _this.publishedDate)&&(identical(other.language, _this.language) || other.language == _this.language)&&(identical(other.format, _this.format) || other.format == _this.format)&&(identical(other.source, _this.source) || other.source == _this.source)&&(identical(other.workId, _this.workId) || other.workId == _this.workId)&&(identical(other.editionId, _this.editionId) || other.editionId == _this.editionId));
}


@override
int get hashCode {
  final _this = this as BookCandidate;
  return Object.hash(runtimeType,_this.title,_this.subtitle,const DeepCollectionEquality().hash(_this.authors),_this.firstPublishedYear,_this.coverUrl,_this.openLibraryWorkKey,_this.isbn13,_this.isbn10,_this.pageCount,_this.publisher,_this.publishedDate,_this.language,_this.format,_this.source,_this.workId,_this.editionId);
}

@override
String toString() {
  final _this = this as BookCandidate;
  return 'BookCandidate(title: ${_this.title}, subtitle: ${_this.subtitle}, authors: ${_this.authors}, firstPublishedYear: ${_this.firstPublishedYear}, coverUrl: ${_this.coverUrl}, openLibraryWorkKey: ${_this.openLibraryWorkKey}, isbn13: ${_this.isbn13}, isbn10: ${_this.isbn10}, pageCount: ${_this.pageCount}, publisher: ${_this.publisher}, publishedDate: ${_this.publishedDate}, language: ${_this.language}, format: ${_this.format}, source: ${_this.source}, workId: ${_this.workId}, editionId: ${_this.editionId})';
}


}

/// @nodoc
abstract mixin class $BookCandidateCopyWith<$Res>  {
  factory $BookCandidateCopyWith(BookCandidate value, $Res Function(BookCandidate) _then) = _$BookCandidateCopyWithImpl;
@useResult
$Res call({
 String title, String? subtitle, List<String> authors, int? firstPublishedYear, String? coverUrl, String? openLibraryWorkKey, String? isbn13, String? isbn10, int? pageCount, String? publisher, String? publishedDate, String? language, BookFormat format, BookSource source, String? workId, String? editionId
});




}
/// @nodoc
class _$BookCandidateCopyWithImpl<$Res>
    implements $BookCandidateCopyWith<$Res> {
  _$BookCandidateCopyWithImpl(this._self, this._then);

  final BookCandidate _self;
  final $Res Function(BookCandidate) _then;

/// Create a copy of BookCandidate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? subtitle = freezed,Object? authors = null,Object? firstPublishedYear = freezed,Object? coverUrl = freezed,Object? openLibraryWorkKey = freezed,Object? isbn13 = freezed,Object? isbn10 = freezed,Object? pageCount = freezed,Object? publisher = freezed,Object? publishedDate = freezed,Object? language = freezed,Object? format = null,Object? source = null,Object? workId = freezed,Object? editionId = freezed,}) {
  return _then(BookCandidate(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,subtitle: freezed == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String?,authors: null == authors ? _self.authors : authors // ignore: cast_nullable_to_non_nullable
as List<String>,firstPublishedYear: freezed == firstPublishedYear ? _self.firstPublishedYear : firstPublishedYear // ignore: cast_nullable_to_non_nullable
as int?,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,openLibraryWorkKey: freezed == openLibraryWorkKey ? _self.openLibraryWorkKey : openLibraryWorkKey // ignore: cast_nullable_to_non_nullable
as String?,isbn13: freezed == isbn13 ? _self.isbn13 : isbn13 // ignore: cast_nullable_to_non_nullable
as String?,isbn10: freezed == isbn10 ? _self.isbn10 : isbn10 // ignore: cast_nullable_to_non_nullable
as String?,pageCount: freezed == pageCount ? _self.pageCount : pageCount // ignore: cast_nullable_to_non_nullable
as int?,publisher: freezed == publisher ? _self.publisher : publisher // ignore: cast_nullable_to_non_nullable
as String?,publishedDate: freezed == publishedDate ? _self.publishedDate : publishedDate // ignore: cast_nullable_to_non_nullable
as String?,language: freezed == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String?,format: null == format ? _self.format : format // ignore: cast_nullable_to_non_nullable
as BookFormat,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as BookSource,workId: freezed == workId ? _self.workId : workId // ignore: cast_nullable_to_non_nullable
as String?,editionId: freezed == editionId ? _self.editionId : editionId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [BookCandidate].
extension BookCandidatePatterns on BookCandidate {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookCandidate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookCandidate() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookCandidate value)  $default,){
final _that = this;
switch (_that) {
case _BookCandidate():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookCandidate value)?  $default,){
final _that = this;
switch (_that) {
case _BookCandidate() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  String? subtitle,  List<String> authors,  int? firstPublishedYear,  String? coverUrl,  String? openLibraryWorkKey,  String? isbn13,  String? isbn10,  int? pageCount,  String? publisher,  String? publishedDate,  String? language,  BookFormat format,  BookSource source,  String? workId,  String? editionId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookCandidate() when $default != null:
return $default(_that.title,_that.subtitle,_that.authors,_that.firstPublishedYear,_that.coverUrl,_that.openLibraryWorkKey,_that.isbn13,_that.isbn10,_that.pageCount,_that.publisher,_that.publishedDate,_that.language,_that.format,_that.source,_that.workId,_that.editionId);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  String? subtitle,  List<String> authors,  int? firstPublishedYear,  String? coverUrl,  String? openLibraryWorkKey,  String? isbn13,  String? isbn10,  int? pageCount,  String? publisher,  String? publishedDate,  String? language,  BookFormat format,  BookSource source,  String? workId,  String? editionId)  $default,) {final _that = this;
switch (_that) {
case _BookCandidate():
return $default(_that.title,_that.subtitle,_that.authors,_that.firstPublishedYear,_that.coverUrl,_that.openLibraryWorkKey,_that.isbn13,_that.isbn10,_that.pageCount,_that.publisher,_that.publishedDate,_that.language,_that.format,_that.source,_that.workId,_that.editionId);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  String? subtitle,  List<String> authors,  int? firstPublishedYear,  String? coverUrl,  String? openLibraryWorkKey,  String? isbn13,  String? isbn10,  int? pageCount,  String? publisher,  String? publishedDate,  String? language,  BookFormat format,  BookSource source,  String? workId,  String? editionId)?  $default,) {final _that = this;
switch (_that) {
case _BookCandidate() when $default != null:
return $default(_that.title,_that.subtitle,_that.authors,_that.firstPublishedYear,_that.coverUrl,_that.openLibraryWorkKey,_that.isbn13,_that.isbn10,_that.pageCount,_that.publisher,_that.publishedDate,_that.language,_that.format,_that.source,_that.workId,_that.editionId);case _:
  return null;

}
}

}

/// @nodoc


class _BookCandidate extends BookCandidate {
  const _BookCandidate({required this.title, this.subtitle,  List<String> authors = const <String>[], this.firstPublishedYear, this.coverUrl, this.openLibraryWorkKey, this.isbn13, this.isbn10, this.pageCount, this.publisher, this.publishedDate, this.language, this.format = BookFormat.print, required this.source, this.workId, this.editionId}): _authors = authors,super._();
  

@override final  String title;
@override final  String? subtitle;
 final  List<String> _authors;
@override@JsonKey() List<String> get authors {
  if (_authors is EqualUnmodifiableListView) return _authors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_authors);
}

@override final  int? firstPublishedYear;
@override final  String? coverUrl;
@override final  String? openLibraryWorkKey;
@override final  String? isbn13;
@override final  String? isbn10;
@override final  int? pageCount;
@override final  String? publisher;
@override final  String? publishedDate;
@override final  String? language;
@override@JsonKey() final  BookFormat format;
@override final  BookSource source;
/// Set when the book is already in our catalogue.
@override final  String? workId;
@override final  String? editionId;

/// Create a copy of BookCandidate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookCandidateCopyWith<_BookCandidate> get copyWith => __$BookCandidateCopyWithImpl<_BookCandidate>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookCandidate&&(identical(other.title, title) || other.title == title)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&const DeepCollectionEquality().equals(other.authors, _authors)&&(identical(other.firstPublishedYear, firstPublishedYear) || other.firstPublishedYear == firstPublishedYear)&&(identical(other.coverUrl, coverUrl) || other.coverUrl == coverUrl)&&(identical(other.openLibraryWorkKey, openLibraryWorkKey) || other.openLibraryWorkKey == openLibraryWorkKey)&&(identical(other.isbn13, isbn13) || other.isbn13 == isbn13)&&(identical(other.isbn10, isbn10) || other.isbn10 == isbn10)&&(identical(other.pageCount, pageCount) || other.pageCount == pageCount)&&(identical(other.publisher, publisher) || other.publisher == publisher)&&(identical(other.publishedDate, publishedDate) || other.publishedDate == publishedDate)&&(identical(other.language, language) || other.language == language)&&(identical(other.format, format) || other.format == format)&&(identical(other.source, source) || other.source == source)&&(identical(other.workId, workId) || other.workId == workId)&&(identical(other.editionId, editionId) || other.editionId == editionId));
}


@override
int get hashCode {
    return Object.hash(runtimeType,title,subtitle,const DeepCollectionEquality().hash(_authors),firstPublishedYear,coverUrl,openLibraryWorkKey,isbn13,isbn10,pageCount,publisher,publishedDate,language,format,source,workId,editionId);
}

@override
String toString() {
    return 'BookCandidate(title: $title, subtitle: $subtitle, authors: $authors, firstPublishedYear: $firstPublishedYear, coverUrl: $coverUrl, openLibraryWorkKey: $openLibraryWorkKey, isbn13: $isbn13, isbn10: $isbn10, pageCount: $pageCount, publisher: $publisher, publishedDate: $publishedDate, language: $language, format: $format, source: $source, workId: $workId, editionId: $editionId)';
}


}

/// @nodoc
abstract mixin class _$BookCandidateCopyWith<$Res> implements $BookCandidateCopyWith<$Res> {
  factory _$BookCandidateCopyWith(_BookCandidate value, $Res Function(_BookCandidate) _then) = __$BookCandidateCopyWithImpl;
@override @useResult
$Res call({
 String title, String? subtitle, List<String> authors, int? firstPublishedYear, String? coverUrl, String? openLibraryWorkKey, String? isbn13, String? isbn10, int? pageCount, String? publisher, String? publishedDate, String? language, BookFormat format, BookSource source, String? workId, String? editionId
});




}
/// @nodoc
class __$BookCandidateCopyWithImpl<$Res>
    implements _$BookCandidateCopyWith<$Res> {
  __$BookCandidateCopyWithImpl(this._self, this._then);

  final _BookCandidate _self;
  final $Res Function(_BookCandidate) _then;

/// Create a copy of BookCandidate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? subtitle = freezed,Object? authors = null,Object? firstPublishedYear = freezed,Object? coverUrl = freezed,Object? openLibraryWorkKey = freezed,Object? isbn13 = freezed,Object? isbn10 = freezed,Object? pageCount = freezed,Object? publisher = freezed,Object? publishedDate = freezed,Object? language = freezed,Object? format = null,Object? source = null,Object? workId = freezed,Object? editionId = freezed,}) {
  return _then(_BookCandidate(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,subtitle: freezed == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String?,authors: null == authors ? _self._authors : authors // ignore: cast_nullable_to_non_nullable
as List<String>,firstPublishedYear: freezed == firstPublishedYear ? _self.firstPublishedYear : firstPublishedYear // ignore: cast_nullable_to_non_nullable
as int?,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,openLibraryWorkKey: freezed == openLibraryWorkKey ? _self.openLibraryWorkKey : openLibraryWorkKey // ignore: cast_nullable_to_non_nullable
as String?,isbn13: freezed == isbn13 ? _self.isbn13 : isbn13 // ignore: cast_nullable_to_non_nullable
as String?,isbn10: freezed == isbn10 ? _self.isbn10 : isbn10 // ignore: cast_nullable_to_non_nullable
as String?,pageCount: freezed == pageCount ? _self.pageCount : pageCount // ignore: cast_nullable_to_non_nullable
as int?,publisher: freezed == publisher ? _self.publisher : publisher // ignore: cast_nullable_to_non_nullable
as String?,publishedDate: freezed == publishedDate ? _self.publishedDate : publishedDate // ignore: cast_nullable_to_non_nullable
as String?,language: freezed == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String?,format: null == format ? _self.format : format // ignore: cast_nullable_to_non_nullable
as BookFormat,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as BookSource,workId: freezed == workId ? _self.workId : workId // ignore: cast_nullable_to_non_nullable
as String?,editionId: freezed == editionId ? _self.editionId : editionId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
