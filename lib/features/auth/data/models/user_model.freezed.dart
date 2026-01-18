// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserModel {

 int get id; String get username; String? get email; String? get firstName; String? get lastName;// User Type: 'student', 'r_student', 'teacher', 'dean', 'rector', 'admin'
// We use String here to match flexibility of backend response
@JsonKey(name: 'user_type') String get userType;// Approval & Hierarchy
 bool get isApproved; bool get isDepartmentHead;// Details (Backend sends simplified ID/Name maps occasionally)
 Map<String, dynamic>? get departmentDetails; Map<String, dynamic>? get facultyDetails;// Extra Fields
 String? get phone; String? get studentNumber; String? get studentTerm; DateTime? get dateJoined;// Profile
 String? get profileImage;
/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserModelCopyWith<UserModel> get copyWith => _$UserModelCopyWithImpl<UserModel>(this as UserModel, _$identity);

  /// Serializes this UserModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserModel&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username)&&(identical(other.email, email) || other.email == email)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.userType, userType) || other.userType == userType)&&(identical(other.isApproved, isApproved) || other.isApproved == isApproved)&&(identical(other.isDepartmentHead, isDepartmentHead) || other.isDepartmentHead == isDepartmentHead)&&const DeepCollectionEquality().equals(other.departmentDetails, departmentDetails)&&const DeepCollectionEquality().equals(other.facultyDetails, facultyDetails)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.studentNumber, studentNumber) || other.studentNumber == studentNumber)&&(identical(other.studentTerm, studentTerm) || other.studentTerm == studentTerm)&&(identical(other.dateJoined, dateJoined) || other.dateJoined == dateJoined)&&(identical(other.profileImage, profileImage) || other.profileImage == profileImage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,username,email,firstName,lastName,userType,isApproved,isDepartmentHead,const DeepCollectionEquality().hash(departmentDetails),const DeepCollectionEquality().hash(facultyDetails),phone,studentNumber,studentTerm,dateJoined,profileImage);

@override
String toString() {
  return 'UserModel(id: $id, username: $username, email: $email, firstName: $firstName, lastName: $lastName, userType: $userType, isApproved: $isApproved, isDepartmentHead: $isDepartmentHead, departmentDetails: $departmentDetails, facultyDetails: $facultyDetails, phone: $phone, studentNumber: $studentNumber, studentTerm: $studentTerm, dateJoined: $dateJoined, profileImage: $profileImage)';
}


}

