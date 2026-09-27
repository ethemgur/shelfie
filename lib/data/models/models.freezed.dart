// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Profile {

 String get id; String get username; String get displayName; String? get avatarPath; String? get avatarUrl; String? get bio; int get weeklyPageGoal; Visibility get defaultVisibility; String get timezone;@TimestampConverter() DateTime? get onboardingCompletedAt;
/// Create a copy of Profile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileCopyWith<Profile> get copyWith => _$ProfileCopyWithImpl<Profile>(this as Profile, _$identity);

  /// Serializes this Profile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Profile;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Profile&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.username, _this.username) || other.username == _this.username)&&(identical(other.displayName, _this.displayName) || other.displayName == _this.displayName)&&(identical(other.avatarPath, _this.avatarPath) || other.avatarPath == _this.avatarPath)&&(identical(other.avatarUrl, _this.avatarUrl) || other.avatarUrl == _this.avatarUrl)&&(identical(other.bio, _this.bio) || other.bio == _this.bio)&&(identical(other.weeklyPageGoal, _this.weeklyPageGoal) || other.weeklyPageGoal == _this.weeklyPageGoal)&&(identical(other.defaultVisibility, _this.defaultVisibility) || other.defaultVisibility == _this.defaultVisibility)&&(identical(other.timezone, _this.timezone) || other.timezone == _this.timezone)&&(identical(other.onboardingCompletedAt, _this.onboardingCompletedAt) || other.onboardingCompletedAt == _this.onboardingCompletedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Profile;
  return Object.hash(runtimeType,_this.id,_this.username,_this.displayName,_this.avatarPath,_this.avatarUrl,_this.bio,_this.weeklyPageGoal,_this.defaultVisibility,_this.timezone,_this.onboardingCompletedAt);
}

@override
String toString() {
  final _this = this as Profile;
  return 'Profile(id: ${_this.id}, username: ${_this.username}, displayName: ${_this.displayName}, avatarPath: ${_this.avatarPath}, avatarUrl: ${_this.avatarUrl}, bio: ${_this.bio}, weeklyPageGoal: ${_this.weeklyPageGoal}, defaultVisibility: ${_this.defaultVisibility}, timezone: ${_this.timezone}, onboardingCompletedAt: ${_this.onboardingCompletedAt})';
}


}

