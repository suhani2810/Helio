import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:helio/core/utils/math_generator.dart';
import 'package:helio/features/settings/profile_screen.dart';
import 'package:helio/features/home/home_screen.dart';
import 'package:helio/features/missions/typing_challenge_screen.dart';
import 'package:helio/core/services/mission_service.dart';
import 'package:helio/providers/repository_providers.dart';
import 'package:helio/core/theme/theme_provider.dart';
import 'package:helio/core/theme/theme_mode_enum.dart';
import 'package:helio/repositories/alarm_repository.dart';
import 'package:helio/repositories/streak_repository.dart';
import 'package:helio/repositories/mission_analytics_repository.dart';
import 'package:helio/repositories/mood_repository.dart';
import 'package:helio/repositories/wakeup_repository.dart';
import 'package:helio/core/services/alarm_scheduler_service.dart';
import 'package:helio/core/services/ringtone_service.dart';
import 'package:helio/models/alarm_entity.dart';
import 'package:helio/models/mood_entry_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

void main() {
  setUpAll(() {
    HttpOverrides.global = MockHttpOverrides();
  });
  group('MathGenerator Tests', () {
    test('Easy difficulty generates correct expressions', () {
      for (int i = 0; i < 100; i++) {
        final q = MathGenerator.generate(0);
        expect(q.expression.contains('+') || q.expression.contains('-'), isTrue);
        
        final parts = q.expression.split(RegExp(r'\s+'));
        final a = int.parse(parts[0]);
        final b = int.parse(parts[2]);
        
        expect(a, greaterThanOrEqualTo(1));
        expect(a, lessThanOrEqualTo(20));
        expect(b, greaterThanOrEqualTo(1));
        expect(b, lessThanOrEqualTo(20));
        
        final answer = int.parse(q.answer);
        if (q.expression.contains('+')) {
          expect(answer, equals(a + b));
        } else {
          expect(answer, equals(a - b));
          expect(answer, greaterThanOrEqualTo(0));
        }
      }
    });

    test('Medium difficulty generates correct expressions', () {
      for (int i = 0; i < 100; i++) {
        final q = MathGenerator.generate(1);
        expect(q.expression.contains('+') || q.expression.contains('-') || q.expression.contains('×'), isTrue);
        
        final parts = q.expression.split(RegExp(r'\s+'));
        final a = int.parse(parts[0]);
        final b = int.parse(parts[2]);
        
        expect(a, greaterThanOrEqualTo(1));
        expect(a, lessThanOrEqualTo(100));
        expect(b, greaterThanOrEqualTo(1));
        expect(b, lessThanOrEqualTo(100));
        
        final answer = int.parse(q.answer);
        if (q.expression.contains('+')) {
          expect(answer, equals(a + b));
        } else if (q.expression.contains('-')) {
          expect(answer, equals(a - b));
          expect(answer, greaterThan(0));
        } else {
          expect(answer, equals(a * b));
        }
      }
    });

    test('Hard difficulty generates correct expressions', () {
      for (int i = 0; i < 100; i++) {
        final q = MathGenerator.generate(2);
        expect(q.expression.contains('('), isTrue);
        expect(q.expression.contains(')'), isTrue);
        expect(q.expression.contains('×') || q.expression.contains('÷'), isTrue);
        
        final answer = int.parse(q.answer);
        expect(answer, greaterThanOrEqualTo(0));
      }
    });
  });

  group('Tile Puzzle Solvability Tests', () {
    int countInversions(List<int> list) {
      int inversions = 0;
      for (int i = 0; i < list.length; i++) {
        for (int j = i + 1; j < list.length; j++) {
          if (list[i] != 0 && list[j] != 0 && list[i] > list[j]) {
            inversions++;
          }
        }
      }
      return inversions;
    }

    bool isSolvable(List<int> list, int gridSize) {
      int inversions = countInversions(list);
      if (gridSize % 2 == 1) {
        return inversions % 2 == 0;
      } else {
        int blankIndex = list.indexOf(0);
        int blankRowFromTop = blankIndex ~/ gridSize;
        int blankRowFromBottom = gridSize - blankRowFromTop;
        return (inversions + blankRowFromBottom) % 2 == 1;
      }
    }

    test('3x3 solvable check works', () {
      final solvable = [1, 8, 2, 0, 4, 3, 7, 6, 5];
      expect(isSolvable(solvable, 3), isTrue);

      final unsolvable = [1, 8, 2, 0, 3, 4, 7, 6, 5];
      expect(isSolvable(unsolvable, 3), isFalse);
    });

    test('4x4 solvable check works', () {
      final solvable = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 0];
      expect(isSolvable(solvable, 4), isTrue);

      final unsolvable = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 15, 14, 0];
      expect(isSolvable(unsolvable, 4), isFalse);
    });
  });

  group('Profile Screen Layout Tests', () {
    testWidgets('ProfileScreen renders without RenderFlex overflow on small device (320x480)', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(320, 480));
      addTearDown(() async => await tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            alarmRepositoryProvider.overrideWithValue(MockAlarmRepository()),
            streakRepositoryProvider.overrideWithValue(MockStreakRepository()),
            missionAnalyticsRepositoryProvider.overrideWithValue(MockMissionAnalyticsRepository()),
            moodRepositoryProvider.overrideWithValue(MockMoodRepository()),
            wakeupRepositoryProvider.overrideWithValue(MockWakeupRepository()),
            alarmSchedulerServiceProvider.overrideWithValue(MockAlarmSchedulerService()),
            themeControllerProvider.overrideWith((ref) => MockThemeController()),
          ],
          child: const MaterialApp(
            home: ProfileScreen(),
          ),
        ),
      );

      await tester.pump(const Duration(seconds: 1));
      expect(find.byType(ProfileScreen), findsOneWidget);
    });

    testWidgets('ProfileScreen renders without RenderFlex overflow on medium device (375x667)', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(375, 667));
      addTearDown(() async => await tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            alarmRepositoryProvider.overrideWithValue(MockAlarmRepository()),
            streakRepositoryProvider.overrideWithValue(MockStreakRepository()),
            missionAnalyticsRepositoryProvider.overrideWithValue(MockMissionAnalyticsRepository()),
            moodRepositoryProvider.overrideWithValue(MockMoodRepository()),
            wakeupRepositoryProvider.overrideWithValue(MockWakeupRepository()),
            alarmSchedulerServiceProvider.overrideWithValue(MockAlarmSchedulerService()),
            themeControllerProvider.overrideWith((ref) => MockThemeController()),
          ],
          child: const MaterialApp(
            home: ProfileScreen(),
          ),
        ),
      );

      await tester.pump(const Duration(seconds: 1));
      expect(find.byType(ProfileScreen), findsOneWidget);
    });

    testWidgets('ProfileScreen renders without RenderFlex overflow on large device (414x896)', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(414, 896));
      addTearDown(() async => await tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            alarmRepositoryProvider.overrideWithValue(MockAlarmRepository()),
            streakRepositoryProvider.overrideWithValue(MockStreakRepository()),
            missionAnalyticsRepositoryProvider.overrideWithValue(MockMissionAnalyticsRepository()),
            moodRepositoryProvider.overrideWithValue(MockMoodRepository()),
            wakeupRepositoryProvider.overrideWithValue(MockWakeupRepository()),
            alarmSchedulerServiceProvider.overrideWithValue(MockAlarmSchedulerService()),
            themeControllerProvider.overrideWith((ref) => MockThemeController()),
          ],
          child: const MaterialApp(
            home: ProfileScreen(),
          ),
        ),
      );

      await tester.pump(const Duration(seconds: 1));
      expect(find.byType(ProfileScreen), findsOneWidget);
    });
  });

  group('Typing Challenge Layout Tests', () {
    testWidgets('TypingChallengeScreen renders without RenderFlex overflow when keyboard opens', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(360, 640));
      addTearDown(() async {
        await tester.binding.setSurfaceSize(null);
        tester.view.resetViewInsets();
      });

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            themeControllerProvider.overrideWith((ref) => MockThemeController()),
            missionServiceProvider.overrideWithValue(MockMissionService()),
          ],
          child: const MaterialApp(
            home: TypingChallengeScreen(isPreview: true),
          ),
        ),
      );

      await tester.pump();
      
      // Simulate keyboard open by setting bottom inset
      tester.view.viewInsets = const FakeViewPadding(bottom: 300.0);
      await tester.pump(const Duration(seconds: 1));

      expect(find.byType(TypingChallengeScreen), findsOneWidget);
    });
  });

  group('Home Screen Activity Goal Tests', () {
    testWidgets('HomeScreen renders Activity Goal widget with correct mock data', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            alarmRepositoryProvider.overrideWithValue(MockAlarmRepository()),
            streakRepositoryProvider.overrideWithValue(MockStreakRepository()),
            missionAnalyticsRepositoryProvider.overrideWithValue(MockMissionAnalyticsRepository()),
            moodRepositoryProvider.overrideWithValue(MockMoodRepository()),
            wakeupRepositoryProvider.overrideWithValue(MockWakeupRepository()),
            alarmSchedulerServiceProvider.overrideWithValue(MockAlarmSchedulerService()),
            themeControllerProvider.overrideWith((ref) => MockThemeController()),
          ],
          child: const MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Mock values: Total wakeups = 15, Missed alarms = 3. Target = 18.
      expect(find.text('Total Wakeups: 15'), findsOneWidget);
      expect(find.text('15 / 18'), findsOneWidget);
    });
  });

  group('RingtoneService Tests', () {
    test('getDisplayName formats paths into user-friendly names correctly', () {
      expect(RingtoneService.getDisplayName('assets/audio/Classic.mp3'), equals('Classic'));
      expect(RingtoneService.getDisplayName('assets/audio/Real clock.mp3'), equals('Real Clock'));
      expect(RingtoneService.getDisplayName('assets/audio/Fire Alarm.mp3'), equals('Fire Alarm'));
    });

    test('getAvailableRingtonePaths fallback contains the correct 7 files', () async {
      final paths = await RingtoneService.getAvailableRingtonePaths();
      expect(paths, isNotEmpty);
      expect(paths.length, equals(7));
      expect(paths[0], equals('assets/audio/Classic.mp3'));
      expect(paths[5], equals('assets/audio/Real clock.mp3'));
    });
  });
}

