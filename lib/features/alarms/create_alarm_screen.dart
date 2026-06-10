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
import 'package:helio/core/services/ringtone_service.dart';

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
  late int _puzzleDifficulty;
  late int _stepGoal;
  late int _walkingDifficulty;
  late int _shakeLimit;
  late String _targetObject;
  late String _selectedRingtone;

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
      _puzzleDifficulty = alarm.puzzleDifficulty;
      _stepGoal = alarm.stepGoal;
      _walkingDifficulty = alarm.walkingDifficulty;
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
      _puzzleDifficulty = 1;
      _stepGoal = 100;
      _walkingDifficulty = 1;
      _shakeLimit = 20;
      _targetObject = 'Mug';
    }
    final initialRingtone = alarm?.ringtone ?? 'assets/audio/Classic.mp3';
    _selectedRingtone = initialRingtone == 'Default' ? 'assets/audio/Classic.mp3' : initialRingtone;
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
      ringtone: _selectedRingtone,
      followUpEnabled: _followUpEnabled,
      followUpMinutes: _followUpMinutes,
      followUpMission: _followUpMission,
      createdAt: widget.initialAlarm?.createdAt ?? DateTime.now(),
      mathDifficulty: _mathDifficulty,
      puzzleDifficulty: _puzzleDifficulty,
      puzzleSize: _puzzleDifficulty == 0 ? 3 : (_puzzleDifficulty == 1 ? 4 : 5),
      stepGoal: _stepGoal,
      walkingDifficulty: _walkingDifficulty,
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
                              Icons.notifications_active_rounded,
                              'Ringtone',
                              RingtoneService.getDisplayName(_selectedRingtone),
                              textColor,
                              primaryColor,
                              onTap: () => _showRingtoneSelector(context, textColor, primaryColor, isNight),
                            ),
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

  void _showDifficultySelector(BuildContext context, bool isNight, Color textColor, Color primaryColor) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              decoration: BoxDecoration(
                color: isNight ? HelioColors.nightCard : Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Math Difficulty',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ...List.generate(3, (index) {
                    final label = ['Easy', 'Medium', 'Hard'][index];
                    final isSelected = _mathDifficulty == index;
                    return InkWell(
                      onTap: () {
                        setState(() {
                          _mathDifficulty = index;
                        });
                        setModalState(() {});
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Row(
                          children: [
                            Icon(
                              isSelected ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
                              color: isSelected ? primaryColor : textColor.withOpacity(0.5),
                              size: 24,
                            ),
                            const SizedBox(width: 16),
                            Text(
                              label,
                              style: TextStyle(
                                color: textColor,
                                fontSize: 16,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            );
          }
        );
      },
    );
  }

  void _showPuzzleDifficultySelector(BuildContext context, bool isNight, Color textColor, Color primaryColor) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              decoration: BoxDecoration(
                color: isNight ? HelioColors.nightCard : Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Puzzle Difficulty',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ...List.generate(3, (index) {
                    final label = ['Easy', 'Medium', 'Hard'][index];
                    final isSelected = _puzzleDifficulty == index;
                    return InkWell(
                      onTap: () {
                        setState(() {
                          _puzzleDifficulty = index;
                        });
                        setModalState(() {});
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Row(
                          children: [
                            Icon(
                              isSelected ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
                              color: isSelected ? primaryColor : textColor.withOpacity(0.5),
                              size: 24,
                            ),
                            const SizedBox(width: 16),
                            Text(
                              label,
                              style: TextStyle(
                                color: textColor,
                                fontSize: 16,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            );
          }
        );
      },
    );
  }

  void _showWalkingDifficultySelector(BuildContext context, bool isNight, Color textColor, Color primaryColor) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              decoration: BoxDecoration(
                color: isNight ? HelioColors.nightCard : Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Walking Difficulty',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ...List.generate(3, (index) {
                    final target = [50, 100, 200][index];
                    final label = ['Easy (50 steps)', 'Medium (100 steps)', 'Hard (200 steps)'][index];
                    final isSelected = _walkingDifficulty == index;
                    return InkWell(
                      onTap: () {
                        setState(() {
                          _walkingDifficulty = index;
                          _stepGoal = target;
                        });
                        setModalState(() {});
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Row(
                          children: [
                            Icon(
                              isSelected ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
                              color: isSelected ? primaryColor : textColor.withOpacity(0.5),
                              size: 24,
                            ),
                            const SizedBox(width: 16),
                            Text(
                              label,
                              style: TextStyle(
                                color: textColor,
                                fontSize: 16,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            );
          }
        );
      },
    );
  }

  void _showObjectSelector(BuildContext context, bool isNight, Color textColor, Color primaryColor) {
    const objects = [
      'Toothbrush',
      'Cup',
      'Book',
      'Laptop',
      'Keyboard',
      'Phone',
      'Chair',
      'Backpack',
      'Key',
    ];
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              decoration: BoxDecoration(
                color: isNight ? HelioColors.nightCard : Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select Target Object',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: objects.length,
                      itemBuilder: (context, index) {
                        final label = objects[index];
                        final isSelected = _targetObject == label;
                        return InkWell(
                          onTap: () {
                            setState(() {
                              _targetObject = label;
                            });
                            setModalState(() {});
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Row(
                              children: [
                                Icon(
                                  isSelected ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
                                  color: isSelected ? primaryColor : textColor.withOpacity(0.5),
                                  size: 24,
                                ),
                                const SizedBox(width: 16),
                                Text(
                                  label,
                                  style: TextStyle(
                                    color: textColor,
                                    fontSize: 16,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }
        );
      },
    );
  }

  Widget _buildMissionConfig(bool isNight, Color textColor, Color primaryColor) {
    String configLabel = '';
    String configValue = '';
    VoidCallback? onTap;

    switch (_selectedMission) {
      case 'Math':
        configLabel = 'Difficulty';
        configValue = ['Easy', 'Medium', 'Hard'][_mathDifficulty];
        onTap = () => _showDifficultySelector(context, isNight, textColor, primaryColor);
        break;
      case 'Tile Puzzle':
        configLabel = 'Difficulty';
        configValue = ['Easy', 'Medium', 'Hard'][_puzzleDifficulty];
        onTap = () => _showPuzzleDifficultySelector(context, isNight, textColor, primaryColor);
        break;
      case 'Walking':
        configLabel = 'Difficulty';
        configValue = ['Easy', 'Medium', 'Hard'][_walkingDifficulty];
        onTap = () => _showWalkingDifficultySelector(context, isNight, textColor, primaryColor);
        break;
      case 'Shake':
        configLabel = 'Shakes';
        configValue = '$_shakeLimit';
        onTap = () => setState(() => _shakeLimit = (_shakeLimit + 10 > 100) ? 10 : _shakeLimit + 10);
        break;
      case 'Object Detection':
        configLabel = 'Target';
        configValue = _targetObject;
        onTap = () => _showObjectSelector(context, isNight, textColor, primaryColor);
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

  void _showRingtoneSelector(BuildContext context, Color textColor, Color primaryColor, bool isNight) async {
    final paths = await RingtoneService.getAvailableRingtonePaths();
    
    if (!context.mounted) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: isNight ? const Color(0xFF071330) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 16),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: textColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Select Ringtone',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: paths.length,
                      itemBuilder: (context, index) {
                        final path = paths[index];
                        final displayName = RingtoneService.getDisplayName(path);
                        final isSelected = _selectedRingtone == path;
                        final isPlayingPreview = RingtoneService.currentlyPlayingPath == path;

                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                          leading: Icon(
                            isPlayingPreview ? Icons.volume_up_rounded : Icons.music_note_rounded,
                            color: isSelected ? primaryColor : textColor.withValues(alpha: 0.5),
                          ),
                          title: Text(
                            displayName,
                            style: TextStyle(
                              color: textColor,
                              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                            ),
                          ),
                          trailing: isSelected
                              ? Icon(Icons.check_circle_rounded, color: primaryColor)
                              : null,
                          onTap: () async {
                            if (isPlayingPreview) {
                              await RingtoneService.stop();
                            } else {
                              await RingtoneService.playPreview(path);
                            }
                            setModalState(() {});
                            setState(() {
                              _selectedRingtone = path;
                            });
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    child: ElevatedButton(
                      onPressed: () async {
                        await RingtoneService.stop();
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      child: const Text(
                        'DONE',
                        style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    ).then((_) async {
      await RingtoneService.stop();
    });
  }
}
