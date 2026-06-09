import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:alarm/alarm.dart';
import '../../providers/repository_providers.dart';
import '../../providers/stats_provider.dart';
import '../../models/wakeup_entity.dart';

class MissionService {
  final Ref ref;
  MissionService(this.ref);

  Future<void> completeMission({
    required String missionType,
    required DateTime scheduledTime,
  }) async {
    // 1. Stop the alarm
    await Alarm.stopAll();

    // 2. Record Wakeup Analytics
    final now = DateTime.now();
    final delay = now.difference(scheduledTime).inMinutes.clamp(0, 1440);
    
    final wakeup = WakeupEntity(
      scheduledTime: scheduledTime,
      actualTime: now,
      delayMinutes: delay,
      missionUsed: missionType,
      dayOfWeek: now.weekday,
    );
    
    await ref.read(wakeupRepositoryProvider).recordWakeup(wakeup);

    // 3. Update Streak
    await ref.read(streakNotifierProvider.notifier).incrementStreak();

    // 4. Record Mission Success
    await ref.read(missionAnalyticsRepositoryProvider).recordCompletion(missionType, true);
    
    // 5. Handle Morning Audio (Logic would go here or in a dedicated service)
  }
}

final missionServiceProvider = Provider((ref) => MissionService(ref));
