// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'environment_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$EnvironmentEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() startGet,
    required TResult Function() stopGet,
    required TResult Function() receiveData,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? startGet,
    TResult? Function()? stopGet,
    TResult? Function()? receiveData,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? startGet,
    TResult Function()? stopGet,
    TResult Function()? receiveData,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_startGetEvent value) startGet,
    required TResult Function(_stopGetEvent value) stopGet,
    required TResult Function(_receiveDataEvent value) receiveData,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_startGetEvent value)? startGet,
    TResult? Function(_stopGetEvent value)? stopGet,
    TResult? Function(_receiveDataEvent value)? receiveData,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_startGetEvent value)? startGet,
    TResult Function(_stopGetEvent value)? stopGet,
    TResult Function(_receiveDataEvent value)? receiveData,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EnvironmentEventCopyWith<$Res> {
  factory $EnvironmentEventCopyWith(
          EnvironmentEvent value, $Res Function(EnvironmentEvent) then) =
      _$EnvironmentEventCopyWithImpl<$Res, EnvironmentEvent>;
}

/// @nodoc
class _$EnvironmentEventCopyWithImpl<$Res, $Val extends EnvironmentEvent>
    implements $EnvironmentEventCopyWith<$Res> {
  _$EnvironmentEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$startGetEventImplCopyWith<$Res> {
  factory _$$startGetEventImplCopyWith(
          _$startGetEventImpl value, $Res Function(_$startGetEventImpl) then) =
      __$$startGetEventImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$startGetEventImplCopyWithImpl<$Res>
    extends _$EnvironmentEventCopyWithImpl<$Res, _$startGetEventImpl>
    implements _$$startGetEventImplCopyWith<$Res> {
  __$$startGetEventImplCopyWithImpl(
      _$startGetEventImpl _value, $Res Function(_$startGetEventImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$startGetEventImpl implements _startGetEvent {
  const _$startGetEventImpl();

  @override
  String toString() {
    return 'EnvironmentEvent.startGet()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$startGetEventImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() startGet,
    required TResult Function() stopGet,
    required TResult Function() receiveData,
  }) {
    return startGet();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? startGet,
    TResult? Function()? stopGet,
    TResult? Function()? receiveData,
  }) {
    return startGet?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? startGet,
    TResult Function()? stopGet,
    TResult Function()? receiveData,
    required TResult orElse(),
  }) {
    if (startGet != null) {
      return startGet();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_startGetEvent value) startGet,
    required TResult Function(_stopGetEvent value) stopGet,
    required TResult Function(_receiveDataEvent value) receiveData,
  }) {
    return startGet(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_startGetEvent value)? startGet,
    TResult? Function(_stopGetEvent value)? stopGet,
    TResult? Function(_receiveDataEvent value)? receiveData,
  }) {
    return startGet?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_startGetEvent value)? startGet,
    TResult Function(_stopGetEvent value)? stopGet,
    TResult Function(_receiveDataEvent value)? receiveData,
    required TResult orElse(),
  }) {
    if (startGet != null) {
      return startGet(this);
    }
    return orElse();
  }
}

abstract class _startGetEvent implements EnvironmentEvent {
  const factory _startGetEvent() = _$startGetEventImpl;
}

