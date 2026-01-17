// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'question_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$QuestionModel {

 int get id; String get title; String get content;@JsonKey(name: 'created_at') DateTime get createdAt;@JsonKey(name: 'question_priority') String? get priority;// 'high', 'medium', 'low'
// Nested User Object (Author)
// React: question.question_author.username -> `question_author`
@JsonKey(name: 'question_author') UserModel? get author;// Nested User Object (Current Handler - Advisor)
@JsonKey(name: 'question_current_handler') UserModel? get currentHandler;// Nested Course Object
// React: question.course_details.title
@JsonKey(name: 'course_details') CourseDetails? get courseDetails;// Nested Class Term Details
@JsonKey(name: 'class_term_details') ClassTermDetails? get classTermDetails;// Answers List
 List<AnswerModel> get answers;
/// Create a copy of QuestionModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuestionModelCopyWith<QuestionModel> get copyWith => _$QuestionModelCopyWithImpl<QuestionModel>(this as QuestionModel, _$identity);

  /// Serializes this QuestionModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuestionModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.author, author) || other.author == author)&&(identical(other.currentHandler, currentHandler) || other.currentHandler == currentHandler)&&(identical(other.courseDetails, courseDetails) || other.courseDetails == courseDetails)&&(identical(other.classTermDetails, classTermDetails) || other.classTermDetails == classTermDetails)&&const DeepCollectionEquality().equals(other.answers, answers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,content,createdAt,priority,author,currentHandler,courseDetails,classTermDetails,const DeepCollectionEquality().hash(answers));

@override
String toString() {
  return 'QuestionModel(id: $id, title: $title, content: $content, createdAt: $createdAt, priority: $priority, author: $author, currentHandler: $currentHandler, courseDetails: $courseDetails, classTermDetails: $classTermDetails, answers: $answers)';
}


}

/// @nodoc
abstract mixin class $QuestionModelCopyWith<$Res>  {
  factory $QuestionModelCopyWith(QuestionModel value, $Res Function(QuestionModel) _then) = _$QuestionModelCopyWithImpl;
@useResult
$Res call({
 int id, String title, String content,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'question_priority') String? priority,@JsonKey(name: 'question_author') UserModel? author,@JsonKey(name: 'question_current_handler') UserModel? currentHandler,@JsonKey(name: 'course_details') CourseDetails? courseDetails,@JsonKey(name: 'class_term_details') ClassTermDetails? classTermDetails, List<AnswerModel> answers
});


$UserModelCopyWith<$Res>? get author;$UserModelCopyWith<$Res>? get currentHandler;$CourseDetailsCopyWith<$Res>? get courseDetails;$ClassTermDetailsCopyWith<$Res>? get classTermDetails;

}
/// @nodoc
class _$QuestionModelCopyWithImpl<$Res>
    implements $QuestionModelCopyWith<$Res> {
  _$QuestionModelCopyWithImpl(this._self, this._then);

  final QuestionModel _self;
  final $Res Function(QuestionModel) _then;

/// Create a copy of QuestionModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? content = null,Object? createdAt = null,Object? priority = freezed,Object? author = freezed,Object? currentHandler = freezed,Object? courseDetails = freezed,Object? classTermDetails = freezed,Object? answers = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,priority: freezed == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as String?,author: freezed == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as UserModel?,currentHandler: freezed == currentHandler ? _self.currentHandler : currentHandler // ignore: cast_nullable_to_non_nullable
as UserModel?,courseDetails: freezed == courseDetails ? _self.courseDetails : courseDetails // ignore: cast_nullable_to_non_nullable
as CourseDetails?,classTermDetails: freezed == classTermDetails ? _self.classTermDetails : classTermDetails // ignore: cast_nullable_to_non_nullable
as ClassTermDetails?,answers: null == answers ? _self.answers : answers // ignore: cast_nullable_to_non_nullable
as List<AnswerModel>,
  ));
}
/// Create a copy of QuestionModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserModelCopyWith<$Res>? get author {
    if (_self.author == null) {
    return null;
  }

  return $UserModelCopyWith<$Res>(_self.author!, (value) {
    return _then(_self.copyWith(author: value));
  });
}/// Create a copy of QuestionModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserModelCopyWith<$Res>? get currentHandler {
    if (_self.currentHandler == null) {
    return null;
  }

  return $UserModelCopyWith<$Res>(_self.currentHandler!, (value) {
    return _then(_self.copyWith(currentHandler: value));
  });
}/// Create a copy of QuestionModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CourseDetailsCopyWith<$Res>? get courseDetails {
    if (_self.courseDetails == null) {
    return null;
  }

  return $CourseDetailsCopyWith<$Res>(_self.courseDetails!, (value) {
    return _then(_self.copyWith(courseDetails: value));
  });
}/// Create a copy of QuestionModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ClassTermDetailsCopyWith<$Res>? get classTermDetails {
    if (_self.classTermDetails == null) {
    return null;
  }

  return $ClassTermDetailsCopyWith<$Res>(_self.classTermDetails!, (value) {
    return _then(_self.copyWith(classTermDetails: value));
  });
}
}


