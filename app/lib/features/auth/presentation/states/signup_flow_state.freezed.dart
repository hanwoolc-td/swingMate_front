// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'signup_flow_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LessonTimeRangeInput {

 String get start; String get end;
/// Create a copy of LessonTimeRangeInput
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LessonTimeRangeInputCopyWith<LessonTimeRangeInput> get copyWith => _$LessonTimeRangeInputCopyWithImpl<LessonTimeRangeInput>(this as LessonTimeRangeInput, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as LessonTimeRangeInput;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LessonTimeRangeInput&&(identical(other.start, _this.start) || other.start == _this.start)&&(identical(other.end, _this.end) || other.end == _this.end));
}


@override
int get hashCode {
  final _this = this as LessonTimeRangeInput;
  return Object.hash(runtimeType,_this.start,_this.end);
}

@override
String toString() {
  final _this = this as LessonTimeRangeInput;
  return 'LessonTimeRangeInput(start: ${_this.start}, end: ${_this.end})';
}


}

/// @nodoc
abstract mixin class $LessonTimeRangeInputCopyWith<$Res>  {
  factory $LessonTimeRangeInputCopyWith(LessonTimeRangeInput value, $Res Function(LessonTimeRangeInput) _then) = _$LessonTimeRangeInputCopyWithImpl;
@useResult
$Res call({
 String start, String end
});




}
/// @nodoc
class _$LessonTimeRangeInputCopyWithImpl<$Res>
    implements $LessonTimeRangeInputCopyWith<$Res> {
  _$LessonTimeRangeInputCopyWithImpl(this._self, this._then);

  final LessonTimeRangeInput _self;
  final $Res Function(LessonTimeRangeInput) _then;

/// Create a copy of LessonTimeRangeInput
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? start = null,Object? end = null,}) {
  return _then(LessonTimeRangeInput(
start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as String,end: null == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [LessonTimeRangeInput].
extension LessonTimeRangeInputPatterns on LessonTimeRangeInput {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LessonTimeRangeInput value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LessonTimeRangeInput() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LessonTimeRangeInput value)  $default,){
final _that = this;
switch (_that) {
case _LessonTimeRangeInput():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LessonTimeRangeInput value)?  $default,){
final _that = this;
switch (_that) {
case _LessonTimeRangeInput() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String start,  String end)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LessonTimeRangeInput() when $default != null:
return $default(_that.start,_that.end);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String start,  String end)  $default,) {final _that = this;
switch (_that) {
case _LessonTimeRangeInput():
return $default(_that.start,_that.end);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String start,  String end)?  $default,) {final _that = this;
switch (_that) {
case _LessonTimeRangeInput() when $default != null:
return $default(_that.start,_that.end);case _:
  return null;

}
}

}

/// @nodoc


class _LessonTimeRangeInput implements LessonTimeRangeInput {
  const _LessonTimeRangeInput({this.start = '', this.end = ''});
  

@override@JsonKey() final  String start;
@override@JsonKey() final  String end;

/// Create a copy of LessonTimeRangeInput
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LessonTimeRangeInputCopyWith<_LessonTimeRangeInput> get copyWith => __$LessonTimeRangeInputCopyWithImpl<_LessonTimeRangeInput>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LessonTimeRangeInput&&(identical(other.start, start) || other.start == start)&&(identical(other.end, end) || other.end == end));
}


@override
int get hashCode {
    return Object.hash(runtimeType,start,end);
}

@override
String toString() {
    return 'LessonTimeRangeInput(start: $start, end: $end)';
}


}