/// @nodoc
abstract class _$$stopGetEventImplCopyWith<$Res> {
  factory _$$stopGetEventImplCopyWith(
          _$stopGetEventImpl value, $Res Function(_$stopGetEventImpl) then) =
      __$$stopGetEventImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$stopGetEventImplCopyWithImpl<$Res>
    extends _$EnvironmentEventCopyWithImpl<$Res, _$stopGetEventImpl>
    implements _$$stopGetEventImplCopyWith<$Res> {
  __$$stopGetEventImplCopyWithImpl(
      _$stopGetEventImpl _value, $Res Function(_$stopGetEventImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$stopGetEventImpl implements _stopGetEvent {
  const _$stopGetEventImpl();

  @override
  String toString() {
    return 'EnvironmentEvent.stopGet()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$stopGetEventImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() startGet,
    required TResult Function() stopGet,
    required TResult Function() receiveData,
  }) {
    return stopGet();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? startGet,
    TResult? Function()? stopGet,
    TResult? Function()? receiveData,
  }) {
    return stopGet?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? startGet,
    TResult Function()? stopGet,
    TResult Function()? receiveData,
    required TResult orElse(),
  }) {
    if (stopGet != null) {
      return stopGet();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_startGetEvent value) startGet,
    required TResult Function(_stopGetEvent value) stopGet,
    required TResult Function(_receiveDataEvent value) receiveData,
  }) {
    return stopGet(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_startGetEvent value)? startGet,
    TResult? Function(_stopGetEvent value)? stopGet,
    TResult? Function(_receiveDataEvent value)? receiveData,
  }) {
    return stopGet?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_startGetEvent value)? startGet,
    TResult Function(_stopGetEvent value)? stopGet,
    TResult Function(_receiveDataEvent value)? receiveData,
    required TResult orElse(),
  }) {
    if (stopGet != null) {
      return stopGet(this);
    }
    return orElse();
  }
}

abstract class _stopGetEvent implements EnvironmentEvent {
  const factory _stopGetEvent() = _$stopGetEventImpl;
}

/// @nodoc
abstract class _$$receiveDataEventImplCopyWith<$Res> {
  factory _$$receiveDataEventImplCopyWith(_$receiveDataEventImpl value,
          $Res Function(_$receiveDataEventImpl) then) =
      __$$receiveDataEventImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$receiveDataEventImplCopyWithImpl<$Res>
    extends _$EnvironmentEventCopyWithImpl<$Res, _$receiveDataEventImpl>
    implements _$$receiveDataEventImplCopyWith<$Res> {
  __$$receiveDataEventImplCopyWithImpl(_$receiveDataEventImpl _value,
      $Res Function(_$receiveDataEventImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$receiveDataEventImpl implements _receiveDataEvent {
  const _$receiveDataEventImpl();

  @override
  String toString() {
    return 'EnvironmentEvent.receiveData()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$receiveDataEventImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() startGet,
    required TResult Function() stopGet,
    required TResult Function() receiveData,
  }) {
    return receiveData();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? startGet,
    TResult? Function()? stopGet,
    TResult? Function()? receiveData,
  }) {
    return receiveData?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? startGet,
    TResult Function()? stopGet,
    TResult Function()? receiveData,
    required TResult orElse(),
  }) {
    if (receiveData != null) {
      return receiveData();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_startGetEvent value) startGet,
    required TResult Function(_stopGetEvent value) stopGet,
    required TResult Function(_receiveDataEvent value) receiveData,
  }) {
    return receiveData(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_startGetEvent value)? startGet,
    TResult? Function(_stopGetEvent value)? stopGet,
    TResult? Function(_receiveDataEvent value)? receiveData,
  }) {
    return receiveData?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_startGetEvent value)? startGet,
    TResult Function(_stopGetEvent value)? stopGet,
    TResult Function(_receiveDataEvent value)? receiveData,
    required TResult orElse(),
  }) {
    if (receiveData != null) {
      return receiveData(this);
    }
    return orElse();
  }
}

abstract class _receiveDataEvent implements EnvironmentEvent {
  const factory _receiveDataEvent() = _$receiveDataEventImpl;
}