/// Adds pattern-matching-related methods to [QuestionModel].
extension QuestionModelPatterns on QuestionModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuestionModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuestionModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuestionModel value)  $default,){
final _that = this;
switch (_that) {
case _QuestionModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuestionModel value)?  $default,){
final _that = this;
switch (_that) {
case _QuestionModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String title,  String content, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'question_priority')  String? priority, @JsonKey(name: 'question_author')  UserModel? author, @JsonKey(name: 'question_current_handler')  UserModel? currentHandler, @JsonKey(name: 'course_details')  CourseDetails? courseDetails, @JsonKey(name: 'class_term_details')  ClassTermDetails? classTermDetails,  List<AnswerModel> answers)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuestionModel() when $default != null:
return $default(_that.id,_that.title,_that.content,_that.createdAt,_that.priority,_that.author,_that.currentHandler,_that.courseDetails,_that.classTermDetails,_that.answers);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String title,  String content, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'question_priority')  String? priority, @JsonKey(name: 'question_author')  UserModel? author, @JsonKey(name: 'question_current_handler')  UserModel? currentHandler, @JsonKey(name: 'course_details')  CourseDetails? courseDetails, @JsonKey(name: 'class_term_details')  ClassTermDetails? classTermDetails,  List<AnswerModel> answers)  $default,) {final _that = this;
switch (_that) {
case _QuestionModel():
return $default(_that.id,_that.title,_that.content,_that.createdAt,_that.priority,_that.author,_that.currentHandler,_that.courseDetails,_that.classTermDetails,_that.answers);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String title,  String content, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'question_priority')  String? priority, @JsonKey(name: 'question_author')  UserModel? author, @JsonKey(name: 'question_current_handler')  UserModel? currentHandler, @JsonKey(name: 'course_details')  CourseDetails? courseDetails, @JsonKey(name: 'class_term_details')  ClassTermDetails? classTermDetails,  List<AnswerModel> answers)?  $default,) {final _that = this;
switch (_that) {
case _QuestionModel() when $default != null:
return $default(_that.id,_that.title,_that.content,_that.createdAt,_that.priority,_that.author,_that.currentHandler,_that.courseDetails,_that.classTermDetails,_that.answers);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QuestionModel implements QuestionModel {
  const _QuestionModel({required this.id, required this.title, required this.content, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'question_priority') this.priority, @JsonKey(name: 'question_author') this.author, @JsonKey(name: 'question_current_handler') this.currentHandler, @JsonKey(name: 'course_details') this.courseDetails, @JsonKey(name: 'class_term_details') this.classTermDetails, final  List<AnswerModel> answers = const []}): _answers = answers;
  factory _QuestionModel.fromJson(Map<String, dynamic> json) => _$QuestionModelFromJson(json);

@override final  int id;
@override final  String title;
@override final  String content;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;
@override@JsonKey(name: 'question_priority') final  String? priority;
// 'high', 'medium', 'low'
// Nested User Object (Author)
// React: question.question_author.username -> `question_author`
@override@JsonKey(name: 'question_author') final  UserModel? author;
// Nested User Object (Current Handler - Advisor)
@override@JsonKey(name: 'question_current_handler') final  UserModel? currentHandler;
// Nested Course Object
// React: question.course_details.title
@override@JsonKey(name: 'course_details') final  CourseDetails? courseDetails;
// Nested Class Term Details
@override@JsonKey(name: 'class_term_details') final  ClassTermDetails? classTermDetails;
// Answers List
 final  List<AnswerModel> _answers;
// Answers List
@override@JsonKey() List<AnswerModel> get answers {
  if (_answers is EqualUnmodifiableListView) return _answers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_answers);
}


/// Create a copy of QuestionModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuestionModelCopyWith<_QuestionModel> get copyWith => __$QuestionModelCopyWithImpl<_QuestionModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuestionModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuestionModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.author, author) || other.author == author)&&(identical(other.currentHandler, currentHandler) || other.currentHandler == currentHandler)&&(identical(other.courseDetails, courseDetails) || other.courseDetails == courseDetails)&&(identical(other.classTermDetails, classTermDetails) || other.classTermDetails == classTermDetails)&&const DeepCollectionEquality().equals(other._answers, _answers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,content,createdAt,priority,author,currentHandler,courseDetails,classTermDetails,const DeepCollectionEquality().hash(_answers));

@override
String toString() {
  return 'QuestionModel(id: $id, title: $title, content: $content, createdAt: $createdAt, priority: $priority, author: $author, currentHandler: $currentHandler, courseDetails: $courseDetails, classTermDetails: $classTermDetails, answers: $answers)';
}


}