/// @nodoc
abstract mixin class _$LessonTimeRangeInputCopyWith<$Res> implements $LessonTimeRangeInputCopyWith<$Res> {
  factory _$LessonTimeRangeInputCopyWith(_LessonTimeRangeInput value, $Res Function(_LessonTimeRangeInput) _then) = __$LessonTimeRangeInputCopyWithImpl;
@override @useResult
$Res call({
 String start, String end
});




}
/// @nodoc
class __$LessonTimeRangeInputCopyWithImpl<$Res>
    implements _$LessonTimeRangeInputCopyWith<$Res> {
  __$LessonTimeRangeInputCopyWithImpl(this._self, this._then);

  final _LessonTimeRangeInput _self;
  final $Res Function(_LessonTimeRangeInput) _then;

/// Create a copy of LessonTimeRangeInput
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? start = null,Object? end = null,}) {
  return _then(_LessonTimeRangeInput(
start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as String,end: null == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$MemberSignupDraft {

 Set<String> get selectedInterests; String? get selectedExperience; String get proCode;
/// Create a copy of MemberSignupDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MemberSignupDraftCopyWith<MemberSignupDraft> get copyWith => _$MemberSignupDraftCopyWithImpl<MemberSignupDraft>(this as MemberSignupDraft, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as MemberSignupDraft;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MemberSignupDraft&&const DeepCollectionEquality().equals(other.selectedInterests, _this.selectedInterests)&&(identical(other.selectedExperience, _this.selectedExperience) || other.selectedExperience == _this.selectedExperience)&&(identical(other.proCode, _this.proCode) || other.proCode == _this.proCode));
}


@override
int get hashCode {
  final _this = this as MemberSignupDraft;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.selectedInterests),_this.selectedExperience,_this.proCode);
}

@override
String toString() {
  final _this = this as MemberSignupDraft;
  return 'MemberSignupDraft(selectedInterests: ${_this.selectedInterests}, selectedExperience: ${_this.selectedExperience}, proCode: ${_this.proCode})';
}


}

/// @nodoc
abstract mixin class $MemberSignupDraftCopyWith<$Res>  {
  factory $MemberSignupDraftCopyWith(MemberSignupDraft value, $Res Function(MemberSignupDraft) _then) = _$MemberSignupDraftCopyWithImpl;
@useResult
$Res call({
 Set<String> selectedInterests, String? selectedExperience, String proCode
});




}
/// @nodoc
class _$MemberSignupDraftCopyWithImpl<$Res>
    implements $MemberSignupDraftCopyWith<$Res> {
  _$MemberSignupDraftCopyWithImpl(this._self, this._then);

  final MemberSignupDraft _self;
  final $Res Function(MemberSignupDraft) _then;

/// Create a copy of MemberSignupDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? selectedInterests = null,Object? selectedExperience = freezed,Object? proCode = null,}) {
  return _then(MemberSignupDraft(
selectedInterests: null == selectedInterests ? _self.selectedInterests : selectedInterests // ignore: cast_nullable_to_non_nullable
as Set<String>,selectedExperience: freezed == selectedExperience ? _self.selectedExperience : selectedExperience // ignore: cast_nullable_to_non_nullable
as String?,proCode: null == proCode ? _self.proCode : proCode // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [MemberSignupDraft].
extension MemberSignupDraftPatterns on MemberSignupDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MemberSignupDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MemberSignupDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MemberSignupDraft value)  $default,){
final _that = this;
switch (_that) {
case _MemberSignupDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MemberSignupDraft value)?  $default,){
final _that = this;
switch (_that) {
case _MemberSignupDraft() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Set<String> selectedInterests,  String? selectedExperience,  String proCode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MemberSignupDraft() when $default != null:
return $default(_that.selectedInterests,_that.selectedExperience,_that.proCode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Set<String> selectedInterests,  String? selectedExperience,  String proCode)  $default,) {final _that = this;
switch (_that) {
case _MemberSignupDraft():
return $default(_that.selectedInterests,_that.selectedExperience,_that.proCode);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Set<String> selectedInterests,  String? selectedExperience,  String proCode)?  $default,) {final _that = this;
switch (_that) {
case _MemberSignupDraft() when $default != null:
return $default(_that.selectedInterests,_that.selectedExperience,_that.proCode);case _:
  return null;

}
}

}

/// @nodoc


class _MemberSignupDraft implements MemberSignupDraft {
  const _MemberSignupDraft({ Set<String> selectedInterests = const <String>{}, this.selectedExperience, this.proCode = ''}): _selectedInterests = selectedInterests;
  

 final  Set<String> _selectedInterests;
@override@JsonKey() Set<String> get selectedInterests {
  if (_selectedInterests is EqualUnmodifiableSetView) return _selectedInterests;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_selectedInterests);
}

@override final  String? selectedExperience;
@override@JsonKey() final  String proCode;

/// Create a copy of MemberSignupDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MemberSignupDraftCopyWith<_MemberSignupDraft> get copyWith => __$MemberSignupDraftCopyWithImpl<_MemberSignupDraft>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MemberSignupDraft&&const DeepCollectionEquality().equals(other.selectedInterests, _selectedInterests)&&(identical(other.selectedExperience, selectedExperience) || other.selectedExperience == selectedExperience)&&(identical(other.proCode, proCode) || other.proCode == proCode));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_selectedInterests),selectedExperience,proCode);
}

