import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:helio/core/design_system/colors.dart';
import 'package:helio/core/theme/theme_provider.dart';
import 'package:helio/core/theme/theme_mode_enum.dart';
import 'package:helio/models/alarm_entity.dart';
import 'package:helio/providers/alarm_provider.dart';
import 'package:helio/widgets/theme/sky_background.dart';
import 'package:helio/widgets/premium_card.dart';
import 'package:helio/features/missions/mission_selection_screen.dart';
import 'package:helio/features/missions/mission_preview_screen.dart';
import 'package:helio/features/audio/morning_audio_screen.dart';
import 'package:helio/features/alarms/follow_up_chain_screen.dart';

class CreateAlarmScreen extends ConsumerStatefulWidget {
  final AlarmEntity? initialAlarm;
  const CreateAlarmScreen({super.key, this.initialAlarm});

  @override
  ConsumerState<CreateAlarmScreen> createState() => _CreateAlarmScreenState();
}

class _CreateAlarmScreenState extends ConsumerState<CreateAlarmScreen> {
  late TimeOfDay _selectedTime;
  late String _title;
  late String _selectedMission;
  late bool _isEnabled;
  late List<bool> _days;
  late bool _followUpEnabled;
  late int _followUpMinutes;
  late String _followUpMission;
  
  // Task 7: Mission Settings
  late int _mathDifficulty;
  late int _stepGoal;
  late int _shakeLimit;
  late String _targetObject;

  final List<String> _dayNames = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  void initState() {
    super.initState();
    final alarm = widget.initialAlarm;
    if (alarm != null) {
      _selectedTime = TimeOfDay(
        hour: alarm.alarmTime.hour,
        minute: alarm.alarmTime.minute,
      );
      _title = alarm.label;
      _selectedMission = alarm.missionType;
      _isEnabled = alarm.enabled;
      _days = List.generate(7, (index) => alarm.repeatDays.contains(index));
      _followUpEnabled = alarm.followUpEnabled;
      _followUpMinutes = alarm.followUpMinutes;
      _followUpMission = alarm.followUpMission;
      _mathDifficulty = alarm.mathDifficulty;
      _stepGoal = alarm.stepGoal;
      _shakeLimit = alarm.shakeLimit;
      _targetObject = alarm.targetObject;
    } else {
      _selectedTime = const TimeOfDay(hour: 7, minute: 0);
      _title = 'Wake Up';
      _selectedMission = 'None';
      _isEnabled = true;
      _days = List.generate(7, (index) => false);
      _followUpEnabled = false;
      _followUpMinutes = 5;
      _followUpMission = 'None';
      _mathDifficulty = 1;
      _stepGoal = 30;
      _shakeLimit = 20;
      _targetObject = 'Mug';
    }
  }