/// @nodoc
abstract mixin class _$QuestionModelCopyWith<$Res> implements $QuestionModelCopyWith<$Res> {
  factory _$QuestionModelCopyWith(_QuestionModel value, $Res Function(_QuestionModel) _then) = __$QuestionModelCopyWithImpl;
@override @useResult
$Res call({
 int id, String title, String content,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'question_priority') String? priority,@JsonKey(name: 'question_author') UserModel? author,@JsonKey(name: 'question_current_handler') UserModel? currentHandler,@JsonKey(name: 'course_details') CourseDetails? courseDetails,@JsonKey(name: 'class_term_details') ClassTermDetails? classTermDetails, List<AnswerModel> answers
});


@override $UserModelCopyWith<$Res>? get author;@override $UserModelCopyWith<$Res>? get currentHandler;@override $CourseDetailsCopyWith<$Res>? get courseDetails;@override $ClassTermDetailsCopyWith<$Res>? get classTermDetails;

}
/// @nodoc
class __$QuestionModelCopyWithImpl<$Res>
    implements _$QuestionModelCopyWith<$Res> {
  __$QuestionModelCopyWithImpl(this._self, this._then);

  final _QuestionModel _self;
  final $Res Function(_QuestionModel) _then;

/// Create a copy of QuestionModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? content = null,Object? createdAt = null,Object? priority = freezed,Object? author = freezed,Object? currentHandler = freezed,Object? courseDetails = freezed,Object? classTermDetails = freezed,Object? answers = null,}) {
  return _then(_QuestionModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,priority: freezed == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as String?,author: freezed == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as UserModel?,currentHandler: freezed == currentHandler ? _self.currentHandler : currentHandler // ignore: cast_nullable_to_non_nullable
as UserModel?,courseDetails: freezed == courseDetails ? _self.courseDetails : courseDetails // ignore: cast_nullable_to_non_nullable
as CourseDetails?,classTermDetails: freezed == classTermDetails ? _self.classTermDetails : classTermDetails // ignore: cast_nullable_to_non_nullable
as ClassTermDetails?,answers: null == answers ? _self._answers : answers // ignore: cast_nullable_to_non_nullable
as List<AnswerModel>,
  ));
}

/// Create a copy of QuestionModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserModelCopyWith<$Res>? get author {
    if (_self.author == null) {
    return null;
  }

  return $UserModelCopyWith<$Res>(_self.author!, (value) {
    return _then(_self.copyWith(author: value));
  });
}/// Create a copy of QuestionModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserModelCopyWith<$Res>? get currentHandler {
    if (_self.currentHandler == null) {
    return null;
  }

  return $UserModelCopyWith<$Res>(_self.currentHandler!, (value) {
    return _then(_self.copyWith(currentHandler: value));
  });
}/// Create a copy of QuestionModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CourseDetailsCopyWith<$Res>? get courseDetails {
    if (_self.courseDetails == null) {
    return null;
  }

  return $CourseDetailsCopyWith<$Res>(_self.courseDetails!, (value) {
    return _then(_self.copyWith(courseDetails: value));
  });
}/// Create a copy of QuestionModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ClassTermDetailsCopyWith<$Res>? get classTermDetails {
    if (_self.classTermDetails == null) {
    return null;
  }

  return $ClassTermDetailsCopyWith<$Res>(_self.classTermDetails!, (value) {
    return _then(_self.copyWith(classTermDetails: value));
  });
}
}