/// @nodoc
abstract mixin class $UserModelCopyWith<$Res>  {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) _then) = _$UserModelCopyWithImpl;
@useResult
$Res call({
 int id, String username, String? email, String? firstName, String? lastName,@JsonKey(name: 'user_type') String userType, bool isApproved, bool isDepartmentHead, Map<String, dynamic>? departmentDetails, Map<String, dynamic>? facultyDetails, String? phone, String? studentNumber, String? studentTerm, DateTime? dateJoined, String? profileImage
});




}
/// @nodoc
class _$UserModelCopyWithImpl<$Res>
    implements $UserModelCopyWith<$Res> {
  _$UserModelCopyWithImpl(this._self, this._then);

  final UserModel _self;
  final $Res Function(UserModel) _then;

/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? username = null,Object? email = freezed,Object? firstName = freezed,Object? lastName = freezed,Object? userType = null,Object? isApproved = null,Object? isDepartmentHead = null,Object? departmentDetails = freezed,Object? facultyDetails = freezed,Object? phone = freezed,Object? studentNumber = freezed,Object? studentTerm = freezed,Object? dateJoined = freezed,Object? profileImage = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,firstName: freezed == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String?,lastName: freezed == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String?,userType: null == userType ? _self.userType : userType // ignore: cast_nullable_to_non_nullable
as String,isApproved: null == isApproved ? _self.isApproved : isApproved // ignore: cast_nullable_to_non_nullable
as bool,isDepartmentHead: null == isDepartmentHead ? _self.isDepartmentHead : isDepartmentHead // ignore: cast_nullable_to_non_nullable
as bool,departmentDetails: freezed == departmentDetails ? _self.departmentDetails : departmentDetails // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,facultyDetails: freezed == facultyDetails ? _self.facultyDetails : facultyDetails // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,studentNumber: freezed == studentNumber ? _self.studentNumber : studentNumber // ignore: cast_nullable_to_non_nullable
as String?,studentTerm: freezed == studentTerm ? _self.studentTerm : studentTerm // ignore: cast_nullable_to_non_nullable
as String?,dateJoined: freezed == dateJoined ? _self.dateJoined : dateJoined // ignore: cast_nullable_to_non_nullable
as DateTime?,profileImage: freezed == profileImage ? _self.profileImage : profileImage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [UserModel].
extension UserModelPatterns on UserModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserModel value)  $default,){
final _that = this;
switch (_that) {
case _UserModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserModel value)?  $default,){
final _that = this;
switch (_that) {
case _UserModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String username,  String? email,  String? firstName,  String? lastName, @JsonKey(name: 'user_type')  String userType,  bool isApproved,  bool isDepartmentHead,  Map<String, dynamic>? departmentDetails,  Map<String, dynamic>? facultyDetails,  String? phone,  String? studentNumber,  String? studentTerm,  DateTime? dateJoined,  String? profileImage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserModel() when $default != null:
return $default(_that.id,_that.username,_that.email,_that.firstName,_that.lastName,_that.userType,_that.isApproved,_that.isDepartmentHead,_that.departmentDetails,_that.facultyDetails,_that.phone,_that.studentNumber,_that.studentTerm,_that.dateJoined,_that.profileImage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String username,  String? email,  String? firstName,  String? lastName, @JsonKey(name: 'user_type')  String userType,  bool isApproved,  bool isDepartmentHead,  Map<String, dynamic>? departmentDetails,  Map<String, dynamic>? facultyDetails,  String? phone,  String? studentNumber,  String? studentTerm,  DateTime? dateJoined,  String? profileImage)  $default,) {final _that = this;
switch (_that) {
case _UserModel():
return $default(_that.id,_that.username,_that.email,_that.firstName,_that.lastName,_that.userType,_that.isApproved,_that.isDepartmentHead,_that.departmentDetails,_that.facultyDetails,_that.phone,_that.studentNumber,_that.studentTerm,_that.dateJoined,_that.profileImage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String username,  String? email,  String? firstName,  String? lastName, @JsonKey(name: 'user_type')  String userType,  bool isApproved,  bool isDepartmentHead,  Map<String, dynamic>? departmentDetails,  Map<String, dynamic>? facultyDetails,  String? phone,  String? studentNumber,  String? studentTerm,  DateTime? dateJoined,  String? profileImage)?  $default,) {final _that = this;
switch (_that) {
case _UserModel() when $default != null:
return $default(_that.id,_that.username,_that.email,_that.firstName,_that.lastName,_that.userType,_that.isApproved,_that.isDepartmentHead,_that.departmentDetails,_that.facultyDetails,_that.phone,_that.studentNumber,_that.studentTerm,_that.dateJoined,_that.profileImage);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _UserModel implements UserModel {
  const _UserModel({required this.id, required this.username, this.email, this.firstName, this.lastName, @JsonKey(name: 'user_type') required this.userType, this.isApproved = false, this.isDepartmentHead = false, final  Map<String, dynamic>? departmentDetails, final  Map<String, dynamic>? facultyDetails, this.phone, this.studentNumber, this.studentTerm, this.dateJoined, this.profileImage}): _departmentDetails = departmentDetails,_facultyDetails = facultyDetails;
  factory _UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

@override final  int id;
@override final  String username;
@override final  String? email;
@override final  String? firstName;
@override final  String? lastName;
// User Type: 'student', 'r_student', 'teacher', 'dean', 'rector', 'admin'
// We use String here to match flexibility of backend response
@override@JsonKey(name: 'user_type') final  String userType;
// Approval & Hierarchy
@override@JsonKey() final  bool isApproved;
@override@JsonKey() final  bool isDepartmentHead;
// Details (Backend sends simplified ID/Name maps occasionally)
 final  Map<String, dynamic>? _departmentDetails;
// Details (Backend sends simplified ID/Name maps occasionally)
@override Map<String, dynamic>? get departmentDetails {
  final value = _departmentDetails;
  if (value == null) return null;
  if (_departmentDetails is EqualUnmodifiableMapView) return _departmentDetails;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

 final  Map<String, dynamic>? _facultyDetails;
@override Map<String, dynamic>? get facultyDetails {
  final value = _facultyDetails;
  if (value == null) return null;
  if (_facultyDetails is EqualUnmodifiableMapView) return _facultyDetails;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

// Extra Fields
@override final  String? phone;
@override final  String? studentNumber;
@override final  String? studentTerm;
@override final  DateTime? dateJoined;
// Profile
@override final  String? profileImage;

/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserModelCopyWith<_UserModel> get copyWith => __$UserModelCopyWithImpl<_UserModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserModel&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username)&&(identical(other.email, email) || other.email == email)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.userType, userType) || other.userType == userType)&&(identical(other.isApproved, isApproved) || other.isApproved == isApproved)&&(identical(other.isDepartmentHead, isDepartmentHead) || other.isDepartmentHead == isDepartmentHead)&&const DeepCollectionEquality().equals(other._departmentDetails, _departmentDetails)&&const DeepCollectionEquality().equals(other._facultyDetails, _facultyDetails)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.studentNumber, studentNumber) || other.studentNumber == studentNumber)&&(identical(other.studentTerm, studentTerm) || other.studentTerm == studentTerm)&&(identical(other.dateJoined, dateJoined) || other.dateJoined == dateJoined)&&(identical(other.profileImage, profileImage) || other.profileImage == profileImage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,username,email,firstName,lastName,userType,isApproved,isDepartmentHead,const DeepCollectionEquality().hash(_departmentDetails),const DeepCollectionEquality().hash(_facultyDetails),phone,studentNumber,studentTerm,dateJoined,profileImage);

@override
String toString() {
  return 'UserModel(id: $id, username: $username, email: $email, firstName: $firstName, lastName: $lastName, userType: $userType, isApproved: $isApproved, isDepartmentHead: $isDepartmentHead, departmentDetails: $departmentDetails, facultyDetails: $facultyDetails, phone: $phone, studentNumber: $studentNumber, studentTerm: $studentTerm, dateJoined: $dateJoined, profileImage: $profileImage)';
}


}

/// @nodoc
abstract mixin class _$UserModelCopyWith<$Res> implements $UserModelCopyWith<$Res> {
  factory _$UserModelCopyWith(_UserModel value, $Res Function(_UserModel) _then) = __$UserModelCopyWithImpl;
@override @useResult
$Res call({
 int id, String username, String? email, String? firstName, String? lastName,@JsonKey(name: 'user_type') String userType, bool isApproved, bool isDepartmentHead, Map<String, dynamic>? departmentDetails, Map<String, dynamic>? facultyDetails, String? phone, String? studentNumber, String? studentTerm, DateTime? dateJoined, String? profileImage
});




}
/// @nodoc
class __$UserModelCopyWithImpl<$Res>
    implements _$UserModelCopyWith<$Res> {
  __$UserModelCopyWithImpl(this._self, this._then);

  final _UserModel _self;
  final $Res Function(_UserModel) _then;

/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? username = null,Object? email = freezed,Object? firstName = freezed,Object? lastName = freezed,Object? userType = null,Object? isApproved = null,Object? isDepartmentHead = null,Object? departmentDetails = freezed,Object? facultyDetails = freezed,Object? phone = freezed,Object? studentNumber = freezed,Object? studentTerm = freezed,Object? dateJoined = freezed,Object? profileImage = freezed,}) {
  return _then(_UserModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,firstName: freezed == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String?,lastName: freezed == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String?,userType: null == userType ? _self.userType : userType // ignore: cast_nullable_to_non_nullable
as String,isApproved: null == isApproved ? _self.isApproved : isApproved // ignore: cast_nullable_to_non_nullable
as bool,isDepartmentHead: null == isDepartmentHead ? _self.isDepartmentHead : isDepartmentHead // ignore: cast_nullable_to_non_nullable
as bool,departmentDetails: freezed == departmentDetails ? _self._departmentDetails : departmentDetails // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,facultyDetails: freezed == facultyDetails ? _self._facultyDetails : facultyDetails // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,studentNumber: freezed == studentNumber ? _self.studentNumber : studentNumber // ignore: cast_nullable_to_non_nullable
as String?,studentTerm: freezed == studentTerm ? _self.studentTerm : studentTerm // ignore: cast_nullable_to_non_nullable
as String?,dateJoined: freezed == dateJoined ? _self.dateJoined : dateJoined // ignore: cast_nullable_to_non_nullable
as DateTime?,profileImage: freezed == profileImage ? _self.profileImage : profileImage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
