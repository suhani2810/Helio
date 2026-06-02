class AlarmModel {
  final String id;
  final DateTime time;
  final String label;
  final List<int> repeatDays; // 1 = Monday, 7 = Sunday
  bool isEnabled;
  final String missionType; // 'None', 'Math', 'Typing', 'Shake'
  final int sunriseDuration; // in minutes

  AlarmModel({
    required this.id,
    required this.time,
    this.label = 'Alarm',
    this.repeatDays = const [],
    this.isEnabled = true,
    this.sunriseDuration = 30,
    this.missionType = 'None',
  });

  String get timeFormatted {
    final hour = time.hour > 12 ? time.hour - 12 : (time.hour == 0 ? 12 : time.hour);
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  String get daysFormatted {
    if (repeatDays.isEmpty) return 'Once';
    if (repeatDays.length == 7) return 'Every day';
    if (repeatDays.length == 5 && !repeatDays.contains(6) && !repeatDays.contains(7)) return 'Weekdays';
    
    const dayMap = {1: 'Mon', 2: 'Tue', 3: 'Wed', 4: 'Thu', 5: 'Fri', 6: 'Sat', 7: 'Sun'};
    return repeatDays.map((d) => dayMap[d]).join(', ');
  }
}