/// @nodoc
mixin _$AnswerModel {

 int get id; String get content;@JsonKey(name: 'created_at') DateTime get createdAt; UserModel get author;
/// Create a copy of AnswerModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnswerModelCopyWith<AnswerModel> get copyWith => _$AnswerModelCopyWithImpl<AnswerModel>(this as AnswerModel, _$identity);

  /// Serializes this AnswerModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnswerModel&&(identical(other.id, id) || other.id == id)&&(identical(other.content, content) || other.content == content)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.author, author) || other.author == author));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,content,createdAt,author);

@override
String toString() {
  return 'AnswerModel(id: $id, content: $content, createdAt: $createdAt, author: $author)';
}


}

/// @nodoc
abstract mixin class $AnswerModelCopyWith<$Res>  {
  factory $AnswerModelCopyWith(AnswerModel value, $Res Function(AnswerModel) _then) = _$AnswerModelCopyWithImpl;
@useResult
$Res call({
 int id, String content,@JsonKey(name: 'created_at') DateTime createdAt, UserModel author
});


$UserModelCopyWith<$Res> get author;

}
/// @nodoc
class _$AnswerModelCopyWithImpl<$Res>
    implements $AnswerModelCopyWith<$Res> {
  _$AnswerModelCopyWithImpl(this._self, this._then);

  final AnswerModel _self;
  final $Res Function(AnswerModel) _then;

/// Create a copy of AnswerModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? content = null,Object? createdAt = null,Object? author = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as UserModel,
  ));
}
/// Create a copy of AnswerModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserModelCopyWith<$Res> get author {
  
  return $UserModelCopyWith<$Res>(_self.author, (value) {
    return _then(_self.copyWith(author: value));
  });
}
}


/// Adds pattern-matching-related methods to [AnswerModel].
extension AnswerModelPatterns on AnswerModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AnswerModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AnswerModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AnswerModel value)  $default,){
final _that = this;
switch (_that) {
case _AnswerModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AnswerModel value)?  $default,){
final _that = this;
switch (_that) {
case _AnswerModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String content, @JsonKey(name: 'created_at')  DateTime createdAt,  UserModel author)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AnswerModel() when $default != null:
return $default(_that.id,_that.content,_that.createdAt,_that.author);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String content, @JsonKey(name: 'created_at')  DateTime createdAt,  UserModel author)  $default,) {final _that = this;
switch (_that) {
case _AnswerModel():
return $default(_that.id,_that.content,_that.createdAt,_that.author);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String content, @JsonKey(name: 'created_at')  DateTime createdAt,  UserModel author)?  $default,) {final _that = this;
switch (_that) {
case _AnswerModel() when $default != null:
return $default(_that.id,_that.content,_that.createdAt,_that.author);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AnswerModel implements AnswerModel {
  const _AnswerModel({required this.id, required this.content, @JsonKey(name: 'created_at') required this.createdAt, required this.author});
  factory _AnswerModel.fromJson(Map<String, dynamic> json) => _$AnswerModelFromJson(json);

@override final  int id;
@override final  String content;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;
@override final  UserModel author;

/// Create a copy of AnswerModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnswerModelCopyWith<_AnswerModel> get copyWith => __$AnswerModelCopyWithImpl<_AnswerModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AnswerModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnswerModel&&(identical(other.id, id) || other.id == id)&&(identical(other.content, content) || other.content == content)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.author, author) || other.author == author));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,content,createdAt,author);

@override
String toString() {
  return 'AnswerModel(id: $id, content: $content, createdAt: $createdAt, author: $author)';
}


}

/// @nodoc
abstract mixin class _$AnswerModelCopyWith<$Res> implements $AnswerModelCopyWith<$Res> {
  factory _$AnswerModelCopyWith(_AnswerModel value, $Res Function(_AnswerModel) _then) = __$AnswerModelCopyWithImpl;
@override @useResult
$Res call({
 int id, String content,@JsonKey(name: 'created_at') DateTime createdAt, UserModel author
});


@override $UserModelCopyWith<$Res> get author;

}
/// @nodoc
class __$AnswerModelCopyWithImpl<$Res>
    implements _$AnswerModelCopyWith<$Res> {
  __$AnswerModelCopyWithImpl(this._self, this._then);

  final _AnswerModel _self;
  final $Res Function(_AnswerModel) _then;

/// Create a copy of AnswerModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? content = null,Object? createdAt = null,Object? author = null,}) {
  return _then(_AnswerModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as UserModel,
  ));
}

/// Create a copy of AnswerModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserModelCopyWith<$Res> get author {
  
  return $UserModelCopyWith<$Res>(_self.author, (value) {
    return _then(_self.copyWith(author: value));
  });
}
}


