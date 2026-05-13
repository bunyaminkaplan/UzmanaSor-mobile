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

 int get id; String get username; String? get email; String? get firstName; String? get lastName;// Django: "active_dashboard" alanı (student, teacher, vb.)
 String? get activeDashboard;// Django: SerializerMethodField "user_type" — active_dashboard'dan türetilir
@JsonKey(name: 'user_type') String? get userType;// Django: ManyToManyField "roles" — PrimaryKeyRelatedField ile [6, 3] gibi
// int dizisi gönderiyor. Nested serializer kullanılırsa [{name: "student"}, ...]
// gelir. Her iki formata da uyum sağlamak için List<dynamic> kullanıyoruz.
@JsonKey(defaultValue: []) List<dynamic>? get roles;// Durum alanları
 bool get isApproved; bool get isActive; bool get isDepartmentHead; bool get isAdvisor;// Fakülte/Bölüm ID'leri (SerializerMethodField — null gelebilir)
 int? get faculty; int? get department;// SimpleUserSerializer'dan gelen flat alanlar
 int? get facultyId; String? get facultyName; int? get departmentId; String? get departmentName;// Detay nesneleri (SerializerMethodField — null gelebilir)
 Map<String, dynamic>? get departmentDetails; Map<String, dynamic>? get facultyDetails;// Profil nesneleri (nested serializer — null gelebilir)
 Map<String, dynamic>? get studentProfile; Map<String, dynamic>? get teacherProfile; Map<String, dynamic>? get deanProfile; Map<String, dynamic>? get rectorProfile;// Danışman bilgisi (SerializerMethodField — null gelebilir)
 Map<String, dynamic>? get advisor;// Kişisel bilgiler
 String? get phone; String? get studentNumber; String? get studentTerm; DateTime? get dateJoined; String? get profileImage; bool get isEmailVerified;
/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserModelCopyWith<UserModel> get copyWith => _$UserModelCopyWithImpl<UserModel>(this as UserModel, _$identity);

  /// Serializes this UserModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserModel&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username)&&(identical(other.email, email) || other.email == email)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.activeDashboard, activeDashboard) || other.activeDashboard == activeDashboard)&&(identical(other.userType, userType) || other.userType == userType)&&const DeepCollectionEquality().equals(other.roles, roles)&&(identical(other.isApproved, isApproved) || other.isApproved == isApproved)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.isDepartmentHead, isDepartmentHead) || other.isDepartmentHead == isDepartmentHead)&&(identical(other.isAdvisor, isAdvisor) || other.isAdvisor == isAdvisor)&&(identical(other.faculty, faculty) || other.faculty == faculty)&&(identical(other.department, department) || other.department == department)&&(identical(other.facultyId, facultyId) || other.facultyId == facultyId)&&(identical(other.facultyName, facultyName) || other.facultyName == facultyName)&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&(identical(other.departmentName, departmentName) || other.departmentName == departmentName)&&const DeepCollectionEquality().equals(other.departmentDetails, departmentDetails)&&const DeepCollectionEquality().equals(other.facultyDetails, facultyDetails)&&const DeepCollectionEquality().equals(other.studentProfile, studentProfile)&&const DeepCollectionEquality().equals(other.teacherProfile, teacherProfile)&&const DeepCollectionEquality().equals(other.deanProfile, deanProfile)&&const DeepCollectionEquality().equals(other.rectorProfile, rectorProfile)&&const DeepCollectionEquality().equals(other.advisor, advisor)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.studentNumber, studentNumber) || other.studentNumber == studentNumber)&&(identical(other.studentTerm, studentTerm) || other.studentTerm == studentTerm)&&(identical(other.dateJoined, dateJoined) || other.dateJoined == dateJoined)&&(identical(other.profileImage, profileImage) || other.profileImage == profileImage)&&(identical(other.isEmailVerified, isEmailVerified) || other.isEmailVerified == isEmailVerified));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,username,email,firstName,lastName,activeDashboard,userType,const DeepCollectionEquality().hash(roles),isApproved,isActive,isDepartmentHead,isAdvisor,faculty,department,facultyId,facultyName,departmentId,departmentName,const DeepCollectionEquality().hash(departmentDetails),const DeepCollectionEquality().hash(facultyDetails),const DeepCollectionEquality().hash(studentProfile),const DeepCollectionEquality().hash(teacherProfile),const DeepCollectionEquality().hash(deanProfile),const DeepCollectionEquality().hash(rectorProfile),const DeepCollectionEquality().hash(advisor),phone,studentNumber,studentTerm,dateJoined,profileImage,isEmailVerified]);

