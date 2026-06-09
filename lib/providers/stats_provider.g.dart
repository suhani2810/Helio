// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stats_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$bestStreakHash() => r'30d29a738f3bc4dc3eabd66e30894921b15882cf';

/// See also [bestStreak].
@ProviderFor(bestStreak)
final bestStreakProvider = AutoDisposeFutureProvider<int>.internal(
  bestStreak,
  name: r'bestStreakProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$bestStreakHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef BestStreakRef = AutoDisposeFutureProviderRef<int>;
String _$missionStatsHash() => r'd414af4704a2d8b9a0c06536d0f7145e1ec50d67';

/// See also [missionStats].
@ProviderFor(missionStats)
final missionStatsProvider =
    AutoDisposeFutureProvider<Map<String, int>>.internal(
  missionStats,
  name: r'missionStatsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$missionStatsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef MissionStatsRef = AutoDisposeFutureProviderRef<Map<String, int>>;
String _$totalWakeupsHash() => r'e2850dd8fdb9b63279cf8ec966f2f140aa4ac30f';

/// See also [totalWakeups].
@ProviderFor(totalWakeups)
final totalWakeupsProvider = AutoDisposeFutureProvider<int>.internal(
  totalWakeups,
  name: r'totalWakeupsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$totalWakeupsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef TotalWakeupsRef = AutoDisposeFutureProviderRef<int>;
String _$wakeupConsistencyHash() => r'cab512a93647adf30d51cd7ad0efebacba7d6a6b';

/// See also [wakeupConsistency].
@ProviderFor(wakeupConsistency)
final wakeupConsistencyProvider = AutoDisposeFutureProvider<double>.internal(
  wakeupConsistency,
  name: r'wakeupConsistencyProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$wakeupConsistencyHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef WakeupConsistencyRef = AutoDisposeFutureProviderRef<double>;
String _$mostUsedMissionHash() => r'87e509ccc488b651047939c53a3d22afbfae11b2';

/// See also [mostUsedMission].
@ProviderFor(mostUsedMission)
final mostUsedMissionProvider = AutoDisposeFutureProvider<String>.internal(
  mostUsedMission,
  name: r'mostUsedMissionProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$mostUsedMissionHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef MostUsedMissionRef = AutoDisposeFutureProviderRef<String>;
String _$wakeupHistoryHash() => r'f6da8ca7f1cc487c3c523aba71a6128f5b8eda2e';

/// See also [wakeupHistory].
@ProviderFor(wakeupHistory)
final wakeupHistoryProvider =
    AutoDisposeFutureProvider<List<WakeupEntity>>.internal(
  wakeupHistory,
  name: r'wakeupHistoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$wakeupHistoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef WakeupHistoryRef = AutoDisposeFutureProviderRef<List<WakeupEntity>>;
String _$moodNotifierHash() => r'500f7a666fb0bd6997ed232eaaae9f36caf11e89';

/// See also [MoodNotifier].
@ProviderFor(MoodNotifier)
final moodNotifierProvider =
    AutoDisposeAsyncNotifierProvider<MoodNotifier, MoodEntryEntity?>.internal(
  MoodNotifier.new,
  name: r'moodNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$moodNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$MoodNotifier = AutoDisposeAsyncNotifier<MoodEntryEntity?>;
String _$streakNotifierHash() => r'3db5164d3efded678bb624bc672f35032ae75d1c';

/// See also [StreakNotifier].
@ProviderFor(StreakNotifier)
final streakNotifierProvider =
    AutoDisposeAsyncNotifierProvider<StreakNotifier, int>.internal(
  StreakNotifier.new,
  name: r'streakNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$streakNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$StreakNotifier = AutoDisposeAsyncNotifier<int>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