/// @nodoc
abstract mixin class $ProfileCopyWith<$Res>  {
  factory $ProfileCopyWith(Profile value, $Res Function(Profile) _then) = _$ProfileCopyWithImpl;
@useResult
$Res call({
 String id, String username, String displayName, String? avatarPath, String? avatarUrl, String? bio, int weeklyPageGoal, Visibility defaultVisibility, String timezone,@TimestampConverter() DateTime? onboardingCompletedAt
});




}
/// @nodoc
class _$ProfileCopyWithImpl<$Res>
    implements $ProfileCopyWith<$Res> {
  _$ProfileCopyWithImpl(this._self, this._then);

  final Profile _self;
  final $Res Function(Profile) _then;

/// Create a copy of Profile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? username = null,Object? displayName = null,Object? avatarPath = freezed,Object? avatarUrl = freezed,Object? bio = freezed,Object? weeklyPageGoal = null,Object? defaultVisibility = null,Object? timezone = null,Object? onboardingCompletedAt = freezed,}) {
  return _then(Profile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,avatarPath: freezed == avatarPath ? _self.avatarPath : avatarPath // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,bio: freezed == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String?,weeklyPageGoal: null == weeklyPageGoal ? _self.weeklyPageGoal : weeklyPageGoal // ignore: cast_nullable_to_non_nullable
as int,defaultVisibility: null == defaultVisibility ? _self.defaultVisibility : defaultVisibility // ignore: cast_nullable_to_non_nullable
as Visibility,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String,onboardingCompletedAt: freezed == onboardingCompletedAt ? _self.onboardingCompletedAt : onboardingCompletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Profile].
extension ProfilePatterns on Profile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Profile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Profile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Profile value)  $default,){
final _that = this;
switch (_that) {
case _Profile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Profile value)?  $default,){
final _that = this;
switch (_that) {
case _Profile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String username,  String displayName,  String? avatarPath,  String? avatarUrl,  String? bio,  int weeklyPageGoal,  Visibility defaultVisibility,  String timezone, @TimestampConverter()  DateTime? onboardingCompletedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Profile() when $default != null:
return $default(_that.id,_that.username,_that.displayName,_that.avatarPath,_that.avatarUrl,_that.bio,_that.weeklyPageGoal,_that.defaultVisibility,_that.timezone,_that.onboardingCompletedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String username,  String displayName,  String? avatarPath,  String? avatarUrl,  String? bio,  int weeklyPageGoal,  Visibility defaultVisibility,  String timezone, @TimestampConverter()  DateTime? onboardingCompletedAt)  $default,) {final _that = this;
switch (_that) {
case _Profile():
return $default(_that.id,_that.username,_that.displayName,_that.avatarPath,_that.avatarUrl,_that.bio,_that.weeklyPageGoal,_that.defaultVisibility,_that.timezone,_that.onboardingCompletedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String username,  String displayName,  String? avatarPath,  String? avatarUrl,  String? bio,  int weeklyPageGoal,  Visibility defaultVisibility,  String timezone, @TimestampConverter()  DateTime? onboardingCompletedAt)?  $default,) {final _that = this;
switch (_that) {
case _Profile() when $default != null:
return $default(_that.id,_that.username,_that.displayName,_that.avatarPath,_that.avatarUrl,_that.bio,_that.weeklyPageGoal,_that.defaultVisibility,_that.timezone,_that.onboardingCompletedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Profile implements Profile {
  const _Profile({required this.id, required this.username, required this.displayName, this.avatarPath, this.avatarUrl, this.bio, this.weeklyPageGoal = 150, this.defaultVisibility = Visibility.followers, this.timezone = 'UTC', @TimestampConverter() this.onboardingCompletedAt});
  factory _Profile.fromJson(Map<String, dynamic> json) => _$ProfileFromJson(json);

@override final  String id;
@override final  String username;
@override final  String displayName;
@override final  String? avatarPath;
@override final  String? avatarUrl;
@override final  String? bio;
@override@JsonKey() final  int weeklyPageGoal;
@override@JsonKey() final  Visibility defaultVisibility;
@override@JsonKey() final  String timezone;
@override@TimestampConverter() final  DateTime? onboardingCompletedAt;

/// Create a copy of Profile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfileCopyWith<_Profile> get copyWith => __$ProfileCopyWithImpl<_Profile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProfileToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Profile&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.avatarPath, avatarPath) || other.avatarPath == avatarPath)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.weeklyPageGoal, weeklyPageGoal) || other.weeklyPageGoal == weeklyPageGoal)&&(identical(other.defaultVisibility, defaultVisibility) || other.defaultVisibility == defaultVisibility)&&(identical(other.timezone, timezone) || other.timezone == timezone)&&(identical(other.onboardingCompletedAt, onboardingCompletedAt) || other.onboardingCompletedAt == onboardingCompletedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,username,displayName,avatarPath,avatarUrl,bio,weeklyPageGoal,defaultVisibility,timezone,onboardingCompletedAt);
}

@override
String toString() {
    return 'Profile(id: $id, username: $username, displayName: $displayName, avatarPath: $avatarPath, avatarUrl: $avatarUrl, bio: $bio, weeklyPageGoal: $weeklyPageGoal, defaultVisibility: $defaultVisibility, timezone: $timezone, onboardingCompletedAt: $onboardingCompletedAt)';
}


}

/// @nodoc
abstract mixin class _$ProfileCopyWith<$Res> implements $ProfileCopyWith<$Res> {
  factory _$ProfileCopyWith(_Profile value, $Res Function(_Profile) _then) = __$ProfileCopyWithImpl;
@override @useResult
$Res call({
 String id, String username, String displayName, String? avatarPath, String? avatarUrl, String? bio, int weeklyPageGoal, Visibility defaultVisibility, String timezone,@TimestampConverter() DateTime? onboardingCompletedAt
});




}
/// @nodoc
class __$ProfileCopyWithImpl<$Res>
    implements _$ProfileCopyWith<$Res> {
  __$ProfileCopyWithImpl(this._self, this._then);

  final _Profile _self;
  final $Res Function(_Profile) _then;

/// Create a copy of Profile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? username = null,Object? displayName = null,Object? avatarPath = freezed,Object? avatarUrl = freezed,Object? bio = freezed,Object? weeklyPageGoal = null,Object? defaultVisibility = null,Object? timezone = null,Object? onboardingCompletedAt = freezed,}) {
  return _then(_Profile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,avatarPath: freezed == avatarPath ? _self.avatarPath : avatarPath // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,bio: freezed == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String?,weeklyPageGoal: null == weeklyPageGoal ? _self.weeklyPageGoal : weeklyPageGoal // ignore: cast_nullable_to_non_nullable
as int,defaultVisibility: null == defaultVisibility ? _self.defaultVisibility : defaultVisibility // ignore: cast_nullable_to_non_nullable
as Visibility,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String,onboardingCompletedAt: freezed == onboardingCompletedAt ? _self.onboardingCompletedAt : onboardingCompletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$Work {

 String get id; String get title; String? get subtitle; List<String> get authors; int? get firstPublishedYear; String? get coverUrl; String? get openLibraryWorkKey;
/// Create a copy of Work
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkCopyWith<Work> get copyWith => _$WorkCopyWithImpl<Work>(this as Work, _$identity);

  /// Serializes this Work to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Work;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Work&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.subtitle, _this.subtitle) || other.subtitle == _this.subtitle)&&const DeepCollectionEquality().equals(other.authors, _this.authors)&&(identical(other.firstPublishedYear, _this.firstPublishedYear) || other.firstPublishedYear == _this.firstPublishedYear)&&(identical(other.coverUrl, _this.coverUrl) || other.coverUrl == _this.coverUrl)&&(identical(other.openLibraryWorkKey, _this.openLibraryWorkKey) || other.openLibraryWorkKey == _this.openLibraryWorkKey));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Work;
  return Object.hash(runtimeType,_this.id,_this.title,_this.subtitle,const DeepCollectionEquality().hash(_this.authors),_this.firstPublishedYear,_this.coverUrl,_this.openLibraryWorkKey);
}

@override
String toString() {
  final _this = this as Work;
  return 'Work(id: ${_this.id}, title: ${_this.title}, subtitle: ${_this.subtitle}, authors: ${_this.authors}, firstPublishedYear: ${_this.firstPublishedYear}, coverUrl: ${_this.coverUrl}, openLibraryWorkKey: ${_this.openLibraryWorkKey})';
}


}

/// @nodoc
abstract mixin class $WorkCopyWith<$Res>  {
  factory $WorkCopyWith(Work value, $Res Function(Work) _then) = _$WorkCopyWithImpl;
@useResult
$Res call({
 String id, String title, String? subtitle, List<String> authors, int? firstPublishedYear, String? coverUrl, String? openLibraryWorkKey
});




}
/// @nodoc
class _$WorkCopyWithImpl<$Res>
    implements $WorkCopyWith<$Res> {
  _$WorkCopyWithImpl(this._self, this._then);

  final Work _self;
  final $Res Function(Work) _then;

/// Create a copy of Work
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? subtitle = freezed,Object? authors = null,Object? firstPublishedYear = freezed,Object? coverUrl = freezed,Object? openLibraryWorkKey = freezed,}) {
  return _then(Work(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,subtitle: freezed == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String?,authors: null == authors ? _self.authors : authors // ignore: cast_nullable_to_non_nullable
as List<String>,firstPublishedYear: freezed == firstPublishedYear ? _self.firstPublishedYear : firstPublishedYear // ignore: cast_nullable_to_non_nullable
as int?,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,openLibraryWorkKey: freezed == openLibraryWorkKey ? _self.openLibraryWorkKey : openLibraryWorkKey // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Work].
extension WorkPatterns on Work {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Work value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Work() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Work value)  $default,){
final _that = this;
switch (_that) {
case _Work():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Work value)?  $default,){
final _that = this;
switch (_that) {
case _Work() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String? subtitle,  List<String> authors,  int? firstPublishedYear,  String? coverUrl,  String? openLibraryWorkKey)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Work() when $default != null:
return $default(_that.id,_that.title,_that.subtitle,_that.authors,_that.firstPublishedYear,_that.coverUrl,_that.openLibraryWorkKey);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String? subtitle,  List<String> authors,  int? firstPublishedYear,  String? coverUrl,  String? openLibraryWorkKey)  $default,) {final _that = this;
switch (_that) {
case _Work():
return $default(_that.id,_that.title,_that.subtitle,_that.authors,_that.firstPublishedYear,_that.coverUrl,_that.openLibraryWorkKey);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String? subtitle,  List<String> authors,  int? firstPublishedYear,  String? coverUrl,  String? openLibraryWorkKey)?  $default,) {final _that = this;
switch (_that) {
case _Work() when $default != null:
return $default(_that.id,_that.title,_that.subtitle,_that.authors,_that.firstPublishedYear,_that.coverUrl,_that.openLibraryWorkKey);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Work implements Work {
  const _Work({required this.id, required this.title, this.subtitle,  List<String> authors = const <String>[], this.firstPublishedYear, this.coverUrl, this.openLibraryWorkKey}): _authors = authors;
  factory _Work.fromJson(Map<String, dynamic> json) => _$WorkFromJson(json);

@override final  String id;
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

/// Create a copy of Work
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkCopyWith<_Work> get copyWith => __$WorkCopyWithImpl<_Work>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorkToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Work&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&const DeepCollectionEquality().equals(other.authors, _authors)&&(identical(other.firstPublishedYear, firstPublishedYear) || other.firstPublishedYear == firstPublishedYear)&&(identical(other.coverUrl, coverUrl) || other.coverUrl == coverUrl)&&(identical(other.openLibraryWorkKey, openLibraryWorkKey) || other.openLibraryWorkKey == openLibraryWorkKey));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,title,subtitle,const DeepCollectionEquality().hash(_authors),firstPublishedYear,coverUrl,openLibraryWorkKey);
}

@override
String toString() {
    return 'Work(id: $id, title: $title, subtitle: $subtitle, authors: $authors, firstPublishedYear: $firstPublishedYear, coverUrl: $coverUrl, openLibraryWorkKey: $openLibraryWorkKey)';
}


}

/// @nodoc
abstract mixin class _$WorkCopyWith<$Res> implements $WorkCopyWith<$Res> {
  factory _$WorkCopyWith(_Work value, $Res Function(_Work) _then) = __$WorkCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String? subtitle, List<String> authors, int? firstPublishedYear, String? coverUrl, String? openLibraryWorkKey
});




}
/// @nodoc
class __$WorkCopyWithImpl<$Res>
    implements _$WorkCopyWith<$Res> {
  __$WorkCopyWithImpl(this._self, this._then);

  final _Work _self;
  final $Res Function(_Work) _then;

/// Create a copy of Work
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? subtitle = freezed,Object? authors = null,Object? firstPublishedYear = freezed,Object? coverUrl = freezed,Object? openLibraryWorkKey = freezed,}) {
  return _then(_Work(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,subtitle: freezed == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String?,authors: null == authors ? _self._authors : authors // ignore: cast_nullable_to_non_nullable
as List<String>,firstPublishedYear: freezed == firstPublishedYear ? _self.firstPublishedYear : firstPublishedYear // ignore: cast_nullable_to_non_nullable
as int?,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,openLibraryWorkKey: freezed == openLibraryWorkKey ? _self.openLibraryWorkKey : openLibraryWorkKey // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$Edition {

 String get id; String get workId; String? get isbn13; String? get isbn10; BookFormat get format; int? get pageCount; String? get publisher; String? get publishedDate; String? get language; String? get coverUrl; BookSource get source;
/// Create a copy of Edition
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EditionCopyWith<Edition> get copyWith => _$EditionCopyWithImpl<Edition>(this as Edition, _$identity);

  /// Serializes this Edition to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Edition;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Edition&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.workId, _this.workId) || other.workId == _this.workId)&&(identical(other.isbn13, _this.isbn13) || other.isbn13 == _this.isbn13)&&(identical(other.isbn10, _this.isbn10) || other.isbn10 == _this.isbn10)&&(identical(other.format, _this.format) || other.format == _this.format)&&(identical(other.pageCount, _this.pageCount) || other.pageCount == _this.pageCount)&&(identical(other.publisher, _this.publisher) || other.publisher == _this.publisher)&&(identical(other.publishedDate, _this.publishedDate) || other.publishedDate == _this.publishedDate)&&(identical(other.language, _this.language) || other.language == _this.language)&&(identical(other.coverUrl, _this.coverUrl) || other.coverUrl == _this.coverUrl)&&(identical(other.source, _this.source) || other.source == _this.source));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Edition;
  return Object.hash(runtimeType,_this.id,_this.workId,_this.isbn13,_this.isbn10,_this.format,_this.pageCount,_this.publisher,_this.publishedDate,_this.language,_this.coverUrl,_this.source);
}

@override
String toString() {
  final _this = this as Edition;
  return 'Edition(id: ${_this.id}, workId: ${_this.workId}, isbn13: ${_this.isbn13}, isbn10: ${_this.isbn10}, format: ${_this.format}, pageCount: ${_this.pageCount}, publisher: ${_this.publisher}, publishedDate: ${_this.publishedDate}, language: ${_this.language}, coverUrl: ${_this.coverUrl}, source: ${_this.source})';
}


}

/// @nodoc
abstract mixin class $EditionCopyWith<$Res>  {
  factory $EditionCopyWith(Edition value, $Res Function(Edition) _then) = _$EditionCopyWithImpl;
@useResult
$Res call({
 String id, String workId, String? isbn13, String? isbn10, BookFormat format, int? pageCount, String? publisher, String? publishedDate, String? language, String? coverUrl, BookSource source
});




}
/// @nodoc
class _$EditionCopyWithImpl<$Res>
    implements $EditionCopyWith<$Res> {
  _$EditionCopyWithImpl(this._self, this._then);

  final Edition _self;
  final $Res Function(Edition) _then;

/// Create a copy of Edition
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? workId = null,Object? isbn13 = freezed,Object? isbn10 = freezed,Object? format = null,Object? pageCount = freezed,Object? publisher = freezed,Object? publishedDate = freezed,Object? language = freezed,Object? coverUrl = freezed,Object? source = null,}) {
  return _then(Edition(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,workId: null == workId ? _self.workId : workId // ignore: cast_nullable_to_non_nullable
as String,isbn13: freezed == isbn13 ? _self.isbn13 : isbn13 // ignore: cast_nullable_to_non_nullable
as String?,isbn10: freezed == isbn10 ? _self.isbn10 : isbn10 // ignore: cast_nullable_to_non_nullable
as String?,format: null == format ? _self.format : format // ignore: cast_nullable_to_non_nullable
as BookFormat,pageCount: freezed == pageCount ? _self.pageCount : pageCount // ignore: cast_nullable_to_non_nullable
as int?,publisher: freezed == publisher ? _self.publisher : publisher // ignore: cast_nullable_to_non_nullable
as String?,publishedDate: freezed == publishedDate ? _self.publishedDate : publishedDate // ignore: cast_nullable_to_non_nullable
as String?,language: freezed == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String?,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as BookSource,
  ));
}

}