/// @nodoc
mixin _$CourseDetails {

 int get id; String get title; String? get code;
/// Create a copy of CourseDetails
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CourseDetailsCopyWith<CourseDetails> get copyWith => _$CourseDetailsCopyWithImpl<CourseDetails>(this as CourseDetails, _$identity);

  /// Serializes this CourseDetails to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CourseDetails&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.code, code) || other.code == code));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,code);

@override
String toString() {
  return 'CourseDetails(id: $id, title: $title, code: $code)';
}


}

/// @nodoc
abstract mixin class $CourseDetailsCopyWith<$Res>  {
  factory $CourseDetailsCopyWith(CourseDetails value, $Res Function(CourseDetails) _then) = _$CourseDetailsCopyWithImpl;
@useResult
$Res call({
 int id, String title, String? code
});




}
/// @nodoc
class _$CourseDetailsCopyWithImpl<$Res>
    implements $CourseDetailsCopyWith<$Res> {
  _$CourseDetailsCopyWithImpl(this._self, this._then);

  final CourseDetails _self;
  final $Res Function(CourseDetails) _then;

/// Create a copy of CourseDetails
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? code = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CourseDetails].
extension CourseDetailsPatterns on CourseDetails {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CourseDetails value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CourseDetails() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CourseDetails value)  $default,){
final _that = this;
switch (_that) {
case _CourseDetails():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CourseDetails value)?  $default,){
final _that = this;
switch (_that) {
case _CourseDetails() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String title,  String? code)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CourseDetails() when $default != null:
return $default(_that.id,_that.title,_that.code);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String title,  String? code)  $default,) {final _that = this;
switch (_that) {
case _CourseDetails():
return $default(_that.id,_that.title,_that.code);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String title,  String? code)?  $default,) {final _that = this;
switch (_that) {
case _CourseDetails() when $default != null:
return $default(_that.id,_that.title,_that.code);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CourseDetails implements CourseDetails {
  const _CourseDetails({required this.id, required this.title, this.code});
  factory _CourseDetails.fromJson(Map<String, dynamic> json) => _$CourseDetailsFromJson(json);

@override final  int id;
@override final  String title;
@override final  String? code;

/// Create a copy of CourseDetails
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CourseDetailsCopyWith<_CourseDetails> get copyWith => __$CourseDetailsCopyWithImpl<_CourseDetails>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CourseDetailsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CourseDetails&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.code, code) || other.code == code));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,code);

@override
String toString() {
  return 'CourseDetails(id: $id, title: $title, code: $code)';
}


}

