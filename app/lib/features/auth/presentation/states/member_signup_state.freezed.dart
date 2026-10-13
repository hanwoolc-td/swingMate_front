// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'member_signup_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MemberSignupState {

 String get name; String get phoneNumber; String get verificationCode; Duration get verificationRemaining; bool get isSendingVerificationCode; bool get isVerifyingVerificationCode; String? get verificationTestCode; String? get verificationError; Set<String> get selectedInterests; String? get selectedExperience; String get proCode; String? get nameError; String? get phoneNumberError; String? get verificationCodeError; String? get interestsError; String? get experienceError; String? get proCodeError;
/// Create a copy of MemberSignupState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MemberSignupStateCopyWith<MemberSignupState> get copyWith => _$MemberSignupStateCopyWithImpl<MemberSignupState>(this as MemberSignupState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as MemberSignupState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MemberSignupState&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.phoneNumber, _this.phoneNumber) || other.phoneNumber == _this.phoneNumber)&&(identical(other.verificationCode, _this.verificationCode) || other.verificationCode == _this.verificationCode)&&(identical(other.verificationRemaining, _this.verificationRemaining) || other.verificationRemaining == _this.verificationRemaining)&&(identical(other.isSendingVerificationCode, _this.isSendingVerificationCode) || other.isSendingVerificationCode == _this.isSendingVerificationCode)&&(identical(other.isVerifyingVerificationCode, _this.isVerifyingVerificationCode) || other.isVerifyingVerificationCode == _this.isVerifyingVerificationCode)&&(identical(other.verificationTestCode, _this.verificationTestCode) || other.verificationTestCode == _this.verificationTestCode)&&(identical(other.verificationError, _this.verificationError) || other.verificationError == _this.verificationError)&&const DeepCollectionEquality().equals(other.selectedInterests, _this.selectedInterests)&&(identical(other.selectedExperience, _this.selectedExperience) || other.selectedExperience == _this.selectedExperience)&&(identical(other.proCode, _this.proCode) || other.proCode == _this.proCode)&&(identical(other.nameError, _this.nameError) || other.nameError == _this.nameError)&&(identical(other.phoneNumberError, _this.phoneNumberError) || other.phoneNumberError == _this.phoneNumberError)&&(identical(other.verificationCodeError, _this.verificationCodeError) || other.verificationCodeError == _this.verificationCodeError)&&(identical(other.interestsError, _this.interestsError) || other.interestsError == _this.interestsError)&&(identical(other.experienceError, _this.experienceError) || other.experienceError == _this.experienceError)&&(identical(other.proCodeError, _this.proCodeError) || other.proCodeError == _this.proCodeError));
}


@override
int get hashCode {
  final _this = this as MemberSignupState;
  return Object.hash(runtimeType,_this.name,_this.phoneNumber,_this.verificationCode,_this.verificationRemaining,_this.isSendingVerificationCode,_this.isVerifyingVerificationCode,_this.verificationTestCode,_this.verificationError,const DeepCollectionEquality().hash(_this.selectedInterests),_this.selectedExperience,_this.proCode,_this.nameError,_this.phoneNumberError,_this.verificationCodeError,_this.interestsError,_this.experienceError,_this.proCodeError);
}

@override
String toString() {
  final _this = this as MemberSignupState;
  return 'MemberSignupState(name: ${_this.name}, phoneNumber: ${_this.phoneNumber}, verificationCode: ${_this.verificationCode}, verificationRemaining: ${_this.verificationRemaining}, isSendingVerificationCode: ${_this.isSendingVerificationCode}, isVerifyingVerificationCode: ${_this.isVerifyingVerificationCode}, verificationTestCode: ${_this.verificationTestCode}, verificationError: ${_this.verificationError}, selectedInterests: ${_this.selectedInterests}, selectedExperience: ${_this.selectedExperience}, proCode: ${_this.proCode}, nameError: ${_this.nameError}, phoneNumberError: ${_this.phoneNumberError}, verificationCodeError: ${_this.verificationCodeError}, interestsError: ${_this.interestsError}, experienceError: ${_this.experienceError}, proCodeError: ${_this.proCodeError})';
}


}