/// @nodoc
mixin _$EnvironmentState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(EnvironmentDataEntity? cacheData) stop,
    required TResult Function(EnvironmentDataEntity data, TypeData type) loaded,
    required TResult Function(String massage, EnvironmentDataEntity? cacheData)
        error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(EnvironmentDataEntity? cacheData)? stop,
    TResult? Function(EnvironmentDataEntity data, TypeData type)? loaded,
    TResult? Function(String massage, EnvironmentDataEntity? cacheData)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(EnvironmentDataEntity? cacheData)? stop,
    TResult Function(EnvironmentDataEntity data, TypeData type)? loaded,
    TResult Function(String massage, EnvironmentDataEntity? cacheData)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_loadingState value) loading,
    required TResult Function(_stopState value) stop,
    required TResult Function(_loadedState value) loaded,
    required TResult Function(_errorState value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_loadingState value)? loading,
    TResult? Function(_stopState value)? stop,
    TResult? Function(_loadedState value)? loaded,
    TResult? Function(_errorState value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_loadingState value)? loading,
    TResult Function(_stopState value)? stop,
    TResult Function(_loadedState value)? loaded,
    TResult Function(_errorState value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EnvironmentStateCopyWith<$Res> {
  factory $EnvironmentStateCopyWith(
          EnvironmentState value, $Res Function(EnvironmentState) then) =
      _$EnvironmentStateCopyWithImpl<$Res, EnvironmentState>;
}

/// @nodoc
class _$EnvironmentStateCopyWithImpl<$Res, $Val extends EnvironmentState>
    implements $EnvironmentStateCopyWith<$Res> {
  _$EnvironmentStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$loadingStateImplCopyWith<$Res> {
  factory _$$loadingStateImplCopyWith(
          _$loadingStateImpl value, $Res Function(_$loadingStateImpl) then) =
      __$$loadingStateImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$loadingStateImplCopyWithImpl<$Res>
    extends _$EnvironmentStateCopyWithImpl<$Res, _$loadingStateImpl>
    implements _$$loadingStateImplCopyWith<$Res> {
  __$$loadingStateImplCopyWithImpl(
      _$loadingStateImpl _value, $Res Function(_$loadingStateImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$loadingStateImpl implements _loadingState {
  const _$loadingStateImpl();

  @override
  String toString() {
    return 'EnvironmentState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$loadingStateImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(EnvironmentDataEntity? cacheData) stop,
    required TResult Function(EnvironmentDataEntity data, TypeData type) loaded,
    required TResult Function(String massage, EnvironmentDataEntity? cacheData)
        error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(EnvironmentDataEntity? cacheData)? stop,
    TResult? Function(EnvironmentDataEntity data, TypeData type)? loaded,
    TResult? Function(String massage, EnvironmentDataEntity? cacheData)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(EnvironmentDataEntity? cacheData)? stop,
    TResult Function(EnvironmentDataEntity data, TypeData type)? loaded,
    TResult Function(String massage, EnvironmentDataEntity? cacheData)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_loadingState value) loading,
    required TResult Function(_stopState value) stop,
    required TResult Function(_loadedState value) loaded,
    required TResult Function(_errorState value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_loadingState value)? loading,
    TResult? Function(_stopState value)? stop,
    TResult? Function(_loadedState value)? loaded,
    TResult? Function(_errorState value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_loadingState value)? loading,
    TResult Function(_stopState value)? stop,
    TResult Function(_loadedState value)? loaded,
    TResult Function(_errorState value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class _loadingState implements EnvironmentState {
  const factory _loadingState() = _$loadingStateImpl;
}

/// @nodoc
abstract class _$$stopStateImplCopyWith<$Res> {
  factory _$$stopStateImplCopyWith(
          _$stopStateImpl value, $Res Function(_$stopStateImpl) then) =
      __$$stopStateImplCopyWithImpl<$Res>;
  @useResult
  $Res call({EnvironmentDataEntity? cacheData});
}

/// @nodoc
class __$$stopStateImplCopyWithImpl<$Res>
    extends _$EnvironmentStateCopyWithImpl<$Res, _$stopStateImpl>
    implements _$$stopStateImplCopyWith<$Res> {
  __$$stopStateImplCopyWithImpl(
      _$stopStateImpl _value, $Res Function(_$stopStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cacheData = freezed,
  }) {
    return _then(_$stopStateImpl(
      cacheData: freezed == cacheData
          ? _value.cacheData
          : cacheData // ignore: cast_nullable_to_non_nullable
              as EnvironmentDataEntity?,
    ));
  }
}

/// @nodoc

class _$stopStateImpl implements _stopState {
  const _$stopStateImpl({this.cacheData});

  @override
  final EnvironmentDataEntity? cacheData;

  @override
  String toString() {
    return 'EnvironmentState.stop(cacheData: $cacheData)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$stopStateImpl &&
            (identical(other.cacheData, cacheData) ||
                other.cacheData == cacheData));
  }

  @override
  int get hashCode => Object.hash(runtimeType, cacheData);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$stopStateImplCopyWith<_$stopStateImpl> get copyWith =>
      __$$stopStateImplCopyWithImpl<_$stopStateImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(EnvironmentDataEntity? cacheData) stop,
    required TResult Function(EnvironmentDataEntity data, TypeData type) loaded,
    required TResult Function(String massage, EnvironmentDataEntity? cacheData)
        error,
  }) {
    return stop(cacheData);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(EnvironmentDataEntity? cacheData)? stop,
    TResult? Function(EnvironmentDataEntity data, TypeData type)? loaded,
    TResult? Function(String massage, EnvironmentDataEntity? cacheData)? error,
  }) {
    return stop?.call(cacheData);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(EnvironmentDataEntity? cacheData)? stop,
    TResult Function(EnvironmentDataEntity data, TypeData type)? loaded,
    TResult Function(String massage, EnvironmentDataEntity? cacheData)? error,
    required TResult orElse(),
  }) {
    if (stop != null) {
      return stop(cacheData);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_loadingState value) loading,
    required TResult Function(_stopState value) stop,
    required TResult Function(_loadedState value) loaded,
    required TResult Function(_errorState value) error,
  }) {
    return stop(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_loadingState value)? loading,
    TResult? Function(_stopState value)? stop,
    TResult? Function(_loadedState value)? loaded,
    TResult? Function(_errorState value)? error,
  }) {
    return stop?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_loadingState value)? loading,
    TResult Function(_stopState value)? stop,
    TResult Function(_loadedState value)? loaded,
    TResult Function(_errorState value)? error,
    required TResult orElse(),
  }) {
    if (stop != null) {
      return stop(this);
    }
    return orElse();
  }
}