@override
String toString() {
    return 'MemberSignupDraft(selectedInterests: $selectedInterests, selectedExperience: $selectedExperience, proCode: $proCode)';
}


}

/// @nodoc
abstract mixin class _$MemberSignupDraftCopyWith<$Res> implements $MemberSignupDraftCopyWith<$Res> {
  factory _$MemberSignupDraftCopyWith(_MemberSignupDraft value, $Res Function(_MemberSignupDraft) _then) = __$MemberSignupDraftCopyWithImpl;
@override @useResult
$Res call({
 Set<String> selectedInterests, String? selectedExperience, String proCode
});




}
/// @nodoc
class __$MemberSignupDraftCopyWithImpl<$Res>
    implements _$MemberSignupDraftCopyWith<$Res> {
  __$MemberSignupDraftCopyWithImpl(this._self, this._then);

  final _MemberSignupDraft _self;
  final $Res Function(_MemberSignupDraft) _then;

/// Create a copy of MemberSignupDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? selectedInterests = null,Object? selectedExperience = freezed,Object? proCode = null,}) {
  return _then(_MemberSignupDraft(
selectedInterests: null == selectedInterests ? _self._selectedInterests : selectedInterests // ignore: cast_nullable_to_non_nullable
as Set<String>,selectedExperience: freezed == selectedExperience ? _self.selectedExperience : selectedExperience // ignore: cast_nullable_to_non_nullable
as String?,proCode: null == proCode ? _self.proCode : proCode // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$ProSignupDraft {

 String get introduction; List<String> get careers; Set<String> get selectedDays; List<LessonTimeRangeInput> get sharedRanges; Map<String, List<LessonTimeRangeInput>> get dayRanges; bool get isDaySpecific;
/// Create a copy of ProSignupDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProSignupDraftCopyWith<ProSignupDraft> get copyWith => _$ProSignupDraftCopyWithImpl<ProSignupDraft>(this as ProSignupDraft, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ProSignupDraft;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProSignupDraft&&(identical(other.introduction, _this.introduction) || other.introduction == _this.introduction)&&const DeepCollectionEquality().equals(other.careers, _this.careers)&&const DeepCollectionEquality().equals(other.selectedDays, _this.selectedDays)&&const DeepCollectionEquality().equals(other.sharedRanges, _this.sharedRanges)&&const DeepCollectionEquality().equals(other.dayRanges, _this.dayRanges)&&(identical(other.isDaySpecific, _this.isDaySpecific) || other.isDaySpecific == _this.isDaySpecific));
}


@override
int get hashCode {
  final _this = this as ProSignupDraft;
  return Object.hash(runtimeType,_this.introduction,const DeepCollectionEquality().hash(_this.careers),const DeepCollectionEquality().hash(_this.selectedDays),const DeepCollectionEquality().hash(_this.sharedRanges),const DeepCollectionEquality().hash(_this.dayRanges),_this.isDaySpecific);
}

@override
String toString() {
  final _this = this as ProSignupDraft;
  return 'ProSignupDraft(introduction: ${_this.introduction}, careers: ${_this.careers}, selectedDays: ${_this.selectedDays}, sharedRanges: ${_this.sharedRanges}, dayRanges: ${_this.dayRanges}, isDaySpecific: ${_this.isDaySpecific})';
}


}

/// @nodoc
abstract mixin class $ProSignupDraftCopyWith<$Res>  {
  factory $ProSignupDraftCopyWith(ProSignupDraft value, $Res Function(ProSignupDraft) _then) = _$ProSignupDraftCopyWithImpl;
@useResult
$Res call({
 String introduction, List<String> careers, Set<String> selectedDays, List<LessonTimeRangeInput> sharedRanges, Map<String, List<LessonTimeRangeInput>> dayRanges, bool isDaySpecific
});




}
/// @nodoc
class _$ProSignupDraftCopyWithImpl<$Res>
    implements $ProSignupDraftCopyWith<$Res> {
  _$ProSignupDraftCopyWithImpl(this._self, this._then);

  final ProSignupDraft _self;
  final $Res Function(ProSignupDraft) _then;

/// Create a copy of ProSignupDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? introduction = null,Object? careers = null,Object? selectedDays = null,Object? sharedRanges = null,Object? dayRanges = null,Object? isDaySpecific = null,}) {
  return _then(ProSignupDraft(
introduction: null == introduction ? _self.introduction : introduction // ignore: cast_nullable_to_non_nullable
as String,careers: null == careers ? _self.careers : careers // ignore: cast_nullable_to_non_nullable
as List<String>,selectedDays: null == selectedDays ? _self.selectedDays : selectedDays // ignore: cast_nullable_to_non_nullable
as Set<String>,sharedRanges: null == sharedRanges ? _self.sharedRanges : sharedRanges // ignore: cast_nullable_to_non_nullable
as List<LessonTimeRangeInput>,dayRanges: null == dayRanges ? _self.dayRanges : dayRanges // ignore: cast_nullable_to_non_nullable
as Map<String, List<LessonTimeRangeInput>>,isDaySpecific: null == isDaySpecific ? _self.isDaySpecific : isDaySpecific // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ProSignupDraft].
extension ProSignupDraftPatterns on ProSignupDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProSignupDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProSignupDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProSignupDraft value)  $default,){
final _that = this;
switch (_that) {
case _ProSignupDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProSignupDraft value)?  $default,){
final _that = this;
switch (_that) {
case _ProSignupDraft() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String introduction,  List<String> careers,  Set<String> selectedDays,  List<LessonTimeRangeInput> sharedRanges,  Map<String, List<LessonTimeRangeInput>> dayRanges,  bool isDaySpecific)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProSignupDraft() when $default != null:
return $default(_that.introduction,_that.careers,_that.selectedDays,_that.sharedRanges,_that.dayRanges,_that.isDaySpecific);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String introduction,  List<String> careers,  Set<String> selectedDays,  List<LessonTimeRangeInput> sharedRanges,  Map<String, List<LessonTimeRangeInput>> dayRanges,  bool isDaySpecific)  $default,) {final _that = this;
switch (_that) {
case _ProSignupDraft():
return $default(_that.introduction,_that.careers,_that.selectedDays,_that.sharedRanges,_that.dayRanges,_that.isDaySpecific);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String introduction,  List<String> careers,  Set<String> selectedDays,  List<LessonTimeRangeInput> sharedRanges,  Map<String, List<LessonTimeRangeInput>> dayRanges,  bool isDaySpecific)?  $default,) {final _that = this;
switch (_that) {
case _ProSignupDraft() when $default != null:
return $default(_that.introduction,_that.careers,_that.selectedDays,_that.sharedRanges,_that.dayRanges,_that.isDaySpecific);case _:
  return null;

}
}

}