/// @nodoc
abstract mixin class $MemberSignupStateCopyWith<$Res>  {
  factory $MemberSignupStateCopyWith(MemberSignupState value, $Res Function(MemberSignupState) _then) = _$MemberSignupStateCopyWithImpl;
@useResult
$Res call({
 String name, String phoneNumber, String verificationCode, Duration verificationRemaining, bool isSendingVerificationCode, bool isVerifyingVerificationCode, String? verificationTestCode, String? verificationError, Set<String> selectedInterests, String? selectedExperience, String proCode, String? nameError, String? phoneNumberError, String? verificationCodeError, String? interestsError, String? experienceError, String? proCodeError
});




}
/// @nodoc
class _$MemberSignupStateCopyWithImpl<$Res>
    implements $MemberSignupStateCopyWith<$Res> {
  _$MemberSignupStateCopyWithImpl(this._self, this._then);

  final MemberSignupState _self;
  final $Res Function(MemberSignupState) _then;

/// Create a copy of MemberSignupState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? phoneNumber = null,Object? verificationCode = null,Object? verificationRemaining = null,Object? isSendingVerificationCode = null,Object? isVerifyingVerificationCode = null,Object? verificationTestCode = freezed,Object? verificationError = freezed,Object? selectedInterests = null,Object? selectedExperience = freezed,Object? proCode = null,Object? nameError = freezed,Object? phoneNumberError = freezed,Object? verificationCodeError = freezed,Object? interestsError = freezed,Object? experienceError = freezed,Object? proCodeError = freezed,}) {
  return _then(MemberSignupState(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phoneNumber: null == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String,verificationCode: null == verificationCode ? _self.verificationCode : verificationCode // ignore: cast_nullable_to_non_nullable
as String,verificationRemaining: null == verificationRemaining ? _self.verificationRemaining : verificationRemaining // ignore: cast_nullable_to_non_nullable
as Duration,isSendingVerificationCode: null == isSendingVerificationCode ? _self.isSendingVerificationCode : isSendingVerificationCode // ignore: cast_nullable_to_non_nullable
as bool,isVerifyingVerificationCode: null == isVerifyingVerificationCode ? _self.isVerifyingVerificationCode : isVerifyingVerificationCode // ignore: cast_nullable_to_non_nullable
as bool,verificationTestCode: freezed == verificationTestCode ? _self.verificationTestCode : verificationTestCode // ignore: cast_nullable_to_non_nullable
as String?,verificationError: freezed == verificationError ? _self.verificationError : verificationError // ignore: cast_nullable_to_non_nullable
as String?,selectedInterests: null == selectedInterests ? _self.selectedInterests : selectedInterests // ignore: cast_nullable_to_non_nullable
as Set<String>,selectedExperience: freezed == selectedExperience ? _self.selectedExperience : selectedExperience // ignore: cast_nullable_to_non_nullable
as String?,proCode: null == proCode ? _self.proCode : proCode // ignore: cast_nullable_to_non_nullable
as String,nameError: freezed == nameError ? _self.nameError : nameError // ignore: cast_nullable_to_non_nullable
as String?,phoneNumberError: freezed == phoneNumberError ? _self.phoneNumberError : phoneNumberError // ignore: cast_nullable_to_non_nullable
as String?,verificationCodeError: freezed == verificationCodeError ? _self.verificationCodeError : verificationCodeError // ignore: cast_nullable_to_non_nullable
as String?,interestsError: freezed == interestsError ? _self.interestsError : interestsError // ignore: cast_nullable_to_non_nullable
as String?,experienceError: freezed == experienceError ? _self.experienceError : experienceError // ignore: cast_nullable_to_non_nullable
as String?,proCodeError: freezed == proCodeError ? _self.proCodeError : proCodeError // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MemberSignupState].
extension MemberSignupStatePatterns on MemberSignupState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MemberSignupState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MemberSignupState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MemberSignupState value)  $default,){
final _that = this;
switch (_that) {
case _MemberSignupState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MemberSignupState value)?  $default,){
final _that = this;
switch (_that) {
case _MemberSignupState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String phoneNumber,  String verificationCode,  Duration verificationRemaining,  bool isSendingVerificationCode,  bool isVerifyingVerificationCode,  String? verificationTestCode,  String? verificationError,  Set<String> selectedInterests,  String? selectedExperience,  String proCode,  String? nameError,  String? phoneNumberError,  String? verificationCodeError,  String? interestsError,  String? experienceError,  String? proCodeError)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MemberSignupState() when $default != null:
return $default(_that.name,_that.phoneNumber,_that.verificationCode,_that.verificationRemaining,_that.isSendingVerificationCode,_that.isVerifyingVerificationCode,_that.verificationTestCode,_that.verificationError,_that.selectedInterests,_that.selectedExperience,_that.proCode,_that.nameError,_that.phoneNumberError,_that.verificationCodeError,_that.interestsError,_that.experienceError,_that.proCodeError);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String phoneNumber,  String verificationCode,  Duration verificationRemaining,  bool isSendingVerificationCode,  bool isVerifyingVerificationCode,  String? verificationTestCode,  String? verificationError,  Set<String> selectedInterests,  String? selectedExperience,  String proCode,  String? nameError,  String? phoneNumberError,  String? verificationCodeError,  String? interestsError,  String? experienceError,  String? proCodeError)  $default,) {final _that = this;
switch (_that) {
case _MemberSignupState():
return $default(_that.name,_that.phoneNumber,_that.verificationCode,_that.verificationRemaining,_that.isSendingVerificationCode,_that.isVerifyingVerificationCode,_that.verificationTestCode,_that.verificationError,_that.selectedInterests,_that.selectedExperience,_that.proCode,_that.nameError,_that.phoneNumberError,_that.verificationCodeError,_that.interestsError,_that.experienceError,_that.proCodeError);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String phoneNumber,  String verificationCode,  Duration verificationRemaining,  bool isSendingVerificationCode,  bool isVerifyingVerificationCode,  String? verificationTestCode,  String? verificationError,  Set<String> selectedInterests,  String? selectedExperience,  String proCode,  String? nameError,  String? phoneNumberError,  String? verificationCodeError,  String? interestsError,  String? experienceError,  String? proCodeError)?  $default,) {final _that = this;
switch (_that) {
case _MemberSignupState() when $default != null:
return $default(_that.name,_that.phoneNumber,_that.verificationCode,_that.verificationRemaining,_that.isSendingVerificationCode,_that.isVerifyingVerificationCode,_that.verificationTestCode,_that.verificationError,_that.selectedInterests,_that.selectedExperience,_that.proCode,_that.nameError,_that.phoneNumberError,_that.verificationCodeError,_that.interestsError,_that.experienceError,_that.proCodeError);case _:
  return null;

}
}

}