/// Adds pattern-matching-related methods to [Edition].
extension EditionPatterns on Edition {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Edition value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Edition() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Edition value)  $default,){
final _that = this;
switch (_that) {
case _Edition():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Edition value)?  $default,){
final _that = this;
switch (_that) {
case _Edition() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String workId,  String? isbn13,  String? isbn10,  BookFormat format,  int? pageCount,  String? publisher,  String? publishedDate,  String? language,  String? coverUrl,  BookSource source)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Edition() when $default != null:
return $default(_that.id,_that.workId,_that.isbn13,_that.isbn10,_that.format,_that.pageCount,_that.publisher,_that.publishedDate,_that.language,_that.coverUrl,_that.source);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String workId,  String? isbn13,  String? isbn10,  BookFormat format,  int? pageCount,  String? publisher,  String? publishedDate,  String? language,  String? coverUrl,  BookSource source)  $default,) {final _that = this;
switch (_that) {
case _Edition():
return $default(_that.id,_that.workId,_that.isbn13,_that.isbn10,_that.format,_that.pageCount,_that.publisher,_that.publishedDate,_that.language,_that.coverUrl,_that.source);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String workId,  String? isbn13,  String? isbn10,  BookFormat format,  int? pageCount,  String? publisher,  String? publishedDate,  String? language,  String? coverUrl,  BookSource source)?  $default,) {final _that = this;
switch (_that) {
case _Edition() when $default != null:
return $default(_that.id,_that.workId,_that.isbn13,_that.isbn10,_that.format,_that.pageCount,_that.publisher,_that.publishedDate,_that.language,_that.coverUrl,_that.source);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Edition implements Edition {
  const _Edition({required this.id, required this.workId, this.isbn13, this.isbn10, this.format = BookFormat.print, this.pageCount, this.publisher, this.publishedDate, this.language, this.coverUrl, required this.source});
  factory _Edition.fromJson(Map<String, dynamic> json) => _$EditionFromJson(json);

@override final  String id;
@override final  String workId;
@override final  String? isbn13;
@override final  String? isbn10;
@override@JsonKey() final  BookFormat format;
@override final  int? pageCount;
@override final  String? publisher;
@override final  String? publishedDate;
@override final  String? language;
@override final  String? coverUrl;
@override final  BookSource source;

/// Create a copy of Edition
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EditionCopyWith<_Edition> get copyWith => __$EditionCopyWithImpl<_Edition>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EditionToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Edition&&(identical(other.id, id) || other.id == id)&&(identical(other.workId, workId) || other.workId == workId)&&(identical(other.isbn13, isbn13) || other.isbn13 == isbn13)&&(identical(other.isbn10, isbn10) || other.isbn10 == isbn10)&&(identical(other.format, format) || other.format == format)&&(identical(other.pageCount, pageCount) || other.pageCount == pageCount)&&(identical(other.publisher, publisher) || other.publisher == publisher)&&(identical(other.publishedDate, publishedDate) || other.publishedDate == publishedDate)&&(identical(other.language, language) || other.language == language)&&(identical(other.coverUrl, coverUrl) || other.coverUrl == coverUrl)&&(identical(other.source, source) || other.source == source));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,workId,isbn13,isbn10,format,pageCount,publisher,publishedDate,language,coverUrl,source);
}