@override
String toString() {
  return 'UserModel(id: $id, username: $username, email: $email, firstName: $firstName, lastName: $lastName, activeDashboard: $activeDashboard, userType: $userType, roles: $roles, isApproved: $isApproved, isActive: $isActive, isDepartmentHead: $isDepartmentHead, isAdvisor: $isAdvisor, faculty: $faculty, department: $department, facultyId: $facultyId, facultyName: $facultyName, departmentId: $departmentId, departmentName: $departmentName, departmentDetails: $departmentDetails, facultyDetails: $facultyDetails, studentProfile: $studentProfile, teacherProfile: $teacherProfile, deanProfile: $deanProfile, rectorProfile: $rectorProfile, advisor: $advisor, phone: $phone, studentNumber: $studentNumber, studentTerm: $studentTerm, dateJoined: $dateJoined, profileImage: $profileImage, isEmailVerified: $isEmailVerified)';
}


}

/// @nodoc
abstract mixin class $UserModelCopyWith<$Res>  {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) _then) = _$UserModelCopyWithImpl;
@useResult
$Res call({
 int id, String username, String? email, String? firstName, String? lastName, String? activeDashboard,@JsonKey(name: 'user_type') String? userType,@JsonKey(defaultValue: []) List<dynamic>? roles, bool isApproved, bool isActive, bool isDepartmentHead, bool isAdvisor, int? faculty, int? department, int? facultyId, String? facultyName, int? departmentId, String? departmentName, Map<String, dynamic>? departmentDetails, Map<String, dynamic>? facultyDetails, Map<String, dynamic>? studentProfile, Map<String, dynamic>? teacherProfile, Map<String, dynamic>? deanProfile, Map<String, dynamic>? rectorProfile, Map<String, dynamic>? advisor, String? phone, String? studentNumber, String? studentTerm, DateTime? dateJoined, String? profileImage, bool isEmailVerified
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? username = null,Object? email = freezed,Object? firstName = freezed,Object? lastName = freezed,Object? activeDashboard = freezed,Object? userType = freezed,Object? roles = freezed,Object? isApproved = null,Object? isActive = null,Object? isDepartmentHead = null,Object? isAdvisor = null,Object? faculty = freezed,Object? department = freezed,Object? facultyId = freezed,Object? facultyName = freezed,Object? departmentId = freezed,Object? departmentName = freezed,Object? departmentDetails = freezed,Object? facultyDetails = freezed,Object? studentProfile = freezed,Object? teacherProfile = freezed,Object? deanProfile = freezed,Object? rectorProfile = freezed,Object? advisor = freezed,Object? phone = freezed,Object? studentNumber = freezed,Object? studentTerm = freezed,Object? dateJoined = freezed,Object? profileImage = freezed,Object? isEmailVerified = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,firstName: freezed == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String?,lastName: freezed == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String?,activeDashboard: freezed == activeDashboard ? _self.activeDashboard : activeDashboard // ignore: cast_nullable_to_non_nullable
as String?,userType: freezed == userType ? _self.userType : userType // ignore: cast_nullable_to_non_nullable
as String?,roles: freezed == roles ? _self.roles : roles // ignore: cast_nullable_to_non_nullable
as List<dynamic>?,isApproved: null == isApproved ? _self.isApproved : isApproved // ignore: cast_nullable_to_non_nullable
as bool,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,isDepartmentHead: null == isDepartmentHead ? _self.isDepartmentHead : isDepartmentHead // ignore: cast_nullable_to_non_nullable
as bool,isAdvisor: null == isAdvisor ? _self.isAdvisor : isAdvisor // ignore: cast_nullable_to_non_nullable
as bool,faculty: freezed == faculty ? _self.faculty : faculty // ignore: cast_nullable_to_non_nullable
as int?,department: freezed == department ? _self.department : department // ignore: cast_nullable_to_non_nullable
as int?,facultyId: freezed == facultyId ? _self.facultyId : facultyId // ignore: cast_nullable_to_non_nullable
as int?,facultyName: freezed == facultyName ? _self.facultyName : facultyName // ignore: cast_nullable_to_non_nullable
as String?,departmentId: freezed == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as int?,departmentName: freezed == departmentName ? _self.departmentName : departmentName // ignore: cast_nullable_to_non_nullable
as String?,departmentDetails: freezed == departmentDetails ? _self.departmentDetails : departmentDetails // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,facultyDetails: freezed == facultyDetails ? _self.facultyDetails : facultyDetails // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,studentProfile: freezed == studentProfile ? _self.studentProfile : studentProfile // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,teacherProfile: freezed == teacherProfile ? _self.teacherProfile : teacherProfile // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,deanProfile: freezed == deanProfile ? _self.deanProfile : deanProfile // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,rectorProfile: freezed == rectorProfile ? _self.rectorProfile : rectorProfile // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,advisor: freezed == advisor ? _self.advisor : advisor // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,studentNumber: freezed == studentNumber ? _self.studentNumber : studentNumber // ignore: cast_nullable_to_non_nullable
as String?,studentTerm: freezed == studentTerm ? _self.studentTerm : studentTerm // ignore: cast_nullable_to_non_nullable
as String?,dateJoined: freezed == dateJoined ? _self.dateJoined : dateJoined // ignore: cast_nullable_to_non_nullable
as DateTime?,profileImage: freezed == profileImage ? _self.profileImage : profileImage // ignore: cast_nullable_to_non_nullable
as String?,isEmailVerified: null == isEmailVerified ? _self.isEmailVerified : isEmailVerified // ignore: cast_nullable_to_non_nullable
as bool,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String username,  String? email,  String? firstName,  String? lastName,  String? activeDashboard, @JsonKey(name: 'user_type')  String? userType, @JsonKey(defaultValue: [])  List<dynamic>? roles,  bool isApproved,  bool isActive,  bool isDepartmentHead,  bool isAdvisor,  int? faculty,  int? department,  int? facultyId,  String? facultyName,  int? departmentId,  String? departmentName,  Map<String, dynamic>? departmentDetails,  Map<String, dynamic>? facultyDetails,  Map<String, dynamic>? studentProfile,  Map<String, dynamic>? teacherProfile,  Map<String, dynamic>? deanProfile,  Map<String, dynamic>? rectorProfile,  Map<String, dynamic>? advisor,  String? phone,  String? studentNumber,  String? studentTerm,  DateTime? dateJoined,  String? profileImage,  bool isEmailVerified)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserModel() when $default != null:
return $default(_that.id,_that.username,_that.email,_that.firstName,_that.lastName,_that.activeDashboard,_that.userType,_that.roles,_that.isApproved,_that.isActive,_that.isDepartmentHead,_that.isAdvisor,_that.faculty,_that.department,_that.facultyId,_that.facultyName,_that.departmentId,_that.departmentName,_that.departmentDetails,_that.facultyDetails,_that.studentProfile,_that.teacherProfile,_that.deanProfile,_that.rectorProfile,_that.advisor,_that.phone,_that.studentNumber,_that.studentTerm,_that.dateJoined,_that.profileImage,_that.isEmailVerified);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String username,  String? email,  String? firstName,  String? lastName,  String? activeDashboard, @JsonKey(name: 'user_type')  String? userType, @JsonKey(defaultValue: [])  List<dynamic>? roles,  bool isApproved,  bool isActive,  bool isDepartmentHead,  bool isAdvisor,  int? faculty,  int? department,  int? facultyId,  String? facultyName,  int? departmentId,  String? departmentName,  Map<String, dynamic>? departmentDetails,  Map<String, dynamic>? facultyDetails,  Map<String, dynamic>? studentProfile,  Map<String, dynamic>? teacherProfile,  Map<String, dynamic>? deanProfile,  Map<String, dynamic>? rectorProfile,  Map<String, dynamic>? advisor,  String? phone,  String? studentNumber,  String? studentTerm,  DateTime? dateJoined,  String? profileImage,  bool isEmailVerified)  $default,) {final _that = this;
switch (_that) {
case _UserModel():
return $default(_that.id,_that.username,_that.email,_that.firstName,_that.lastName,_that.activeDashboard,_that.userType,_that.roles,_that.isApproved,_that.isActive,_that.isDepartmentHead,_that.isAdvisor,_that.faculty,_that.department,_that.facultyId,_that.facultyName,_that.departmentId,_that.departmentName,_that.departmentDetails,_that.facultyDetails,_that.studentProfile,_that.teacherProfile,_that.deanProfile,_that.rectorProfile,_that.advisor,_that.phone,_that.studentNumber,_that.studentTerm,_that.dateJoined,_that.profileImage,_that.isEmailVerified);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String username,  String? email,  String? firstName,  String? lastName,  String? activeDashboard, @JsonKey(name: 'user_type')  String? userType, @JsonKey(defaultValue: [])  List<dynamic>? roles,  bool isApproved,  bool isActive,  bool isDepartmentHead,  bool isAdvisor,  int? faculty,  int? department,  int? facultyId,  String? facultyName,  int? departmentId,  String? departmentName,  Map<String, dynamic>? departmentDetails,  Map<String, dynamic>? facultyDetails,  Map<String, dynamic>? studentProfile,  Map<String, dynamic>? teacherProfile,  Map<String, dynamic>? deanProfile,  Map<String, dynamic>? rectorProfile,  Map<String, dynamic>? advisor,  String? phone,  String? studentNumber,  String? studentTerm,  DateTime? dateJoined,  String? profileImage,  bool isEmailVerified)?  $default,) {final _that = this;
switch (_that) {
case _UserModel() when $default != null:
return $default(_that.id,_that.username,_that.email,_that.firstName,_that.lastName,_that.activeDashboard,_that.userType,_that.roles,_that.isApproved,_that.isActive,_that.isDepartmentHead,_that.isAdvisor,_that.faculty,_that.department,_that.facultyId,_that.facultyName,_that.departmentId,_that.departmentName,_that.departmentDetails,_that.facultyDetails,_that.studentProfile,_that.teacherProfile,_that.deanProfile,_that.rectorProfile,_that.advisor,_that.phone,_that.studentNumber,_that.studentTerm,_that.dateJoined,_that.profileImage,_that.isEmailVerified);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _UserModel implements UserModel {
  const _UserModel({required this.id, required this.username, this.email, this.firstName, this.lastName, this.activeDashboard, @JsonKey(name: 'user_type') this.userType, @JsonKey(defaultValue: []) final  List<dynamic>? roles, this.isApproved = false, this.isActive = false, this.isDepartmentHead = false, this.isAdvisor = false, this.faculty, this.department, this.facultyId, this.facultyName, this.departmentId, this.departmentName, final  Map<String, dynamic>? departmentDetails, final  Map<String, dynamic>? facultyDetails, final  Map<String, dynamic>? studentProfile, final  Map<String, dynamic>? teacherProfile, final  Map<String, dynamic>? deanProfile, final  Map<String, dynamic>? rectorProfile, final  Map<String, dynamic>? advisor, this.phone, this.studentNumber, this.studentTerm, this.dateJoined, this.profileImage, this.isEmailVerified = false}): _roles = roles,_departmentDetails = departmentDetails,_facultyDetails = facultyDetails,_studentProfile = studentProfile,_teacherProfile = teacherProfile,_deanProfile = deanProfile,_rectorProfile = rectorProfile,_advisor = advisor;
  factory _UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

@override final  int id;
@override final  String username;
@override final  String? email;
@override final  String? firstName;
@override final  String? lastName;
// Django: "active_dashboard" alanı (student, teacher, vb.)
@override final  String? activeDashboard;
// Django: SerializerMethodField "user_type" — active_dashboard'dan türetilir
@override@JsonKey(name: 'user_type') final  String? userType;
// Django: ManyToManyField "roles" — PrimaryKeyRelatedField ile [6, 3] gibi
// int dizisi gönderiyor. Nested serializer kullanılırsa [{name: "student"}, ...]
// gelir. Her iki formata da uyum sağlamak için List<dynamic> kullanıyoruz.
 final  List<dynamic>? _roles;
// Django: ManyToManyField "roles" — PrimaryKeyRelatedField ile [6, 3] gibi
// int dizisi gönderiyor. Nested serializer kullanılırsa [{name: "student"}, ...]
// gelir. Her iki formata da uyum sağlamak için List<dynamic> kullanıyoruz.
@override@JsonKey(defaultValue: []) List<dynamic>? get roles {
  final value = _roles;
  if (value == null) return null;
  if (_roles is EqualUnmodifiableListView) return _roles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

// Durum alanları
@override@JsonKey() final  bool isApproved;
@override@JsonKey() final  bool isActive;
@override@JsonKey() final  bool isDepartmentHead;
@override@JsonKey() final  bool isAdvisor;
// Fakülte/Bölüm ID'leri (SerializerMethodField — null gelebilir)
@override final  int? faculty;
@override final  int? department;
// SimpleUserSerializer'dan gelen flat alanlar
@override final  int? facultyId;
@override final  String? facultyName;
@override final  int? departmentId;
@override final  String? departmentName;
// Detay nesneleri (SerializerMethodField — null gelebilir)
 final  Map<String, dynamic>? _departmentDetails;
// Detay nesneleri (SerializerMethodField — null gelebilir)
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

// Profil nesneleri (nested serializer — null gelebilir)
 final  Map<String, dynamic>? _studentProfile;
// Profil nesneleri (nested serializer — null gelebilir)
@override Map<String, dynamic>? get studentProfile {
  final value = _studentProfile;
  if (value == null) return null;
  if (_studentProfile is EqualUnmodifiableMapView) return _studentProfile;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

 final  Map<String, dynamic>? _teacherProfile;
@override Map<String, dynamic>? get teacherProfile {
  final value = _teacherProfile;
  if (value == null) return null;
  if (_teacherProfile is EqualUnmodifiableMapView) return _teacherProfile;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

 final  Map<String, dynamic>? _deanProfile;
@override Map<String, dynamic>? get deanProfile {
  final value = _deanProfile;
  if (value == null) return null;
  if (_deanProfile is EqualUnmodifiableMapView) return _deanProfile;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

 final  Map<String, dynamic>? _rectorProfile;
@override Map<String, dynamic>? get rectorProfile {
  final value = _rectorProfile;
  if (value == null) return null;
  if (_rectorProfile is EqualUnmodifiableMapView) return _rectorProfile;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

// Danışman bilgisi (SerializerMethodField — null gelebilir)
 final  Map<String, dynamic>? _advisor;
// Danışman bilgisi (SerializerMethodField — null gelebilir)
@override Map<String, dynamic>? get advisor {
  final value = _advisor;
  if (value == null) return null;
  if (_advisor is EqualUnmodifiableMapView) return _advisor;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

// Kişisel bilgiler
@override final  String? phone;
@override final  String? studentNumber;
@override final  String? studentTerm;
@override final  DateTime? dateJoined;
@override final  String? profileImage;
@override@JsonKey() final  bool isEmailVerified;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserModel&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username)&&(identical(other.email, email) || other.email == email)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.activeDashboard, activeDashboard) || other.activeDashboard == activeDashboard)&&(identical(other.userType, userType) || other.userType == userType)&&const DeepCollectionEquality().equals(other._roles, _roles)&&(identical(other.isApproved, isApproved) || other.isApproved == isApproved)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.isDepartmentHead, isDepartmentHead) || other.isDepartmentHead == isDepartmentHead)&&(identical(other.isAdvisor, isAdvisor) || other.isAdvisor == isAdvisor)&&(identical(other.faculty, faculty) || other.faculty == faculty)&&(identical(other.department, department) || other.department == department)&&(identical(other.facultyId, facultyId) || other.facultyId == facultyId)&&(identical(other.facultyName, facultyName) || other.facultyName == facultyName)&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&(identical(other.departmentName, departmentName) || other.departmentName == departmentName)&&const DeepCollectionEquality().equals(other._departmentDetails, _departmentDetails)&&const DeepCollectionEquality().equals(other._facultyDetails, _facultyDetails)&&const DeepCollectionEquality().equals(other._studentProfile, _studentProfile)&&const DeepCollectionEquality().equals(other._teacherProfile, _teacherProfile)&&const DeepCollectionEquality().equals(other._deanProfile, _deanProfile)&&const DeepCollectionEquality().equals(other._rectorProfile, _rectorProfile)&&const DeepCollectionEquality().equals(other._advisor, _advisor)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.studentNumber, studentNumber) || other.studentNumber == studentNumber)&&(identical(other.studentTerm, studentTerm) || other.studentTerm == studentTerm)&&(identical(other.dateJoined, dateJoined) || other.dateJoined == dateJoined)&&(identical(other.profileImage, profileImage) || other.profileImage == profileImage)&&(identical(other.isEmailVerified, isEmailVerified) || other.isEmailVerified == isEmailVerified));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,username,email,firstName,lastName,activeDashboard,userType,const DeepCollectionEquality().hash(_roles),isApproved,isActive,isDepartmentHead,isAdvisor,faculty,department,facultyId,facultyName,departmentId,departmentName,const DeepCollectionEquality().hash(_departmentDetails),const DeepCollectionEquality().hash(_facultyDetails),const DeepCollectionEquality().hash(_studentProfile),const DeepCollectionEquality().hash(_teacherProfile),const DeepCollectionEquality().hash(_deanProfile),const DeepCollectionEquality().hash(_rectorProfile),const DeepCollectionEquality().hash(_advisor),phone,studentNumber,studentTerm,dateJoined,profileImage,isEmailVerified]);