/// @nodoc


class _ProSignupDraft implements ProSignupDraft {
  const _ProSignupDraft({this.introduction = '',  List<String> careers = const <String>[''],  Set<String> selectedDays = const <String>{'월', '화', '수', '목', '금'},  List<LessonTimeRangeInput> sharedRanges = const <LessonTimeRangeInput>[LessonTimeRangeInput(start: '09:00', end: '13:00'), LessonTimeRangeInput(start: '18:00', end: '22:00')],  Map<String, List<LessonTimeRangeInput>> dayRanges = const <String, List<LessonTimeRangeInput>>{'월' : [LessonTimeRangeInput(start: '09:00', end: '18:00')], '화' : [LessonTimeRangeInput(start: '09:00', end: '18:00')], '수' : [LessonTimeRangeInput(start: '09:00', end: '18:00')], '목' : [LessonTimeRangeInput(start: '09:00', end: '18:00')], '금' : [LessonTimeRangeInput(start: '09:00', end: '18:00')], '토' : [LessonTimeRangeInput(start: '09:00', end: '18:00')], '일' : [LessonTimeRangeInput(start: '09:00', end: '18:00')]}, this.isDaySpecific = false}): _careers = careers,_selectedDays = selectedDays,_sharedRanges = sharedRanges,_dayRanges = dayRanges;
  

@override@JsonKey() final  String introduction;
 final  List<String> _careers;
@override@JsonKey() List<String> get careers {
  if (_careers is EqualUnmodifiableListView) return _careers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_careers);
}

 final  Set<String> _selectedDays;
@override@JsonKey() Set<String> get selectedDays {
  if (_selectedDays is EqualUnmodifiableSetView) return _selectedDays;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_selectedDays);
}

 final  List<LessonTimeRangeInput> _sharedRanges;
@override@JsonKey() List<LessonTimeRangeInput> get sharedRanges {
  if (_sharedRanges is EqualUnmodifiableListView) return _sharedRanges;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sharedRanges);
}

 final  Map<String, List<LessonTimeRangeInput>> _dayRanges;
@override@JsonKey() Map<String, List<LessonTimeRangeInput>> get dayRanges {
  if (_dayRanges is EqualUnmodifiableMapView) return _dayRanges;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_dayRanges);
}

