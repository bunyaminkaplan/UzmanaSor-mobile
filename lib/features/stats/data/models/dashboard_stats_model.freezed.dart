// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_stats_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChartDistributionModel {

 List<String> get labels; List<int> get data;
/// Create a copy of ChartDistributionModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChartDistributionModelCopyWith<ChartDistributionModel> get copyWith => _$ChartDistributionModelCopyWithImpl<ChartDistributionModel>(this as ChartDistributionModel, _$identity);

  /// Serializes this ChartDistributionModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChartDistributionModel&&const DeepCollectionEquality().equals(other.labels, labels)&&const DeepCollectionEquality().equals(other.data, data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(labels),const DeepCollectionEquality().hash(data));

@override
String toString() {
  return 'ChartDistributionModel(labels: $labels, data: $data)';
}


}

/// @nodoc
abstract mixin class $ChartDistributionModelCopyWith<$Res>  {
  factory $ChartDistributionModelCopyWith(ChartDistributionModel value, $Res Function(ChartDistributionModel) _then) = _$ChartDistributionModelCopyWithImpl;
@useResult
$Res call({
 List<String> labels, List<int> data
});




}
/// @nodoc
class _$ChartDistributionModelCopyWithImpl<$Res>
    implements $ChartDistributionModelCopyWith<$Res> {
  _$ChartDistributionModelCopyWithImpl(this._self, this._then);

  final ChartDistributionModel _self;
  final $Res Function(ChartDistributionModel) _then;

/// Create a copy of ChartDistributionModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? labels = null,Object? data = null,}) {
  return _then(_self.copyWith(
labels: null == labels ? _self.labels : labels // ignore: cast_nullable_to_non_nullable
as List<String>,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}

}


/// Adds pattern-matching-related methods to [ChartDistributionModel].
extension ChartDistributionModelPatterns on ChartDistributionModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChartDistributionModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChartDistributionModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChartDistributionModel value)  $default,){
final _that = this;
switch (_that) {
case _ChartDistributionModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChartDistributionModel value)?  $default,){
final _that = this;
switch (_that) {
case _ChartDistributionModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<String> labels,  List<int> data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChartDistributionModel() when $default != null:
return $default(_that.labels,_that.data);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<String> labels,  List<int> data)  $default,) {final _that = this;
switch (_that) {
case _ChartDistributionModel():
return $default(_that.labels,_that.data);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<String> labels,  List<int> data)?  $default,) {final _that = this;
switch (_that) {
case _ChartDistributionModel() when $default != null:
return $default(_that.labels,_that.data);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _ChartDistributionModel extends ChartDistributionModel {
  const _ChartDistributionModel({final  List<String> labels = const [], final  List<int> data = const []}): _labels = labels,_data = data,super._();
  factory _ChartDistributionModel.fromJson(Map<String, dynamic> json) => _$ChartDistributionModelFromJson(json);

 final  List<String> _labels;
@override@JsonKey() List<String> get labels {
  if (_labels is EqualUnmodifiableListView) return _labels;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_labels);
}

 final  List<int> _data;
@override@JsonKey() List<int> get data {
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_data);
}


/// Create a copy of ChartDistributionModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChartDistributionModelCopyWith<_ChartDistributionModel> get copyWith => __$ChartDistributionModelCopyWithImpl<_ChartDistributionModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChartDistributionModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChartDistributionModel&&const DeepCollectionEquality().equals(other._labels, _labels)&&const DeepCollectionEquality().equals(other._data, _data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_labels),const DeepCollectionEquality().hash(_data));

@override
String toString() {
  return 'ChartDistributionModel(labels: $labels, data: $data)';
}


}