@override
String toString() {
  return 'UserModel(id: $id, username: $username, email: $email, firstName: $firstName, lastName: $lastName, activeDashboard: $activeDashboard, userType: $userType, roles: $roles, isApproved: $isApproved, isActive: $isActive, isDepartmentHead: $isDepartmentHead, isAdvisor: $isAdvisor, faculty: $faculty, department: $department, facultyId: $facultyId, facultyName: $facultyName, departmentId: $departmentId, departmentName: $departmentName, departmentDetails: $departmentDetails, facultyDetails: $facultyDetails, studentProfile: $studentProfile, teacherProfile: $teacherProfile, deanProfile: $deanProfile, rectorProfile: $rectorProfile, advisor: $advisor, phone: $phone, studentNumber: $studentNumber, studentTerm: $studentTerm, dateJoined: $dateJoined, profileImage: $profileImage, isEmailVerified: $isEmailVerified)';
}


}

/// @nodoc
abstract mixin class _$UserModelCopyWith<$Res> implements $UserModelCopyWith<$Res> {
  factory _$UserModelCopyWith(_UserModel value, $Res Function(_UserModel) _then) = __$UserModelCopyWithImpl;
@override @useResult
$Res call({
 int id, String username, String? email, String? firstName, String? lastName, String? activeDashboard,@JsonKey(name: 'user_type') String? userType,@JsonKey(defaultValue: []) List<dynamic>? roles, bool isApproved, bool isActive, bool isDepartmentHead, bool isAdvisor, int? faculty, int? department, int? facultyId, String? facultyName, int? departmentId, String? departmentName, Map<String, dynamic>? departmentDetails, Map<String, dynamic>? facultyDetails, Map<String, dynamic>? studentProfile, Map<String, dynamic>? teacherProfile, Map<String, dynamic>? deanProfile, Map<String, dynamic>? rectorProfile, Map<String, dynamic>? advisor, String? phone, String? studentNumber, String? studentTerm, DateTime? dateJoined, String? profileImage, bool isEmailVerified
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? username = null,Object? email = freezed,Object? firstName = freezed,Object? lastName = freezed,Object? activeDashboard = freezed,Object? userType = freezed,Object? roles = freezed,Object? isApproved = null,Object? isActive = null,Object? isDepartmentHead = null,Object? isAdvisor = null,Object? faculty = freezed,Object? department = freezed,Object? facultyId = freezed,Object? facultyName = freezed,Object? departmentId = freezed,Object? departmentName = freezed,Object? departmentDetails = freezed,Object? facultyDetails = freezed,Object? studentProfile = freezed,Object? teacherProfile = freezed,Object? deanProfile = freezed,Object? rectorProfile = freezed,Object? advisor = freezed,Object? phone = freezed,Object? studentNumber = freezed,Object? studentTerm = freezed,Object? dateJoined = freezed,Object? profileImage = freezed,Object? isEmailVerified = null,}) {
  return _then(_UserModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,firstName: freezed == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String?,lastName: freezed == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String?,activeDashboard: freezed == activeDashboard ? _self.activeDashboard : activeDashboard // ignore: cast_nullable_to_non_nullable
as String?,userType: freezed == userType ? _self.userType : userType // ignore: cast_nullable_to_non_nullable
as String?,roles: freezed == roles ? _self._roles : roles // ignore: cast_nullable_to_non_nullable
as List<dynamic>?,isApproved: null == isApproved ? _self.isApproved : isApproved // ignore: cast_nullable_to_non_nullable
as bool,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,isDepartmentHead: null == isDepartmentHead ? _self.isDepartmentHead : isDepartmentHead // ignore: cast_nullable_to_non_nullable
as bool,isAdvisor: null == isAdvisor ? _self.isAdvisor : isAdvisor // ignore: cast_nullable_to_non_nullable
as bool,faculty: freezed == faculty ? _self.faculty : faculty // ignore: cast_nullable_to_non_nullable
as int?,department: freezed == department ? _self.department : department // ignore: cast_nullable_to_non_nullable
as int?,facultyId: freezed == facultyId ? _self.facultyId : facultyId // ignore: cast_nullable_to_non_nullable
as int?,facultyName: freezed == facultyName ? _self.facultyName : facultyName // ignore: cast_nullable_to_non_nullable
as String?,departmentId: freezed == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as int?,departmentName: freezed == departmentName ? _self.departmentName : departmentName // ignore: cast_nullable_to_non_nullable
as String?,departmentDetails: freezed == departmentDetails ? _self._departmentDetails : departmentDetails // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,facultyDetails: freezed == facultyDetails ? _self._facultyDetails : facultyDetails // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,studentProfile: freezed == studentProfile ? _self._studentProfile : studentProfile // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,teacherProfile: freezed == teacherProfile ? _self._teacherProfile : teacherProfile // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,deanProfile: freezed == deanProfile ? _self._deanProfile : deanProfile // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,rectorProfile: freezed == rectorProfile ? _self._rectorProfile : rectorProfile // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,advisor: freezed == advisor ? _self._advisor : advisor // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,studentNumber: freezed == studentNumber ? _self.studentNumber : studentNumber // ignore: cast_nullable_to_non_nullable
as String?,studentTerm: freezed == studentTerm ? _self.studentTerm : studentTerm // ignore: cast_nullable_to_non_nullable
as String?,dateJoined: freezed == dateJoined ? _self.dateJoined : dateJoined // ignore: cast_nullable_to_non_nullable
as DateTime?,profileImage: freezed == profileImage ? _self.profileImage : profileImage // ignore: cast_nullable_to_non_nullable
as String?,isEmailVerified: null == isEmailVerified ? _self.isEmailVerified : isEmailVerified // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