@override@JsonKey() final  bool isDaySpecific;

/// Create a copy of ProSignupDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProSignupDraftCopyWith<_ProSignupDraft> get copyWith => __$ProSignupDraftCopyWithImpl<_ProSignupDraft>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProSignupDraft&&(identical(other.introduction, introduction) || other.introduction == introduction)&&const DeepCollectionEquality().equals(other.careers, _careers)&&const DeepCollectionEquality().equals(other.selectedDays, _selectedDays)&&const DeepCollectionEquality().equals(other.sharedRanges, _sharedRanges)&&const DeepCollectionEquality().equals(other.dayRanges, _dayRanges)&&(identical(other.isDaySpecific, isDaySpecific) || other.isDaySpecific == isDaySpecific));
}


@override
int get hashCode {
    return Object.hash(runtimeType,introduction,const DeepCollectionEquality().hash(_careers),const DeepCollectionEquality().hash(_selectedDays),const DeepCollectionEquality().hash(_sharedRanges),const DeepCollectionEquality().hash(_dayRanges),isDaySpecific);
}

@override
String toString() {
    return 'ProSignupDraft(introduction: $introduction, careers: $careers, selectedDays: $selectedDays, sharedRanges: $sharedRanges, dayRanges: $dayRanges, isDaySpecific: $isDaySpecific)';
}


}