/// @nodoc


class _MemberSignupState implements MemberSignupState {
  const _MemberSignupState({this.name = '', this.phoneNumber = '', this.verificationCode = '', this.verificationRemaining = Duration.zero, this.isSendingVerificationCode = false, this.isVerifyingVerificationCode = false, this.verificationTestCode, this.verificationError,  Set<String> selectedInterests = const <String>{}, this.selectedExperience, this.proCode = '', this.nameError, this.phoneNumberError, this.verificationCodeError, this.interestsError, this.experienceError, this.proCodeError}): _selectedInterests = selectedInterests;
  

@override@JsonKey() final  String name;
@override@JsonKey() final  String phoneNumber;
@override@JsonKey() final  String verificationCode;
@override@JsonKey() final  Duration verificationRemaining;
@override@JsonKey() final  bool isSendingVerificationCode;
@override@JsonKey() final  bool isVerifyingVerificationCode;
@override final  String? verificationTestCode;
@override final  String? verificationError;
 final  Set<String> _selectedInterests;
@override@JsonKey() Set<String> get selectedInterests {
  if (_selectedInterests is EqualUnmodifiableSetView) return _selectedInterests;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_selectedInterests);
}

@override final  String? selectedExperience;
@override@JsonKey() final  String proCode;
@override final  String? nameError;
@override final  String? phoneNumberError;
@override final  String? verificationCodeError;
@override final  String? interestsError;
@override final  String? experienceError;
@override final  String? proCodeError;

/// Create a copy of MemberSignupState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MemberSignupStateCopyWith<_MemberSignupState> get copyWith => __$MemberSignupStateCopyWithImpl<_MemberSignupState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MemberSignupState&&(identical(other.name, name) || other.name == name)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.verificationCode, verificationCode) || other.verificationCode == verificationCode)&&(identical(other.verificationRemaining, verificationRemaining) || other.verificationRemaining == verificationRemaining)&&(identical(other.isSendingVerificationCode, isSendingVerificationCode) || other.isSendingVerificationCode == isSendingVerificationCode)&&(identical(other.isVerifyingVerificationCode, isVerifyingVerificationCode) || other.isVerifyingVerificationCode == isVerifyingVerificationCode)&&(identical(other.verificationTestCode, verificationTestCode) || other.verificationTestCode == verificationTestCode)&&(identical(other.verificationError, verificationError) || other.verificationError == verificationError)&&const DeepCollectionEquality().equals(other.selectedInterests, _selectedInterests)&&(identical(other.selectedExperience, selectedExperience) || other.selectedExperience == selectedExperience)&&(identical(other.proCode, proCode) || other.proCode == proCode)&&(identical(other.nameError, nameError) || other.nameError == nameError)&&(identical(other.phoneNumberError, phoneNumberError) || other.phoneNumberError == phoneNumberError)&&(identical(other.verificationCodeError, verificationCodeError) || other.verificationCodeError == verificationCodeError)&&(identical(other.interestsError, interestsError) || other.interestsError == interestsError)&&(identical(other.experienceError, experienceError) || other.experienceError == experienceError)&&(identical(other.proCodeError, proCodeError) || other.proCodeError == proCodeError));
}