@override
String toString() {
    return 'Edition(id: $id, workId: $workId, isbn13: $isbn13, isbn10: $isbn10, format: $format, pageCount: $pageCount, publisher: $publisher, publishedDate: $publishedDate, language: $language, coverUrl: $coverUrl, source: $source)';
}


}

/// @nodoc
abstract mixin class _$EditionCopyWith<$Res> implements $EditionCopyWith<$Res> {
  factory _$EditionCopyWith(_Edition value, $Res Function(_Edition) _then) = __$EditionCopyWithImpl;
@override @useResult
$Res call({
 String id, String workId, String? isbn13, String? isbn10, BookFormat format, int? pageCount, String? publisher, String? publishedDate, String? language, String? coverUrl, BookSource source
});




}
/// @nodoc
class __$EditionCopyWithImpl<$Res>
    implements _$EditionCopyWith<$Res> {
  __$EditionCopyWithImpl(this._self, this._then);

  final _Edition _self;
  final $Res Function(_Edition) _then;

/// Create a copy of Edition
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? workId = null,Object? isbn13 = freezed,Object? isbn10 = freezed,Object? format = null,Object? pageCount = freezed,Object? publisher = freezed,Object? publishedDate = freezed,Object? language = freezed,Object? coverUrl = freezed,Object? source = null,}) {
  return _then(_Edition(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,workId: null == workId ? _self.workId : workId // ignore: cast_nullable_to_non_nullable
as String,isbn13: freezed == isbn13 ? _self.isbn13 : isbn13 // ignore: cast_nullable_to_non_nullable
as String?,isbn10: freezed == isbn10 ? _self.isbn10 : isbn10 // ignore: cast_nullable_to_non_nullable
as String?,format: null == format ? _self.format : format // ignore: cast_nullable_to_non_nullable
as BookFormat,pageCount: freezed == pageCount ? _self.pageCount : pageCount // ignore: cast_nullable_to_non_nullable
as int?,publisher: freezed == publisher ? _self.publisher : publisher // ignore: cast_nullable_to_non_nullable
as String?,publishedDate: freezed == publishedDate ? _self.publishedDate : publishedDate // ignore: cast_nullable_to_non_nullable
as String?,language: freezed == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String?,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as BookSource,
  ));
}


}