/// @nodoc
abstract mixin class _$ProSignupDraftCopyWith<$Res> implements $ProSignupDraftCopyWith<$Res> {
  factory _$ProSignupDraftCopyWith(_ProSignupDraft value, $Res Function(_ProSignupDraft) _then) = __$ProSignupDraftCopyWithImpl;
@override @useResult
$Res call({
 String introduction, List<String> careers, Set<String> selectedDays, List<LessonTimeRangeInput> sharedRanges, Map<String, List<LessonTimeRangeInput>> dayRanges, bool isDaySpecific
});




}
/// @nodoc
class __$ProSignupDraftCopyWithImpl<$Res>
    implements _$ProSignupDraftCopyWith<$Res> {
  __$ProSignupDraftCopyWithImpl(this._self, this._then);

  final _ProSignupDraft _self;
  final $Res Function(_ProSignupDraft) _then;

/// Create a copy of ProSignupDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? introduction = null,Object? careers = null,Object? selectedDays = null,Object? sharedRanges = null,Object? dayRanges = null,Object? isDaySpecific = null,}) {
  return _then(_ProSignupDraft(
introduction: null == introduction ? _self.introduction : introduction // ignore: cast_nullable_to_non_nullable
as String,careers: null == careers ? _self._careers : careers // ignore: cast_nullable_to_non_nullable
as List<String>,selectedDays: null == selectedDays ? _self._selectedDays : selectedDays // ignore: cast_nullable_to_non_nullable
as Set<String>,sharedRanges: null == sharedRanges ? _self._sharedRanges : sharedRanges // ignore: cast_nullable_to_non_nullable
as List<LessonTimeRangeInput>,dayRanges: null == dayRanges ? _self._dayRanges : dayRanges // ignore: cast_nullable_to_non_nullable
as Map<String, List<LessonTimeRangeInput>>,isDaySpecific: null == isDaySpecific ? _self.isDaySpecific : isDaySpecific // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$SignupFlowState {

 SignupRole? get role; String get name; String get phoneNumber; String get verificationCode; Duration get verificationRemaining; VerificationAction get verificationAction; String? get verificationTestCode; VerificationFailure? get verificationFailure; SubmissionAction get submissionAction; SubmissionFailure? get submissionFailure; MemberSignupDraft get member; ProSignupDraft get pro;
/// Create a copy of SignupFlowState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SignupFlowStateCopyWith<SignupFlowState> get copyWith => _$SignupFlowStateCopyWithImpl<SignupFlowState>(this as SignupFlowState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SignupFlowState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SignupFlowState&&(identical(other.role, _this.role) || other.role == _this.role)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.phoneNumber, _this.phoneNumber) || other.phoneNumber == _this.phoneNumber)&&(identical(other.verificationCode, _this.verificationCode) || other.verificationCode == _this.verificationCode)&&(identical(other.verificationRemaining, _this.verificationRemaining) || other.verificationRemaining == _this.verificationRemaining)&&(identical(other.verificationAction, _this.verificationAction) || other.verificationAction == _this.verificationAction)&&(identical(other.verificationTestCode, _this.verificationTestCode) || other.verificationTestCode == _this.verificationTestCode)&&(identical(other.verificationFailure, _this.verificationFailure) || other.verificationFailure == _this.verificationFailure)&&(identical(other.submissionAction, _this.submissionAction) || other.submissionAction == _this.submissionAction)&&(identical(other.submissionFailure, _this.submissionFailure) || other.submissionFailure == _this.submissionFailure)&&(identical(other.member, _this.member) || other.member == _this.member)&&(identical(other.pro, _this.pro) || other.pro == _this.pro));
}


@override
int get hashCode {
  final _this = this as SignupFlowState;
  return Object.hash(runtimeType,_this.role,_this.name,_this.phoneNumber,_this.verificationCode,_this.verificationRemaining,_this.verificationAction,_this.verificationTestCode,_this.verificationFailure,_this.submissionAction,_this.submissionFailure,_this.member,_this.pro);
}

@override
String toString() {
  final _this = this as SignupFlowState;
  return 'SignupFlowState(role: ${_this.role}, name: ${_this.name}, phoneNumber: ${_this.phoneNumber}, verificationCode: ${_this.verificationCode}, verificationRemaining: ${_this.verificationRemaining}, verificationAction: ${_this.verificationAction}, verificationTestCode: ${_this.verificationTestCode}, verificationFailure: ${_this.verificationFailure}, submissionAction: ${_this.submissionAction}, submissionFailure: ${_this.submissionFailure}, member: ${_this.member}, pro: ${_this.pro})';
}


}

/// @nodoc
abstract mixin class $SignupFlowStateCopyWith<$Res>  {
  factory $SignupFlowStateCopyWith(SignupFlowState value, $Res Function(SignupFlowState) _then) = _$SignupFlowStateCopyWithImpl;
@useResult
$Res call({
 SignupRole? role, String name, String phoneNumber, String verificationCode, Duration verificationRemaining, VerificationAction verificationAction, String? verificationTestCode, VerificationFailure? verificationFailure, SubmissionAction submissionAction, SubmissionFailure? submissionFailure, MemberSignupDraft member, ProSignupDraft pro
});


$MemberSignupDraftCopyWith<$Res> get member;$ProSignupDraftCopyWith<$Res> get pro;

}
/// @nodoc
class _$SignupFlowStateCopyWithImpl<$Res>
    implements $SignupFlowStateCopyWith<$Res> {
  _$SignupFlowStateCopyWithImpl(this._self, this._then);

  final SignupFlowState _self;
  final $Res Function(SignupFlowState) _then;

/// Create a copy of SignupFlowState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? role = freezed,Object? name = null,Object? phoneNumber = null,Object? verificationCode = null,Object? verificationRemaining = null,Object? verificationAction = null,Object? verificationTestCode = freezed,Object? verificationFailure = freezed,Object? submissionAction = null,Object? submissionFailure = freezed,Object? member = null,Object? pro = null,}) {
  return _then(SignupFlowState(
role: freezed == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as SignupRole?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phoneNumber: null == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String,verificationCode: null == verificationCode ? _self.verificationCode : verificationCode // ignore: cast_nullable_to_non_nullable
as String,verificationRemaining: null == verificationRemaining ? _self.verificationRemaining : verificationRemaining // ignore: cast_nullable_to_non_nullable
as Duration,verificationAction: null == verificationAction ? _self.verificationAction : verificationAction // ignore: cast_nullable_to_non_nullable
as VerificationAction,verificationTestCode: freezed == verificationTestCode ? _self.verificationTestCode : verificationTestCode // ignore: cast_nullable_to_non_nullable
as String?,verificationFailure: freezed == verificationFailure ? _self.verificationFailure : verificationFailure // ignore: cast_nullable_to_non_nullable
as VerificationFailure?,submissionAction: null == submissionAction ? _self.submissionAction : submissionAction // ignore: cast_nullable_to_non_nullable
as SubmissionAction,submissionFailure: freezed == submissionFailure ? _self.submissionFailure : submissionFailure // ignore: cast_nullable_to_non_nullable
as SubmissionFailure?,member: null == member ? _self.member : member // ignore: cast_nullable_to_non_nullable
as MemberSignupDraft,pro: null == pro ? _self.pro : pro // ignore: cast_nullable_to_non_nullable
as ProSignupDraft,
  ));
}
/// Create a copy of SignupFlowState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MemberSignupDraftCopyWith<$Res> get member {
  
  return $MemberSignupDraftCopyWith<$Res>(_self.member, (value) {
    return _then(_self.copyWith(member: value));
  });
}/// Create a copy of SignupFlowState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProSignupDraftCopyWith<$Res> get pro {
  
  return $ProSignupDraftCopyWith<$Res>(_self.pro, (value) {
    return _then(_self.copyWith(pro: value));
  });
}
}