@override
int get hashCode {
    return Object.hash(runtimeType,name,phoneNumber,verificationCode,verificationRemaining,isSendingVerificationCode,isVerifyingVerificationCode,verificationTestCode,verificationError,const DeepCollectionEquality().hash(_selectedInterests),selectedExperience,proCode,nameError,phoneNumberError,verificationCodeError,interestsError,experienceError,proCodeError);
}

@override
String toString() {
    return 'MemberSignupState(name: $name, phoneNumber: $phoneNumber, verificationCode: $verificationCode, verificationRemaining: $verificationRemaining, isSendingVerificationCode: $isSendingVerificationCode, isVerifyingVerificationCode: $isVerifyingVerificationCode, verificationTestCode: $verificationTestCode, verificationError: $verificationError, selectedInterests: $selectedInterests, selectedExperience: $selectedExperience, proCode: $proCode, nameError: $nameError, phoneNumberError: $phoneNumberError, verificationCodeError: $verificationCodeError, interestsError: $interestsError, experienceError: $experienceError, proCodeError: $proCodeError)';
}


}

/// @nodoc
abstract mixin class _$MemberSignupStateCopyWith<$Res> implements $MemberSignupStateCopyWith<$Res> {
  factory _$MemberSignupStateCopyWith(_MemberSignupState value, $Res Function(_MemberSignupState) _then) = __$MemberSignupStateCopyWithImpl;
@override @useResult
$Res call({
 String name, String phoneNumber, String verificationCode, Duration verificationRemaining, bool isSendingVerificationCode, bool isVerifyingVerificationCode, String? verificationTestCode, String? verificationError, Set<String> selectedInterests, String? selectedExperience, String proCode, String? nameError, String? phoneNumberError, String? verificationCodeError, String? interestsError, String? experienceError, String? proCodeError
});




}
/// @nodoc
class __$MemberSignupStateCopyWithImpl<$Res>
    implements _$MemberSignupStateCopyWith<$Res> {
  __$MemberSignupStateCopyWithImpl(this._self, this._then);

  final _MemberSignupState _self;
  final $Res Function(_MemberSignupState) _then;

/// Create a copy of MemberSignupState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? phoneNumber = null,Object? verificationCode = null,Object? verificationRemaining = null,Object? isSendingVerificationCode = null,Object? isVerifyingVerificationCode = null,Object? verificationTestCode = freezed,Object? verificationError = freezed,Object? selectedInterests = null,Object? selectedExperience = freezed,Object? proCode = null,Object? nameError = freezed,Object? phoneNumberError = freezed,Object? verificationCodeError = freezed,Object? interestsError = freezed,Object? experienceError = freezed,Object? proCodeError = freezed,}) {
  return _then(_MemberSignupState(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phoneNumber: null == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String,verificationCode: null == verificationCode ? _self.verificationCode : verificationCode // ignore: cast_nullable_to_non_nullable
as String,verificationRemaining: null == verificationRemaining ? _self.verificationRemaining : verificationRemaining // ignore: cast_nullable_to_non_nullable
as Duration,isSendingVerificationCode: null == isSendingVerificationCode ? _self.isSendingVerificationCode : isSendingVerificationCode // ignore: cast_nullable_to_non_nullable
as bool,isVerifyingVerificationCode: null == isVerifyingVerificationCode ? _self.isVerifyingVerificationCode : isVerifyingVerificationCode // ignore: cast_nullable_to_non_nullable
as bool,verificationTestCode: freezed == verificationTestCode ? _self.verificationTestCode : verificationTestCode // ignore: cast_nullable_to_non_nullable
as String?,verificationError: freezed == verificationError ? _self.verificationError : verificationError // ignore: cast_nullable_to_non_nullable
as String?,selectedInterests: null == selectedInterests ? _self._selectedInterests : selectedInterests // ignore: cast_nullable_to_non_nullable
as Set<String>,selectedExperience: freezed == selectedExperience ? _self.selectedExperience : selectedExperience // ignore: cast_nullable_to_non_nullable
as String?,proCode: null == proCode ? _self.proCode : proCode // ignore: cast_nullable_to_non_nullable
as String,nameError: freezed == nameError ? _self.nameError : nameError // ignore: cast_nullable_to_non_nullable
as String?,phoneNumberError: freezed == phoneNumberError ? _self.phoneNumberError : phoneNumberError // ignore: cast_nullable_to_non_nullable
as String?,verificationCodeError: freezed == verificationCodeError ? _self.verificationCodeError : verificationCodeError // ignore: cast_nullable_to_non_nullable
as String?,interestsError: freezed == interestsError ? _self.interestsError : interestsError // ignore: cast_nullable_to_non_nullable
as String?,experienceError: freezed == experienceError ? _self.experienceError : experienceError // ignore: cast_nullable_to_non_nullable
as String?,proCodeError: freezed == proCodeError ? _self.proCodeError : proCodeError // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
