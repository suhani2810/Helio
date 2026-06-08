import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/design_system/colors.dart';
import '../../core/theme/theme_provider.dart';
import '../../core/theme/theme_mode_enum.dart';
import '../../models/alarm.dart';
import '../../providers/alarm_provider.dart';
import '../../widgets/theme/sky_background.dart';
import '../../widgets/premium_card.dart';
import '../missions/mission_selection_screen.dart';
import '../missions/mission_preview_screen.dart';
import '../audio/morning_audio_screen.dart';

class CreateAlarmScreen extends ConsumerStatefulWidget {
  final Alarm? initialAlarm;
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
  final List<String> _dayNames = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  void initState() {
    super.initState();
    final alarm = widget.initialAlarm;
    if (alarm != null) {
      _selectedTime = TimeOfDay(
        hour: alarm.time.hour,
        minute: alarm.time.minute,
      );
      _title = alarm.title;
      _selectedMission = alarm.missionType;
      _isEnabled = alarm.isEnabled;
      _days = List.generate(7, (index) => alarm.repeatDays.contains(index));
    } else {
      _selectedTime = const TimeOfDay(hour: 7, minute: 0);
      _title = 'Wake Up';
      _selectedMission = 'None';
      _isEnabled = true;
      _days = List.generate(7, (index) => false);
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

    final alarm = Alarm(
      time: alarmTime,
      title: _title,
      missionType: _selectedMission,
      isEnabled: _isEnabled,
      repeatDays: repeatDays,
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
                            hintStyle: TextStyle(color: textColor.withOpacity(0.3)),
                            border: InputBorder.none,
                            icon: Icon(Icons.label_outline_rounded, color: textColor.withOpacity(0.5)),
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
          color: isSelected ? primaryColor : (isNight ? Colors.white.withOpacity(0.05) : Colors.white),
          border: Border.all(
            color: isSelected
                ? primaryColor
                : textColor.withOpacity(0.1),
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: primaryColor.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Center(
          child: Text(
            _dayNames[index],
            style: TextStyle(
              color: isSelected ? Colors.white : textColor.withOpacity(0.5),
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
                Icon(icon, color: textColor.withOpacity(0.5), size: 24),
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
                Icon(Icons.chevron_right_rounded, color: textColor.withOpacity(0.2)),
              ],
            ),
          ),
        ),
        if (!isLast)
          Divider(
            height: 1,
            indent: 60,
            endIndent: 20,
            color: textColor.withOpacity(0.05),
          ),
      ],
    );
  }
}