/// Adds pattern-matching-related methods to [SignupFlowState].
extension SignupFlowStatePatterns on SignupFlowState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SignupFlowState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SignupFlowState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SignupFlowState value)  $default,){
final _that = this;
switch (_that) {
case _SignupFlowState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SignupFlowState value)?  $default,){
final _that = this;
switch (_that) {
case _SignupFlowState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( SignupRole? role,  String name,  String phoneNumber,  String verificationCode,  Duration verificationRemaining,  VerificationAction verificationAction,  String? verificationTestCode,  VerificationFailure? verificationFailure,  SubmissionAction submissionAction,  SubmissionFailure? submissionFailure,  MemberSignupDraft member,  ProSignupDraft pro)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SignupFlowState() when $default != null:
return $default(_that.role,_that.name,_that.phoneNumber,_that.verificationCode,_that.verificationRemaining,_that.verificationAction,_that.verificationTestCode,_that.verificationFailure,_that.submissionAction,_that.submissionFailure,_that.member,_that.pro);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( SignupRole? role,  String name,  String phoneNumber,  String verificationCode,  Duration verificationRemaining,  VerificationAction verificationAction,  String? verificationTestCode,  VerificationFailure? verificationFailure,  SubmissionAction submissionAction,  SubmissionFailure? submissionFailure,  MemberSignupDraft member,  ProSignupDraft pro)  $default,) {final _that = this;
switch (_that) {
case _SignupFlowState():
return $default(_that.role,_that.name,_that.phoneNumber,_that.verificationCode,_that.verificationRemaining,_that.verificationAction,_that.verificationTestCode,_that.verificationFailure,_that.submissionAction,_that.submissionFailure,_that.member,_that.pro);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( SignupRole? role,  String name,  String phoneNumber,  String verificationCode,  Duration verificationRemaining,  VerificationAction verificationAction,  String? verificationTestCode,  VerificationFailure? verificationFailure,  SubmissionAction submissionAction,  SubmissionFailure? submissionFailure,  MemberSignupDraft member,  ProSignupDraft pro)?  $default,) {final _that = this;
switch (_that) {
case _SignupFlowState() when $default != null:
return $default(_that.role,_that.name,_that.phoneNumber,_that.verificationCode,_that.verificationRemaining,_that.verificationAction,_that.verificationTestCode,_that.verificationFailure,_that.submissionAction,_that.submissionFailure,_that.member,_that.pro);case _:
  return null;

}
}

}

/// @nodoc


class _SignupFlowState implements SignupFlowState {
  const _SignupFlowState({this.role, this.name = '', this.phoneNumber = '', this.verificationCode = '', this.verificationRemaining = Duration.zero, this.verificationAction = VerificationAction.idle, this.verificationTestCode, this.verificationFailure, this.submissionAction = SubmissionAction.idle, this.submissionFailure, this.member = const MemberSignupDraft(), this.pro = const ProSignupDraft()});
  

@override final  SignupRole? role;
@override@JsonKey() final  String name;
@override@JsonKey() final  String phoneNumber;
@override@JsonKey() final  String verificationCode;
@override@JsonKey() final  Duration verificationRemaining;
@override@JsonKey() final  VerificationAction verificationAction;
@override final  String? verificationTestCode;
@override final  VerificationFailure? verificationFailure;
@override@JsonKey() final  SubmissionAction submissionAction;
@override final  SubmissionFailure? submissionFailure;
@override@JsonKey() final  MemberSignupDraft member;
@override@JsonKey() final  ProSignupDraft pro;

/// Create a copy of SignupFlowState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SignupFlowStateCopyWith<_SignupFlowState> get copyWith => __$SignupFlowStateCopyWithImpl<_SignupFlowState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SignupFlowState&&(identical(other.role, role) || other.role == role)&&(identical(other.name, name) || other.name == name)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.verificationCode, verificationCode) || other.verificationCode == verificationCode)&&(identical(other.verificationRemaining, verificationRemaining) || other.verificationRemaining == verificationRemaining)&&(identical(other.verificationAction, verificationAction) || other.verificationAction == verificationAction)&&(identical(other.verificationTestCode, verificationTestCode) || other.verificationTestCode == verificationTestCode)&&(identical(other.verificationFailure, verificationFailure) || other.verificationFailure == verificationFailure)&&(identical(other.submissionAction, submissionAction) || other.submissionAction == submissionAction)&&(identical(other.submissionFailure, submissionFailure) || other.submissionFailure == submissionFailure)&&(identical(other.member, member) || other.member == member)&&(identical(other.pro, pro) || other.pro == pro));
}


@override
int get hashCode {
    return Object.hash(runtimeType,role,name,phoneNumber,verificationCode,verificationRemaining,verificationAction,verificationTestCode,verificationFailure,submissionAction,submissionFailure,member,pro);
}

@override
String toString() {
    return 'SignupFlowState(role: $role, name: $name, phoneNumber: $phoneNumber, verificationCode: $verificationCode, verificationRemaining: $verificationRemaining, verificationAction: $verificationAction, verificationTestCode: $verificationTestCode, verificationFailure: $verificationFailure, submissionAction: $submissionAction, submissionFailure: $submissionFailure, member: $member, pro: $pro)';
}


}