/// @nodoc
mixin _$UserBook {

 String get id; String get userId; String get workId; String? get editionId; int? get pageCountOverride; Shelf get shelf; int get currentPage;/// Local calendar dates, `yyyy-MM-dd`.
 String? get startedAt; String? get finishedAt; double? get rating; String? get reviewLine; String get source;@TimestampConverter() DateTime? get updatedAt;
/// Create a copy of UserBook
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserBookCopyWith<UserBook> get copyWith => _$UserBookCopyWithImpl<UserBook>(this as UserBook, _$identity);

  /// Serializes this UserBook to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as UserBook;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserBook&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.workId, _this.workId) || other.workId == _this.workId)&&(identical(other.editionId, _this.editionId) || other.editionId == _this.editionId)&&(identical(other.pageCountOverride, _this.pageCountOverride) || other.pageCountOverride == _this.pageCountOverride)&&(identical(other.shelf, _this.shelf) || other.shelf == _this.shelf)&&(identical(other.currentPage, _this.currentPage) || other.currentPage == _this.currentPage)&&(identical(other.startedAt, _this.startedAt) || other.startedAt == _this.startedAt)&&(identical(other.finishedAt, _this.finishedAt) || other.finishedAt == _this.finishedAt)&&(identical(other.rating, _this.rating) || other.rating == _this.rating)&&(identical(other.reviewLine, _this.reviewLine) || other.reviewLine == _this.reviewLine)&&(identical(other.source, _this.source) || other.source == _this.source)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as UserBook;
  return Object.hash(runtimeType,_this.id,_this.userId,_this.workId,_this.editionId,_this.pageCountOverride,_this.shelf,_this.currentPage,_this.startedAt,_this.finishedAt,_this.rating,_this.reviewLine,_this.source,_this.updatedAt);
}

