import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/design_system/colors.dart';
import '../../models/alarm.dart';
import '../../providers/alarm_provider.dart';
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
    return Scaffold(
      backgroundColor: HelioColors.backgroundDark,
      appBar: AppBar(
        title: Text(widget.initialAlarm == null ? 'Set Alarm' : 'Edit Alarm'),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
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
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Text(
                    _selectedTime.format(context),
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: 80,
                      color: HelioColors.sunriseOrange,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              onChanged: (value) => _title = value,
              decoration: InputDecoration(
                hintText: 'Alarm Title',
                filled: true,
                fillColor: HelioColors.cardDark,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
              controller: TextEditingController(text: _title),
            ),
            const SizedBox(height: 40),
            Text('Repeat', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(7, (index) {
                return _buildDayChip(index);
              }),
            ),
            const SizedBox(height: 40),
            _buildSettingTile(
              Icons.assignment,
              'Mission',
              _selectedMission,
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
              Icons.music_note,
              'Sound',
              'Morning Birds',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MorningAudioScreen(),
                ),
              ),
            ),
            _buildSettingTile(
              Icons.remove_red_eye_outlined,
              'Preview Missions',
              '',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MissionPreviewScreen(),
                ),
              ),
            ),
            const SizedBox(height: 60),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: _saveAlarm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: HelioColors.sunriseOrange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  'Save Alarm',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayChip(int index) {
    final isSelected = _days[index];
    return GestureDetector(
      onTap: () {
        setState(() {
          _days[index] = !isSelected;
        });
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? HelioColors.sunriseOrange : HelioColors.cardDark,
          border: Border.all(
            color: isSelected
                ? HelioColors.sunriseOrange
                : Colors.white.withOpacity(0.1),
          ),
        ),
        child: Center(
          child: Text(
            _dayNames[index],
            style: TextStyle(
              color: isSelected ? Colors.white : HelioColors.textSecondary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingTile(
    IconData icon,
    String title,
    String value, {
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: HelioColors.textSecondary, size: 24),
            const SizedBox(width: 16),
            Text(title, style: const TextStyle(fontSize: 16)),
            const Spacer(),
            Text(
              value,
              style: const TextStyle(
                color: HelioColors.sunriseOrange,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Icon(Icons.chevron_right, color: HelioColors.textSecondary),
          ],
        ),
      ),
    );
  }
}