class MockAlarmRepository extends Fake implements AlarmRepository {
  @override
  Future<List<AlarmEntity>> getAllAlarms() async => [];
}

class MockStreakRepository extends Fake implements StreakRepository {
  @override
  Future<int> getCurrentStreak() async => 5;
  @override
  Future<int> getBestStreak() async => 10;
}

class MockMissionAnalyticsRepository extends Fake implements MissionAnalyticsRepository {
  @override
  Future<int> getTotalWakeups() async => 15;
  @override
  Future<int> getMissedAlarmsCount() async => 3;
  @override
  Future<void> syncMissedAlarms() async {}
}

class MockMoodRepository extends Fake implements MoodRepository {
  @override
  Future<List<MoodEntryEntity>> getMoodHistory() async => [];
}

class MockWakeupRepository extends Fake implements WakeupRepository {
  @override
  Future<double> getAverageWakeupDelay() async => 2.5;
}

class MockAlarmSchedulerService extends Fake implements AlarmSchedulerService {
  @override
  Future<void> scheduleAlarm(AlarmEntity alarm) async {}
  @override
  Future<void> cancelAlarm(int id) async {}
}

class MockThemeController extends StateNotifier<AppThemeMode> implements ThemeController {
  MockThemeController() : super(AppThemeMode.day);
  @override
  Future<void> setMode(AppThemeMode mode) async {
    state = mode;
  }
  @override
  bool isDarkModeForHour([DateTime? now]) => false;
}

class MockHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return MockHttpClient();
  }
}

class MockHttpClient implements HttpClient {
  @override
  Future<HttpClientRequest> getUrl(Uri url) async {
    return MockHttpClientRequest();
  }
  
  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class MockHttpClientRequest implements HttpClientRequest {
  @override
  final HttpHeaders headers = MockHttpHeaders();

  @override
  Future<HttpClientResponse> close() async {
    return MockHttpClientResponse();
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class MockHttpHeaders implements HttpHeaders {
  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class MockHttpClientResponse implements HttpClientResponse {
  @override
  int get statusCode => 200;

  @override
  int get contentLength => _transparentImage.length;

  @override
  HttpClientResponseCompressionState get compressionState =>
      HttpClientResponseCompressionState.notCompressed;

  @override
  StreamSubscription<List<int>> listen(
    void Function(List<int> event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return Stream<List<int>>.fromIterable([_transparentImage]).listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

final List<int> _transparentImage = base64Decode(
  'R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7',
);

class MockMissionService extends Fake implements MissionService {
  @override
  Future<void> completeMission({
    required String missionType,
    required DateTime scheduledTime,
    AlarmEntity? alarm,
    int? mathDifficulty,
    int? mathQuestionsSolved,
    int? puzzleDifficulty,
    int? puzzleMistakes,
    int? puzzleCompletionTime,
    int? walkingStepsGoal,
    int? walkingStepsTaken,
    int? walkingCompletionTime,
  }) async {}
}