@override
String toString() {
  final _this = this as UserBook;
  return 'UserBook(id: ${_this.id}, userId: ${_this.userId}, workId: ${_this.workId}, editionId: ${_this.editionId}, pageCountOverride: ${_this.pageCountOverride}, shelf: ${_this.shelf}, currentPage: ${_this.currentPage}, startedAt: ${_this.startedAt}, finishedAt: ${_this.finishedAt}, rating: ${_this.rating}, reviewLine: ${_this.reviewLine}, source: ${_this.source}, updatedAt: ${_this.updatedAt})';
}


}

/// @nodoc
abstract mixin class $UserBookCopyWith<$Res>  {
  factory $UserBookCopyWith(UserBook value, $Res Function(UserBook) _then) = _$UserBookCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String workId, String? editionId, int? pageCountOverride, Shelf shelf, int currentPage, String? startedAt, String? finishedAt, double? rating, String? reviewLine, String source,@TimestampConverter() DateTime? updatedAt
});




}
/// @nodoc
class _$UserBookCopyWithImpl<$Res>
    implements $UserBookCopyWith<$Res> {
  _$UserBookCopyWithImpl(this._self, this._then);

  final UserBook _self;
  final $Res Function(UserBook) _then;

/// Create a copy of UserBook
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? workId = null,Object? editionId = freezed,Object? pageCountOverride = freezed,Object? shelf = null,Object? currentPage = null,Object? startedAt = freezed,Object? finishedAt = freezed,Object? rating = freezed,Object? reviewLine = freezed,Object? source = null,Object? updatedAt = freezed,}) {
  return _then(UserBook(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,workId: null == workId ? _self.workId : workId // ignore: cast_nullable_to_non_nullable
as String,editionId: freezed == editionId ? _self.editionId : editionId // ignore: cast_nullable_to_non_nullable
as String?,pageCountOverride: freezed == pageCountOverride ? _self.pageCountOverride : pageCountOverride // ignore: cast_nullable_to_non_nullable
as int?,shelf: null == shelf ? _self.shelf : shelf // ignore: cast_nullable_to_non_nullable
as Shelf,currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as String?,finishedAt: freezed == finishedAt ? _self.finishedAt : finishedAt // ignore: cast_nullable_to_non_nullable
as String?,rating: freezed == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double?,reviewLine: freezed == reviewLine ? _self.reviewLine : reviewLine // ignore: cast_nullable_to_non_nullable
as String?,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [UserBook].
extension UserBookPatterns on UserBook {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserBook value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserBook() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserBook value)  $default,){
final _that = this;
switch (_that) {
case _UserBook():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserBook value)?  $default,){
final _that = this;
switch (_that) {
case _UserBook() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String workId,  String? editionId,  int? pageCountOverride,  Shelf shelf,  int currentPage,  String? startedAt,  String? finishedAt,  double? rating,  String? reviewLine,  String source, @TimestampConverter()  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserBook() when $default != null:
return $default(_that.id,_that.userId,_that.workId,_that.editionId,_that.pageCountOverride,_that.shelf,_that.currentPage,_that.startedAt,_that.finishedAt,_that.rating,_that.reviewLine,_that.source,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String workId,  String? editionId,  int? pageCountOverride,  Shelf shelf,  int currentPage,  String? startedAt,  String? finishedAt,  double? rating,  String? reviewLine,  String source, @TimestampConverter()  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _UserBook():
return $default(_that.id,_that.userId,_that.workId,_that.editionId,_that.pageCountOverride,_that.shelf,_that.currentPage,_that.startedAt,_that.finishedAt,_that.rating,_that.reviewLine,_that.source,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String workId,  String? editionId,  int? pageCountOverride,  Shelf shelf,  int currentPage,  String? startedAt,  String? finishedAt,  double? rating,  String? reviewLine,  String source, @TimestampConverter()  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _UserBook() when $default != null:
return $default(_that.id,_that.userId,_that.workId,_that.editionId,_that.pageCountOverride,_that.shelf,_that.currentPage,_that.startedAt,_that.finishedAt,_that.rating,_that.reviewLine,_that.source,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserBook extends UserBook {
  const _UserBook({required this.id, required this.userId, required this.workId, this.editionId, this.pageCountOverride, required this.shelf, this.currentPage = 0, this.startedAt, this.finishedAt, this.rating, this.reviewLine, this.source = 'app', @TimestampConverter() this.updatedAt}): super._();
  factory _UserBook.fromJson(Map<String, dynamic> json) => _$UserBookFromJson(json);

@override final  String id;
@override final  String userId;
@override final  String workId;
@override final  String? editionId;
@override final  int? pageCountOverride;
@override final  Shelf shelf;
@override@JsonKey() final  int currentPage;
/// Local calendar dates, `yyyy-MM-dd`.
@override final  String? startedAt;
@override final  String? finishedAt;
@override final  double? rating;
@override final  String? reviewLine;
@override@JsonKey() final  String source;
@override@TimestampConverter() final  DateTime? updatedAt;

/// Create a copy of UserBook
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserBookCopyWith<_UserBook> get copyWith => __$UserBookCopyWithImpl<_UserBook>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserBookToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserBook&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.workId, workId) || other.workId == workId)&&(identical(other.editionId, editionId) || other.editionId == editionId)&&(identical(other.pageCountOverride, pageCountOverride) || other.pageCountOverride == pageCountOverride)&&(identical(other.shelf, shelf) || other.shelf == shelf)&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.finishedAt, finishedAt) || other.finishedAt == finishedAt)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.reviewLine, reviewLine) || other.reviewLine == reviewLine)&&(identical(other.source, source) || other.source == source)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,userId,workId,editionId,pageCountOverride,shelf,currentPage,startedAt,finishedAt,rating,reviewLine,source,updatedAt);
}