  void _saveAlarm() {
    final now = DateTime.now();
    final alarmTime = DateTime(
      now.year,
      now.month,
      now.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    final repeatDays = <int>[];
    for (int i = 0; i < _days.length; i++) {
      if (_days[i]) repeatDays.add(i);
    }

    final alarm = AlarmEntity(
      alarmTime: alarmTime,
      label: _title,
      missionType: _selectedMission,
      enabled: _isEnabled,
      repeatDays: repeatDays,
      ringtone: widget.initialAlarm?.ringtone ?? 'Default',
      followUpEnabled: _followUpEnabled,
      followUpMinutes: _followUpMinutes,
      followUpMission: _followUpMission,
      createdAt: widget.initialAlarm?.createdAt ?? DateTime.now(),
      mathDifficulty: _mathDifficulty,
      stepGoal: _stepGoal,
      shakeLimit: _shakeLimit,
      targetObject: _targetObject,
    );

    if (widget.initialAlarm != null) {
      alarm.id = widget.initialAlarm!.id;
      ref.read(alarmNotifierProvider.notifier).updateAlarm(alarm);
    } else {
      ref.read(alarmNotifierProvider.notifier).addAlarm(alarm);
    }

    Navigator.pop(context);
  }


  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeControllerProvider);
    final isNight = _isNightMode(themeMode, DateTime.now().hour);
    final textColor = isNight ? Colors.white : HelioColors.dayText;
    final primaryColor = isNight ? HelioColors.nightPrimary : HelioColors.dayPrimary;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SkyBackground(
        child: SafeArea(
          child: Column(
            children: [
              if (isNight) const SizedBox(height: 240),
              // Custom App Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back_rounded, color: textColor),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text(
                      widget.initialAlarm == null ? 'Set Alarm' : 'Edit Alarm',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: _saveAlarm,
                      child: Text(
                        'Save',
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: GestureDetector(
                          onTap: () async {
                            final time = await showTimePicker(
                              context: context,
                              initialTime: _selectedTime,
                            );
                            if (time != null) {
                              setState(() => _selectedTime = time);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Text(
                              _selectedTime.format(context),
                              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                fontSize: 96,
                                fontWeight: FontWeight.w900,
                                color: textColor,
                                letterSpacing: -2,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      PremiumCard(
                        isGlass: isNight,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        child: TextField(
                          onChanged: (value) => _title = value,
                          style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
                          decoration: InputDecoration(
                            hintText: 'Alarm Title',
                            hintStyle: TextStyle(color: textColor.withValues(alpha: 0.3)),
                            border: InputBorder.none,
                            icon: Icon(Icons.label_outline_rounded, color: textColor.withValues(alpha: 0.5)),
                          ),
                          controller: TextEditingController(text: _title),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Text(
                        'Repeat',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(7, (index) {
                          return _buildDayChip(index, isNight, primaryColor, textColor);
                        }),
                      ),
                      const SizedBox(height: 32),
                      PremiumCard(
                        isGlass: isNight,
                        padding: EdgeInsets.zero,
                        child: Column(
                          children: [
                            _buildSettingTile(
                              Icons.assignment_rounded,
                              'Mission',
                              _selectedMission,
                              textColor,
                              primaryColor,
                              onTap: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const MissionSelectionScreen(),
                                  ),
                                );
                                if (result != null) {
                                  setState(() => _selectedMission = result as String);
                                }
                              },
                            ),
                            if (_selectedMission != 'None')
                              _buildMissionConfig(isNight, textColor, primaryColor),
                            _buildSettingTile(
                              Icons.music_note_rounded,
                              'Sound',
                              'Morning Birds',
                              textColor,
                              primaryColor,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const MorningAudioScreen(),
                                ),
                              ),
                            ),
                            _buildSettingTile(
                              Icons.link_rounded,
                              'Follow-up Mission',
                              _followUpEnabled ? 'Enabled' : 'Disabled',
                              textColor,
                              primaryColor,
                              onTap: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FollowUpAlarmChainScreen(
                                      isEnabled: _followUpEnabled,
                                      interval: _followUpMinutes,
                                      mission: _followUpMission,
                                    ),
                                  ),
                                );
                                if (result != null && result is Map<String, dynamic>) {
                                  setState(() {
                                    _followUpEnabled = result['isEnabled'];
                                    _followUpMinutes = result['interval'];
                                    _followUpMission = result['mission'];
                                  });
                                }
                              },
                            ),
                            _buildSettingTile(
                              Icons.remove_red_eye_rounded,
                              'Preview Missions',
                              '',
                              textColor,
                              primaryColor,
                              isLast: true,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const MissionPreviewScreen(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _isNightMode(AppThemeMode mode, int hour) {
    if (mode == AppThemeMode.night) return true;
    if (mode == AppThemeMode.day) return false;
    return hour < 5 || hour >= 19;
  }

  Widget _buildMissionConfig(bool isNight, Color textColor, Color primaryColor) {
    String configLabel = '';
    String configValue = '';
    VoidCallback? onTap;

    switch (_selectedMission) {
      case 'Math':
        configLabel = 'Difficulty';
        configValue = ['Easy', 'Medium', 'Hard'][_mathDifficulty];
        onTap = () => setState(() => _mathDifficulty = (_mathDifficulty + 1) % 3);
        break;
      case 'Walking':
        configLabel = 'Steps';
        configValue = '$_stepGoal';
        onTap = () => setState(() => _stepGoal = (_stepGoal + 10 > 100) ? 10 : _stepGoal + 10);
        break;
      case 'Shake':
        configLabel = 'Shakes';
        configValue = '$_shakeLimit';
        onTap = () => setState(() => _shakeLimit = (_shakeLimit + 10 > 100) ? 10 : _shakeLimit + 10);
        break;
      case 'Object Detection':
        configLabel = 'Target';
        configValue = _targetObject;
        onTap = () => setState(() {
          const objects = ['Mug', 'Bottle', 'Book', 'Key'];
          int idx = objects.indexOf(_targetObject);
          _targetObject = objects[(idx + 1) % objects.length];
        });
        break;
    }

    if (configLabel.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        _buildSettingTile(
          Icons.settings_suggest_rounded,
          configLabel,
          configValue,
          textColor,
          primaryColor,
          onTap: onTap,
        ),
      ],
    );
  }

  Widget _buildDayChip(int index, bool isNight, Color primaryColor, Color textColor) {
    final isSelected = _days[index];
    return GestureDetector(
      onTap: () {
        setState(() {
          _days[index] = !isSelected;
        });
      },
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? primaryColor : (isNight ? Colors.white.withValues(alpha: 0.05) : Colors.white),
          border: Border.all(
            color: isSelected
                ? primaryColor
                : textColor.withValues(alpha: 0.1),
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: primaryColor.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Center(
          child: Text(
            _dayNames[index],
            style: TextStyle(
              color: isSelected ? Colors.white : textColor.withValues(alpha: 0.5),
              fontWeight: FontWeight.w800,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingTile(
    IconData icon,
    String title,
    String value,
    Color textColor,
    Color primaryColor, {
    VoidCallback? onTap,
    bool isLast = false,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Icon(icon, color: textColor.withValues(alpha: 0.5), size: 24),
                const SizedBox(width: 16),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    color: textColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  value,
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.chevron_right_rounded, color: textColor.withValues(alpha: 0.2)),
              ],
            ),
          ),
        ),
        if (!isLast)
          Divider(
            height: 1,
            indent: 60,
            endIndent: 20,
            color: textColor.withValues(alpha: 0.05),
          ),
      ],
    );
  }
}
