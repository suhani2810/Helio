// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alarm_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$nextUpcomingAlarmHash() => r'bc43c1c5a2d6dae98a0ea6c60e6a5f049138c29c';

/// See also [nextUpcomingAlarm].
@ProviderFor(nextUpcomingAlarm)
final nextUpcomingAlarmProvider =
    AutoDisposeFutureProvider<AlarmEntity?>.internal(
  nextUpcomingAlarm,
  name: r'nextUpcomingAlarmProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$nextUpcomingAlarmHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef NextUpcomingAlarmRef = AutoDisposeFutureProviderRef<AlarmEntity?>;
String _$alarmNotifierHash() => r'0df5f34ebfdbdf65a5283cdab237c9d3ba184e4e';

/// See also [AlarmNotifier].
@ProviderFor(AlarmNotifier)
final alarmNotifierProvider =
    AutoDisposeAsyncNotifierProvider<AlarmNotifier, List<AlarmEntity>>.internal(
  AlarmNotifier.new,
  name: r'alarmNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$alarmNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AlarmNotifier = AutoDisposeAsyncNotifier<List<AlarmEntity>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