@override
String toString() {
    return 'UserBook(id: $id, userId: $userId, workId: $workId, editionId: $editionId, pageCountOverride: $pageCountOverride, shelf: $shelf, currentPage: $currentPage, startedAt: $startedAt, finishedAt: $finishedAt, rating: $rating, reviewLine: $reviewLine, source: $source, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$UserBookCopyWith<$Res> implements $UserBookCopyWith<$Res> {
  factory _$UserBookCopyWith(_UserBook value, $Res Function(_UserBook) _then) = __$UserBookCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String workId, String? editionId, int? pageCountOverride, Shelf shelf, int currentPage, String? startedAt, String? finishedAt, double? rating, String? reviewLine, String source,@TimestampConverter() DateTime? updatedAt
});




}
/// @nodoc
class __$UserBookCopyWithImpl<$Res>
    implements _$UserBookCopyWith<$Res> {
  __$UserBookCopyWithImpl(this._self, this._then);

  final _UserBook _self;
  final $Res Function(_UserBook) _then;

/// Create a copy of UserBook
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? workId = null,Object? editionId = freezed,Object? pageCountOverride = freezed,Object? shelf = null,Object? currentPage = null,Object? startedAt = freezed,Object? finishedAt = freezed,Object? rating = freezed,Object? reviewLine = freezed,Object? source = null,Object? updatedAt = freezed,}) {
  return _then(_UserBook(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,workId: null == workId ? _self.workId : workId // ignore: cast_nullable_to_non_nullable
as String,editionId: freezed == editionId ? _self.editionId : editionId // ignore: cast_nullable_to_non_nullable
as String?,pageCountOverride: freezed == pageCountOverride ? _self.pageCountOverride : pageCountOverride // ignore: cast_nullable_to_non_nullable
as int?,shelf: null == shelf ? _self.shelf : shelf // ignore: cast_nullable_to_non_nullable
as Shelf,currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as String?,finishedAt: freezed == finishedAt ? _self.finishedAt : finishedAt // ignore: cast_nullable_to_non_nullable
as String?,rating: freezed == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double?,reviewLine: freezed == reviewLine ? _self.reviewLine : reviewLine // ignore: cast_nullable_to_non_nullable
as String?,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

/// @nodoc
mixin _$ShelvedBook {

 UserBook get userBook; Work get work; Edition? get edition;
/// Create a copy of ShelvedBook
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShelvedBookCopyWith<ShelvedBook> get copyWith => _$ShelvedBookCopyWithImpl<ShelvedBook>(this as ShelvedBook, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ShelvedBook;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShelvedBook&&(identical(other.userBook, _this.userBook) || other.userBook == _this.userBook)&&(identical(other.work, _this.work) || other.work == _this.work)&&(identical(other.edition, _this.edition) || other.edition == _this.edition));
}


@override
int get hashCode {
  final _this = this as ShelvedBook;
  return Object.hash(runtimeType,_this.userBook,_this.work,_this.edition);
}

@override
String toString() {
  final _this = this as ShelvedBook;
  return 'ShelvedBook(userBook: ${_this.userBook}, work: ${_this.work}, edition: ${_this.edition})';
}


}

/// @nodoc
abstract mixin class $ShelvedBookCopyWith<$Res>  {
  factory $ShelvedBookCopyWith(ShelvedBook value, $Res Function(ShelvedBook) _then) = _$ShelvedBookCopyWithImpl;
@useResult
$Res call({
 UserBook userBook, Work work, Edition? edition
});


$UserBookCopyWith<$Res> get userBook;$WorkCopyWith<$Res> get work;$EditionCopyWith<$Res>? get edition;

}
/// @nodoc
class _$ShelvedBookCopyWithImpl<$Res>
    implements $ShelvedBookCopyWith<$Res> {
  _$ShelvedBookCopyWithImpl(this._self, this._then);

  final ShelvedBook _self;
  final $Res Function(ShelvedBook) _then;

/// Create a copy of ShelvedBook
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userBook = null,Object? work = null,Object? edition = freezed,}) {
  return _then(ShelvedBook(
userBook: null == userBook ? _self.userBook : userBook // ignore: cast_nullable_to_non_nullable
as UserBook,work: null == work ? _self.work : work // ignore: cast_nullable_to_non_nullable
as Work,edition: freezed == edition ? _self.edition : edition // ignore: cast_nullable_to_non_nullable
as Edition?,
  ));
}
/// Create a copy of ShelvedBook
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserBookCopyWith<$Res> get userBook {
  
  return $UserBookCopyWith<$Res>(_self.userBook, (value) {
    return _then(_self.copyWith(userBook: value));
  });
}/// Create a copy of ShelvedBook
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WorkCopyWith<$Res> get work {
  
  return $WorkCopyWith<$Res>(_self.work, (value) {
    return _then(_self.copyWith(work: value));
  });
}/// Create a copy of ShelvedBook
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EditionCopyWith<$Res>? get edition {
    if (_self.edition == null) {
    return null;
  }

  return $EditionCopyWith<$Res>(_self.edition!, (value) {
    return _then(_self.copyWith(edition: value));
  });
}
}