/// @nodoc
abstract mixin class _$ChartDistributionModelCopyWith<$Res> implements $ChartDistributionModelCopyWith<$Res> {
  factory _$ChartDistributionModelCopyWith(_ChartDistributionModel value, $Res Function(_ChartDistributionModel) _then) = __$ChartDistributionModelCopyWithImpl;
@override @useResult
$Res call({
 List<String> labels, List<int> data
});




}
/// @nodoc
class __$ChartDistributionModelCopyWithImpl<$Res>
    implements _$ChartDistributionModelCopyWith<$Res> {
  __$ChartDistributionModelCopyWithImpl(this._self, this._then);

  final _ChartDistributionModel _self;
  final $Res Function(_ChartDistributionModel) _then;

/// Create a copy of ChartDistributionModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? labels = null,Object? data = null,}) {
  return _then(_ChartDistributionModel(
labels: null == labels ? _self._labels : labels // ignore: cast_nullable_to_non_nullable
as List<String>,data: null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}


}


/// @nodoc
mixin _$DepartmentPerformanceModel {

 String get name; int get total; int get answered; int get rate;
/// Create a copy of DepartmentPerformanceModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DepartmentPerformanceModelCopyWith<DepartmentPerformanceModel> get copyWith => _$DepartmentPerformanceModelCopyWithImpl<DepartmentPerformanceModel>(this as DepartmentPerformanceModel, _$identity);

  /// Serializes this DepartmentPerformanceModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DepartmentPerformanceModel&&(identical(other.name, name) || other.name == name)&&(identical(other.total, total) || other.total == total)&&(identical(other.answered, answered) || other.answered == answered)&&(identical(other.rate, rate) || other.rate == rate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,total,answered,rate);

@override
String toString() {
  return 'DepartmentPerformanceModel(name: $name, total: $total, answered: $answered, rate: $rate)';
}


}

/// @nodoc
abstract mixin class $DepartmentPerformanceModelCopyWith<$Res>  {
  factory $DepartmentPerformanceModelCopyWith(DepartmentPerformanceModel value, $Res Function(DepartmentPerformanceModel) _then) = _$DepartmentPerformanceModelCopyWithImpl;
@useResult
$Res call({
 String name, int total, int answered, int rate
});




}
/// @nodoc
class _$DepartmentPerformanceModelCopyWithImpl<$Res>
    implements $DepartmentPerformanceModelCopyWith<$Res> {
  _$DepartmentPerformanceModelCopyWithImpl(this._self, this._then);

  final DepartmentPerformanceModel _self;
  final $Res Function(DepartmentPerformanceModel) _then;

/// Create a copy of DepartmentPerformanceModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? total = null,Object? answered = null,Object? rate = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,answered: null == answered ? _self.answered : answered // ignore: cast_nullable_to_non_nullable
as int,rate: null == rate ? _self.rate : rate // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DepartmentPerformanceModel].
extension DepartmentPerformanceModelPatterns on DepartmentPerformanceModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DepartmentPerformanceModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DepartmentPerformanceModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DepartmentPerformanceModel value)  $default,){
final _that = this;
switch (_that) {
case _DepartmentPerformanceModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DepartmentPerformanceModel value)?  $default,){
final _that = this;
switch (_that) {
case _DepartmentPerformanceModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  int total,  int answered,  int rate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DepartmentPerformanceModel() when $default != null:
return $default(_that.name,_that.total,_that.answered,_that.rate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  int total,  int answered,  int rate)  $default,) {final _that = this;
switch (_that) {
case _DepartmentPerformanceModel():
return $default(_that.name,_that.total,_that.answered,_that.rate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  int total,  int answered,  int rate)?  $default,) {final _that = this;
switch (_that) {
case _DepartmentPerformanceModel() when $default != null:
return $default(_that.name,_that.total,_that.answered,_that.rate);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _DepartmentPerformanceModel extends DepartmentPerformanceModel {
  const _DepartmentPerformanceModel({this.name = '', this.total = 0, this.answered = 0, this.rate = 0}): super._();
  factory _DepartmentPerformanceModel.fromJson(Map<String, dynamic> json) => _$DepartmentPerformanceModelFromJson(json);

@override@JsonKey() final  String name;
@override@JsonKey() final  int total;
@override@JsonKey() final  int answered;
@override@JsonKey() final  int rate;

/// Create a copy of DepartmentPerformanceModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DepartmentPerformanceModelCopyWith<_DepartmentPerformanceModel> get copyWith => __$DepartmentPerformanceModelCopyWithImpl<_DepartmentPerformanceModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DepartmentPerformanceModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DepartmentPerformanceModel&&(identical(other.name, name) || other.name == name)&&(identical(other.total, total) || other.total == total)&&(identical(other.answered, answered) || other.answered == answered)&&(identical(other.rate, rate) || other.rate == rate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,total,answered,rate);

@override
String toString() {
  return 'DepartmentPerformanceModel(name: $name, total: $total, answered: $answered, rate: $rate)';
}


}

/// @nodoc
abstract mixin class _$DepartmentPerformanceModelCopyWith<$Res> implements $DepartmentPerformanceModelCopyWith<$Res> {
  factory _$DepartmentPerformanceModelCopyWith(_DepartmentPerformanceModel value, $Res Function(_DepartmentPerformanceModel) _then) = __$DepartmentPerformanceModelCopyWithImpl;
@override @useResult
$Res call({
 String name, int total, int answered, int rate
});




}
/// @nodoc
class __$DepartmentPerformanceModelCopyWithImpl<$Res>
    implements _$DepartmentPerformanceModelCopyWith<$Res> {
  __$DepartmentPerformanceModelCopyWithImpl(this._self, this._then);

  final _DepartmentPerformanceModel _self;
  final $Res Function(_DepartmentPerformanceModel) _then;

/// Create a copy of DepartmentPerformanceModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? total = null,Object? answered = null,Object? rate = null,}) {
  return _then(_DepartmentPerformanceModel(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,answered: null == answered ? _self.answered : answered // ignore: cast_nullable_to_non_nullable
as int,rate: null == rate ? _self.rate : rate // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$DashboardStatsModel {

 int get totalQuestions; int get answeredQuestions; int get pendingQuestions; int get forwardedQuestions; ChartDistributionModel get departmentDistribution; ChartDistributionModel get statusDistribution; List<DepartmentPerformanceModel> get departmentPerformance;
/// Create a copy of DashboardStatsModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardStatsModelCopyWith<DashboardStatsModel> get copyWith => _$DashboardStatsModelCopyWithImpl<DashboardStatsModel>(this as DashboardStatsModel, _$identity);

  /// Serializes this DashboardStatsModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardStatsModel&&(identical(other.totalQuestions, totalQuestions) || other.totalQuestions == totalQuestions)&&(identical(other.answeredQuestions, answeredQuestions) || other.answeredQuestions == answeredQuestions)&&(identical(other.pendingQuestions, pendingQuestions) || other.pendingQuestions == pendingQuestions)&&(identical(other.forwardedQuestions, forwardedQuestions) || other.forwardedQuestions == forwardedQuestions)&&(identical(other.departmentDistribution, departmentDistribution) || other.departmentDistribution == departmentDistribution)&&(identical(other.statusDistribution, statusDistribution) || other.statusDistribution == statusDistribution)&&const DeepCollectionEquality().equals(other.departmentPerformance, departmentPerformance));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalQuestions,answeredQuestions,pendingQuestions,forwardedQuestions,departmentDistribution,statusDistribution,const DeepCollectionEquality().hash(departmentPerformance));

@override
String toString() {
  return 'DashboardStatsModel(totalQuestions: $totalQuestions, answeredQuestions: $answeredQuestions, pendingQuestions: $pendingQuestions, forwardedQuestions: $forwardedQuestions, departmentDistribution: $departmentDistribution, statusDistribution: $statusDistribution, departmentPerformance: $departmentPerformance)';
}


}

/// @nodoc
abstract mixin class $DashboardStatsModelCopyWith<$Res>  {
  factory $DashboardStatsModelCopyWith(DashboardStatsModel value, $Res Function(DashboardStatsModel) _then) = _$DashboardStatsModelCopyWithImpl;
@useResult
$Res call({
 int totalQuestions, int answeredQuestions, int pendingQuestions, int forwardedQuestions, ChartDistributionModel departmentDistribution, ChartDistributionModel statusDistribution, List<DepartmentPerformanceModel> departmentPerformance
});


$ChartDistributionModelCopyWith<$Res> get departmentDistribution;$ChartDistributionModelCopyWith<$Res> get statusDistribution;

}
/// @nodoc
class _$DashboardStatsModelCopyWithImpl<$Res>
    implements $DashboardStatsModelCopyWith<$Res> {
  _$DashboardStatsModelCopyWithImpl(this._self, this._then);

  final DashboardStatsModel _self;
  final $Res Function(DashboardStatsModel) _then;

/// Create a copy of DashboardStatsModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalQuestions = null,Object? answeredQuestions = null,Object? pendingQuestions = null,Object? forwardedQuestions = null,Object? departmentDistribution = null,Object? statusDistribution = null,Object? departmentPerformance = null,}) {
  return _then(_self.copyWith(
totalQuestions: null == totalQuestions ? _self.totalQuestions : totalQuestions // ignore: cast_nullable_to_non_nullable
as int,answeredQuestions: null == answeredQuestions ? _self.answeredQuestions : answeredQuestions // ignore: cast_nullable_to_non_nullable
as int,pendingQuestions: null == pendingQuestions ? _self.pendingQuestions : pendingQuestions // ignore: cast_nullable_to_non_nullable
as int,forwardedQuestions: null == forwardedQuestions ? _self.forwardedQuestions : forwardedQuestions // ignore: cast_nullable_to_non_nullable
as int,departmentDistribution: null == departmentDistribution ? _self.departmentDistribution : departmentDistribution // ignore: cast_nullable_to_non_nullable
as ChartDistributionModel,statusDistribution: null == statusDistribution ? _self.statusDistribution : statusDistribution // ignore: cast_nullable_to_non_nullable
as ChartDistributionModel,departmentPerformance: null == departmentPerformance ? _self.departmentPerformance : departmentPerformance // ignore: cast_nullable_to_non_nullable
as List<DepartmentPerformanceModel>,
  ));
}
/// Create a copy of DashboardStatsModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChartDistributionModelCopyWith<$Res> get departmentDistribution {
  
  return $ChartDistributionModelCopyWith<$Res>(_self.departmentDistribution, (value) {
    return _then(_self.copyWith(departmentDistribution: value));
  });
}/// Create a copy of DashboardStatsModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChartDistributionModelCopyWith<$Res> get statusDistribution {
  
  return $ChartDistributionModelCopyWith<$Res>(_self.statusDistribution, (value) {
    return _then(_self.copyWith(statusDistribution: value));
  });
}
}


/// Adds pattern-matching-related methods to [DashboardStatsModel].
extension DashboardStatsModelPatterns on DashboardStatsModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardStatsModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardStatsModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardStatsModel value)  $default,){
final _that = this;
switch (_that) {
case _DashboardStatsModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardStatsModel value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardStatsModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int totalQuestions,  int answeredQuestions,  int pendingQuestions,  int forwardedQuestions,  ChartDistributionModel departmentDistribution,  ChartDistributionModel statusDistribution,  List<DepartmentPerformanceModel> departmentPerformance)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardStatsModel() when $default != null:
return $default(_that.totalQuestions,_that.answeredQuestions,_that.pendingQuestions,_that.forwardedQuestions,_that.departmentDistribution,_that.statusDistribution,_that.departmentPerformance);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int totalQuestions,  int answeredQuestions,  int pendingQuestions,  int forwardedQuestions,  ChartDistributionModel departmentDistribution,  ChartDistributionModel statusDistribution,  List<DepartmentPerformanceModel> departmentPerformance)  $default,) {final _that = this;
switch (_that) {
case _DashboardStatsModel():
return $default(_that.totalQuestions,_that.answeredQuestions,_that.pendingQuestions,_that.forwardedQuestions,_that.departmentDistribution,_that.statusDistribution,_that.departmentPerformance);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int totalQuestions,  int answeredQuestions,  int pendingQuestions,  int forwardedQuestions,  ChartDistributionModel departmentDistribution,  ChartDistributionModel statusDistribution,  List<DepartmentPerformanceModel> departmentPerformance)?  $default,) {final _that = this;
switch (_that) {
case _DashboardStatsModel() when $default != null:
return $default(_that.totalQuestions,_that.answeredQuestions,_that.pendingQuestions,_that.forwardedQuestions,_that.departmentDistribution,_that.statusDistribution,_that.departmentPerformance);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _DashboardStatsModel extends DashboardStatsModel {
  const _DashboardStatsModel({this.totalQuestions = 0, this.answeredQuestions = 0, this.pendingQuestions = 0, this.forwardedQuestions = 0, required this.departmentDistribution, required this.statusDistribution, final  List<DepartmentPerformanceModel> departmentPerformance = const []}): _departmentPerformance = departmentPerformance,super._();
  factory _DashboardStatsModel.fromJson(Map<String, dynamic> json) => _$DashboardStatsModelFromJson(json);

@override@JsonKey() final  int totalQuestions;
@override@JsonKey() final  int answeredQuestions;
@override@JsonKey() final  int pendingQuestions;
@override@JsonKey() final  int forwardedQuestions;
@override final  ChartDistributionModel departmentDistribution;
@override final  ChartDistributionModel statusDistribution;
 final  List<DepartmentPerformanceModel> _departmentPerformance;
@override@JsonKey() List<DepartmentPerformanceModel> get departmentPerformance {
  if (_departmentPerformance is EqualUnmodifiableListView) return _departmentPerformance;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_departmentPerformance);
}


/// Create a copy of DashboardStatsModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardStatsModelCopyWith<_DashboardStatsModel> get copyWith => __$DashboardStatsModelCopyWithImpl<_DashboardStatsModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DashboardStatsModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardStatsModel&&(identical(other.totalQuestions, totalQuestions) || other.totalQuestions == totalQuestions)&&(identical(other.answeredQuestions, answeredQuestions) || other.answeredQuestions == answeredQuestions)&&(identical(other.pendingQuestions, pendingQuestions) || other.pendingQuestions == pendingQuestions)&&(identical(other.forwardedQuestions, forwardedQuestions) || other.forwardedQuestions == forwardedQuestions)&&(identical(other.departmentDistribution, departmentDistribution) || other.departmentDistribution == departmentDistribution)&&(identical(other.statusDistribution, statusDistribution) || other.statusDistribution == statusDistribution)&&const DeepCollectionEquality().equals(other._departmentPerformance, _departmentPerformance));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalQuestions,answeredQuestions,pendingQuestions,forwardedQuestions,departmentDistribution,statusDistribution,const DeepCollectionEquality().hash(_departmentPerformance));

@override
String toString() {
  return 'DashboardStatsModel(totalQuestions: $totalQuestions, answeredQuestions: $answeredQuestions, pendingQuestions: $pendingQuestions, forwardedQuestions: $forwardedQuestions, departmentDistribution: $departmentDistribution, statusDistribution: $statusDistribution, departmentPerformance: $departmentPerformance)';
}


}

/// @nodoc
abstract mixin class _$DashboardStatsModelCopyWith<$Res> implements $DashboardStatsModelCopyWith<$Res> {
  factory _$DashboardStatsModelCopyWith(_DashboardStatsModel value, $Res Function(_DashboardStatsModel) _then) = __$DashboardStatsModelCopyWithImpl;
@override @useResult
$Res call({
 int totalQuestions, int answeredQuestions, int pendingQuestions, int forwardedQuestions, ChartDistributionModel departmentDistribution, ChartDistributionModel statusDistribution, List<DepartmentPerformanceModel> departmentPerformance
});


@override $ChartDistributionModelCopyWith<$Res> get departmentDistribution;@override $ChartDistributionModelCopyWith<$Res> get statusDistribution;

}
/// @nodoc
class __$DashboardStatsModelCopyWithImpl<$Res>
    implements _$DashboardStatsModelCopyWith<$Res> {
  __$DashboardStatsModelCopyWithImpl(this._self, this._then);

  final _DashboardStatsModel _self;
  final $Res Function(_DashboardStatsModel) _then;

/// Create a copy of DashboardStatsModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalQuestions = null,Object? answeredQuestions = null,Object? pendingQuestions = null,Object? forwardedQuestions = null,Object? departmentDistribution = null,Object? statusDistribution = null,Object? departmentPerformance = null,}) {
  return _then(_DashboardStatsModel(
totalQuestions: null == totalQuestions ? _self.totalQuestions : totalQuestions // ignore: cast_nullable_to_non_nullable
as int,answeredQuestions: null == answeredQuestions ? _self.answeredQuestions : answeredQuestions // ignore: cast_nullable_to_non_nullable
as int,pendingQuestions: null == pendingQuestions ? _self.pendingQuestions : pendingQuestions // ignore: cast_nullable_to_non_nullable
as int,forwardedQuestions: null == forwardedQuestions ? _self.forwardedQuestions : forwardedQuestions // ignore: cast_nullable_to_non_nullable
as int,departmentDistribution: null == departmentDistribution ? _self.departmentDistribution : departmentDistribution // ignore: cast_nullable_to_non_nullable
as ChartDistributionModel,statusDistribution: null == statusDistribution ? _self.statusDistribution : statusDistribution // ignore: cast_nullable_to_non_nullable
as ChartDistributionModel,departmentPerformance: null == departmentPerformance ? _self._departmentPerformance : departmentPerformance // ignore: cast_nullable_to_non_nullable
as List<DepartmentPerformanceModel>,
  ));
}

/// Create a copy of DashboardStatsModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChartDistributionModelCopyWith<$Res> get departmentDistribution {
  
  return $ChartDistributionModelCopyWith<$Res>(_self.departmentDistribution, (value) {
    return _then(_self.copyWith(departmentDistribution: value));
  });
}/// Create a copy of DashboardStatsModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChartDistributionModelCopyWith<$Res> get statusDistribution {
  
  return $ChartDistributionModelCopyWith<$Res>(_self.statusDistribution, (value) {
    return _then(_self.copyWith(statusDistribution: value));
  });
}
}

// dart format on