abstract class _stopState implements EnvironmentState {
  const factory _stopState({final EnvironmentDataEntity? cacheData}) =
      _$stopStateImpl;

  EnvironmentDataEntity? get cacheData;
  @JsonKey(ignore: true)
  _$$stopStateImplCopyWith<_$stopStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$loadedStateImplCopyWith<$Res> {
  factory _$$loadedStateImplCopyWith(
          _$loadedStateImpl value, $Res Function(_$loadedStateImpl) then) =
      __$$loadedStateImplCopyWithImpl<$Res>;
  @useResult
  $Res call({EnvironmentDataEntity data, TypeData type});
}

/// @nodoc
class __$$loadedStateImplCopyWithImpl<$Res>
    extends _$EnvironmentStateCopyWithImpl<$Res, _$loadedStateImpl>
    implements _$$loadedStateImplCopyWith<$Res> {
  __$$loadedStateImplCopyWithImpl(
      _$loadedStateImpl _value, $Res Function(_$loadedStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
    Object? type = null,
  }) {
    return _then(_$loadedStateImpl(
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as EnvironmentDataEntity,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as TypeData,
    ));
  }
}

/// @nodoc

class _$loadedStateImpl implements _loadedState {
  const _$loadedStateImpl({required this.data, required this.type});

  @override
  final EnvironmentDataEntity data;
  @override
  final TypeData type;

  @override
  String toString() {
    return 'EnvironmentState.loaded(data: $data, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$loadedStateImpl &&
            (identical(other.data, data) || other.data == data) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode => Object.hash(runtimeType, data, type);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$loadedStateImplCopyWith<_$loadedStateImpl> get copyWith =>
      __$$loadedStateImplCopyWithImpl<_$loadedStateImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(EnvironmentDataEntity? cacheData) stop,
    required TResult Function(EnvironmentDataEntity data, TypeData type) loaded,
    required TResult Function(String massage, EnvironmentDataEntity? cacheData)
        error,
  }) {
    return loaded(data, type);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(EnvironmentDataEntity? cacheData)? stop,
    TResult? Function(EnvironmentDataEntity data, TypeData type)? loaded,
    TResult? Function(String massage, EnvironmentDataEntity? cacheData)? error,
  }) {
    return loaded?.call(data, type);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(EnvironmentDataEntity? cacheData)? stop,
    TResult Function(EnvironmentDataEntity data, TypeData type)? loaded,
    TResult Function(String massage, EnvironmentDataEntity? cacheData)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(data, type);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_loadingState value) loading,
    required TResult Function(_stopState value) stop,
    required TResult Function(_loadedState value) loaded,
    required TResult Function(_errorState value) error,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_loadingState value)? loading,
    TResult? Function(_stopState value)? stop,
    TResult? Function(_loadedState value)? loaded,
    TResult? Function(_errorState value)? error,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_loadingState value)? loading,
    TResult Function(_stopState value)? stop,
    TResult Function(_loadedState value)? loaded,
    TResult Function(_errorState value)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class _loadedState implements EnvironmentState {
  const factory _loadedState(
      {required final EnvironmentDataEntity data,
      required final TypeData type}) = _$loadedStateImpl;

  EnvironmentDataEntity get data;
  TypeData get type;
  @JsonKey(ignore: true)
  _$$loadedStateImplCopyWith<_$loadedStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$errorStateImplCopyWith<$Res> {
  factory _$$errorStateImplCopyWith(
          _$errorStateImpl value, $Res Function(_$errorStateImpl) then) =
      __$$errorStateImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String massage, EnvironmentDataEntity? cacheData});
}