/// Adds pattern-matching-related methods to [ShelvedBook].
extension ShelvedBookPatterns on ShelvedBook {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ShelvedBook value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ShelvedBook() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ShelvedBook value)  $default,){
final _that = this;
switch (_that) {
case _ShelvedBook():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ShelvedBook value)?  $default,){
final _that = this;
switch (_that) {
case _ShelvedBook() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( UserBook userBook,  Work work,  Edition? edition)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ShelvedBook() when $default != null:
return $default(_that.userBook,_that.work,_that.edition);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( UserBook userBook,  Work work,  Edition? edition)  $default,) {final _that = this;
switch (_that) {
case _ShelvedBook():
return $default(_that.userBook,_that.work,_that.edition);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( UserBook userBook,  Work work,  Edition? edition)?  $default,) {final _that = this;
switch (_that) {
case _ShelvedBook() when $default != null:
return $default(_that.userBook,_that.work,_that.edition);case _:
  return null;

}
}

}

/// @nodoc


class _ShelvedBook extends ShelvedBook {
  const _ShelvedBook({required this.userBook, required this.work, this.edition}): super._();
  

@override final  UserBook userBook;
@override final  Work work;
@override final  Edition? edition;

/// Create a copy of ShelvedBook
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ShelvedBookCopyWith<_ShelvedBook> get copyWith => __$ShelvedBookCopyWithImpl<_ShelvedBook>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ShelvedBook&&(identical(other.userBook, userBook) || other.userBook == userBook)&&(identical(other.work, work) || other.work == work)&&(identical(other.edition, edition) || other.edition == edition));
}


@override
int get hashCode {
    return Object.hash(runtimeType,userBook,work,edition);
}

@override
String toString() {
    return 'ShelvedBook(userBook: $userBook, work: $work, edition: $edition)';
}


}

/// @nodoc
abstract mixin class _$ShelvedBookCopyWith<$Res> implements $ShelvedBookCopyWith<$Res> {
  factory _$ShelvedBookCopyWith(_ShelvedBook value, $Res Function(_ShelvedBook) _then) = __$ShelvedBookCopyWithImpl;
@override @useResult
$Res call({
 UserBook userBook, Work work, Edition? edition
});


@override $UserBookCopyWith<$Res> get userBook;@override $WorkCopyWith<$Res> get work;@override $EditionCopyWith<$Res>? get edition;

}
/// @nodoc
class __$ShelvedBookCopyWithImpl<$Res>
    implements _$ShelvedBookCopyWith<$Res> {
  __$ShelvedBookCopyWithImpl(this._self, this._then);

  final _ShelvedBook _self;
  final $Res Function(_ShelvedBook) _then;

/// Create a copy of ShelvedBook
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userBook = null,Object? work = null,Object? edition = freezed,}) {
  return _then(_ShelvedBook(
userBook: null == userBook ? _self.userBook : userBook // ignore: cast_nullable_to_non_nullable
as UserBook,work: null == work ? _self.work : work // ignore: cast_nullable_to_non_nullable
as Work,edition: freezed == edition ? _self.edition : edition // ignore: cast_nullable_to_non_nullable
as Edition?,
  ));
}

/// Create a copy of ShelvedBook
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserBookCopyWith<$Res> get userBook {
  
  return $UserBookCopyWith<$Res>(_self.userBook, (value) {
    return _then(_self.copyWith(userBook: value));
  });
}/// Create a copy of ShelvedBook
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WorkCopyWith<$Res> get work {
  
  return $WorkCopyWith<$Res>(_self.work, (value) {
    return _then(_self.copyWith(work: value));
  });
}/// Create a copy of ShelvedBook
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EditionCopyWith<$Res>? get edition {
    if (_self.edition == null) {
    return null;
  }

  return $EditionCopyWith<$Res>(_self.edition!, (value) {
    return _then(_self.copyWith(edition: value));
  });
}
}

// dart format on