/// @nodoc
abstract mixin class _$CourseDetailsCopyWith<$Res> implements $CourseDetailsCopyWith<$Res> {
  factory _$CourseDetailsCopyWith(_CourseDetails value, $Res Function(_CourseDetails) _then) = __$CourseDetailsCopyWithImpl;
@override @useResult
$Res call({
 int id, String title, String? code
});




}
/// @nodoc
class __$CourseDetailsCopyWithImpl<$Res>
    implements _$CourseDetailsCopyWith<$Res> {
  __$CourseDetailsCopyWithImpl(this._self, this._then);

  final _CourseDetails _self;
  final $Res Function(_CourseDetails) _then;

/// Create a copy of CourseDetails
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? code = freezed,}) {
  return _then(_CourseDetails(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ClassTermDetails {

// React: department_name, term_display
@JsonKey(name: 'department_name') String? get departmentName;@JsonKey(name: 'term_display') String? get termDisplay;
/// Create a copy of ClassTermDetails
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClassTermDetailsCopyWith<ClassTermDetails> get copyWith => _$ClassTermDetailsCopyWithImpl<ClassTermDetails>(this as ClassTermDetails, _$identity);

  /// Serializes this ClassTermDetails to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClassTermDetails&&(identical(other.departmentName, departmentName) || other.departmentName == departmentName)&&(identical(other.termDisplay, termDisplay) || other.termDisplay == termDisplay));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,departmentName,termDisplay);

@override
String toString() {
  return 'ClassTermDetails(departmentName: $departmentName, termDisplay: $termDisplay)';
}


}

/// @nodoc
abstract mixin class $ClassTermDetailsCopyWith<$Res>  {
  factory $ClassTermDetailsCopyWith(ClassTermDetails value, $Res Function(ClassTermDetails) _then) = _$ClassTermDetailsCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'department_name') String? departmentName,@JsonKey(name: 'term_display') String? termDisplay
});




}
/// @nodoc
class _$ClassTermDetailsCopyWithImpl<$Res>
    implements $ClassTermDetailsCopyWith<$Res> {
  _$ClassTermDetailsCopyWithImpl(this._self, this._then);

  final ClassTermDetails _self;
  final $Res Function(ClassTermDetails) _then;

/// Create a copy of ClassTermDetails
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? departmentName = freezed,Object? termDisplay = freezed,}) {
  return _then(_self.copyWith(
departmentName: freezed == departmentName ? _self.departmentName : departmentName // ignore: cast_nullable_to_non_nullable
as String?,termDisplay: freezed == termDisplay ? _self.termDisplay : termDisplay // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ClassTermDetails].
extension ClassTermDetailsPatterns on ClassTermDetails {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ClassTermDetails value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ClassTermDetails() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ClassTermDetails value)  $default,){
final _that = this;
switch (_that) {
case _ClassTermDetails():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ClassTermDetails value)?  $default,){
final _that = this;
switch (_that) {
case _ClassTermDetails() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'department_name')  String? departmentName, @JsonKey(name: 'term_display')  String? termDisplay)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ClassTermDetails() when $default != null:
return $default(_that.departmentName,_that.termDisplay);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'department_name')  String? departmentName, @JsonKey(name: 'term_display')  String? termDisplay)  $default,) {final _that = this;
switch (_that) {
case _ClassTermDetails():
return $default(_that.departmentName,_that.termDisplay);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'department_name')  String? departmentName, @JsonKey(name: 'term_display')  String? termDisplay)?  $default,) {final _that = this;
switch (_that) {
case _ClassTermDetails() when $default != null:
return $default(_that.departmentName,_that.termDisplay);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ClassTermDetails implements ClassTermDetails {
  const _ClassTermDetails({@JsonKey(name: 'department_name') this.departmentName, @JsonKey(name: 'term_display') this.termDisplay});
  factory _ClassTermDetails.fromJson(Map<String, dynamic> json) => _$ClassTermDetailsFromJson(json);

// React: department_name, term_display
@override@JsonKey(name: 'department_name') final  String? departmentName;
@override@JsonKey(name: 'term_display') final  String? termDisplay;

/// Create a copy of ClassTermDetails
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ClassTermDetailsCopyWith<_ClassTermDetails> get copyWith => __$ClassTermDetailsCopyWithImpl<_ClassTermDetails>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ClassTermDetailsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ClassTermDetails&&(identical(other.departmentName, departmentName) || other.departmentName == departmentName)&&(identical(other.termDisplay, termDisplay) || other.termDisplay == termDisplay));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,departmentName,termDisplay);

@override
String toString() {
  return 'ClassTermDetails(departmentName: $departmentName, termDisplay: $termDisplay)';
}


}

/// @nodoc
abstract mixin class _$ClassTermDetailsCopyWith<$Res> implements $ClassTermDetailsCopyWith<$Res> {
  factory _$ClassTermDetailsCopyWith(_ClassTermDetails value, $Res Function(_ClassTermDetails) _then) = __$ClassTermDetailsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'department_name') String? departmentName,@JsonKey(name: 'term_display') String? termDisplay
});




}
/// @nodoc
class __$ClassTermDetailsCopyWithImpl<$Res>
    implements _$ClassTermDetailsCopyWith<$Res> {
  __$ClassTermDetailsCopyWithImpl(this._self, this._then);

  final _ClassTermDetails _self;
  final $Res Function(_ClassTermDetails) _then;

/// Create a copy of ClassTermDetails
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? departmentName = freezed,Object? termDisplay = freezed,}) {
  return _then(_ClassTermDetails(
departmentName: freezed == departmentName ? _self.departmentName : departmentName // ignore: cast_nullable_to_non_nullable
as String?,termDisplay: freezed == termDisplay ? _self.termDisplay : termDisplay // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