/// @nodoc
class __$$errorStateImplCopyWithImpl<$Res>
    extends _$EnvironmentStateCopyWithImpl<$Res, _$errorStateImpl>
    implements _$$errorStateImplCopyWith<$Res> {
  __$$errorStateImplCopyWithImpl(
      _$errorStateImpl _value, $Res Function(_$errorStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? massage = null,
    Object? cacheData = freezed,
  }) {
    return _then(_$errorStateImpl(
      massage: null == massage
          ? _value.massage
          : massage // ignore: cast_nullable_to_non_nullable
              as String,
      cacheData: freezed == cacheData
          ? _value.cacheData
          : cacheData // ignore: cast_nullable_to_non_nullable
              as EnvironmentDataEntity?,
    ));
  }
}

/// @nodoc

class _$errorStateImpl implements _errorState {
  const _$errorStateImpl({required this.massage, this.cacheData});

  @override
  final String massage;
  @override
  final EnvironmentDataEntity? cacheData;

  @override
  String toString() {
    return 'EnvironmentState.error(massage: $massage, cacheData: $cacheData)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$errorStateImpl &&
            (identical(other.massage, massage) || other.massage == massage) &&
            (identical(other.cacheData, cacheData) ||
                other.cacheData == cacheData));
  }

  @override
  int get hashCode => Object.hash(runtimeType, massage, cacheData);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$errorStateImplCopyWith<_$errorStateImpl> get copyWith =>
      __$$errorStateImplCopyWithImpl<_$errorStateImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(EnvironmentDataEntity? cacheData) stop,
    required TResult Function(EnvironmentDataEntity data, TypeData type) loaded,
    required TResult Function(String massage, EnvironmentDataEntity? cacheData)
        error,
  }) {
    return error(massage, cacheData);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(EnvironmentDataEntity? cacheData)? stop,
    TResult? Function(EnvironmentDataEntity data, TypeData type)? loaded,
    TResult? Function(String massage, EnvironmentDataEntity? cacheData)? error,
  }) {
    return error?.call(massage, cacheData);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(EnvironmentDataEntity? cacheData)? stop,
    TResult Function(EnvironmentDataEntity data, TypeData type)? loaded,
    TResult Function(String massage, EnvironmentDataEntity? cacheData)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(massage, cacheData);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_loadingState value) loading,
    required TResult Function(_stopState value) stop,
    required TResult Function(_loadedState value) loaded,
    required TResult Function(_errorState value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_loadingState value)? loading,
    TResult? Function(_stopState value)? stop,
    TResult? Function(_loadedState value)? loaded,
    TResult? Function(_errorState value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_loadingState value)? loading,
    TResult Function(_stopState value)? stop,
    TResult Function(_loadedState value)? loaded,
    TResult Function(_errorState value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class _errorState implements EnvironmentState {
  const factory _errorState(
      {required final String massage,
      final EnvironmentDataEntity? cacheData}) = _$errorStateImpl;

  String get massage;
  EnvironmentDataEntity? get cacheData;
  @JsonKey(ignore: true)
  _$$errorStateImplCopyWith<_$errorStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