/// @nodoc
abstract mixin class _$SignupFlowStateCopyWith<$Res> implements $SignupFlowStateCopyWith<$Res> {
  factory _$SignupFlowStateCopyWith(_SignupFlowState value, $Res Function(_SignupFlowState) _then) = __$SignupFlowStateCopyWithImpl;
@override @useResult
$Res call({
 SignupRole? role, String name, String phoneNumber, String verificationCode, Duration verificationRemaining, VerificationAction verificationAction, String? verificationTestCode, VerificationFailure? verificationFailure, SubmissionAction submissionAction, SubmissionFailure? submissionFailure, MemberSignupDraft member, ProSignupDraft pro
});


@override $MemberSignupDraftCopyWith<$Res> get member;@override $ProSignupDraftCopyWith<$Res> get pro;

}
/// @nodoc
class __$SignupFlowStateCopyWithImpl<$Res>
    implements _$SignupFlowStateCopyWith<$Res> {
  __$SignupFlowStateCopyWithImpl(this._self, this._then);

  final _SignupFlowState _self;
  final $Res Function(_SignupFlowState) _then;

/// Create a copy of SignupFlowState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? role = freezed,Object? name = null,Object? phoneNumber = null,Object? verificationCode = null,Object? verificationRemaining = null,Object? verificationAction = null,Object? verificationTestCode = freezed,Object? verificationFailure = freezed,Object? submissionAction = null,Object? submissionFailure = freezed,Object? member = null,Object? pro = null,}) {
  return _then(_SignupFlowState(
role: freezed == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as SignupRole?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phoneNumber: null == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String,verificationCode: null == verificationCode ? _self.verificationCode : verificationCode // ignore: cast_nullable_to_non_nullable
as String,verificationRemaining: null == verificationRemaining ? _self.verificationRemaining : verificationRemaining // ignore: cast_nullable_to_non_nullable
as Duration,verificationAction: null == verificationAction ? _self.verificationAction : verificationAction // ignore: cast_nullable_to_non_nullable
as VerificationAction,verificationTestCode: freezed == verificationTestCode ? _self.verificationTestCode : verificationTestCode // ignore: cast_nullable_to_non_nullable
as String?,verificationFailure: freezed == verificationFailure ? _self.verificationFailure : verificationFailure // ignore: cast_nullable_to_non_nullable
as VerificationFailure?,submissionAction: null == submissionAction ? _self.submissionAction : submissionAction // ignore: cast_nullable_to_non_nullable
as SubmissionAction,submissionFailure: freezed == submissionFailure ? _self.submissionFailure : submissionFailure // ignore: cast_nullable_to_non_nullable
as SubmissionFailure?,member: null == member ? _self.member : member // ignore: cast_nullable_to_non_nullable
as MemberSignupDraft,pro: null == pro ? _self.pro : pro // ignore: cast_nullable_to_non_nullable
as ProSignupDraft,
  ));
}

/// Create a copy of SignupFlowState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MemberSignupDraftCopyWith<$Res> get member {
  
  return $MemberSignupDraftCopyWith<$Res>(_self.member, (value) {
    return _then(_self.copyWith(member: value));
  });
}/// Create a copy of SignupFlowState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProSignupDraftCopyWith<$Res> get pro {
  
  return $ProSignupDraftCopyWith<$Res>(_self.pro, (value) {
    return _then(_self.copyWith(pro: value));
  });
}
}

// dart format on
