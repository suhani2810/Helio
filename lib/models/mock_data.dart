import '../models/alarm_model.dart';

class MockData {
  static List<AlarmModel> alarms = [
    AlarmModel(
      id: '1',
      time: DateTime(2026, 6, 2, 6, 30),
      label: 'Morning Sunrise',
      repeatDays: [1, 2, 3, 4, 5],
      isEnabled: true,
      sunriseDuration: 30,
    ),
    AlarmModel(
      id: '2',
      time: DateTime(2026, 6, 2, 8, 00),
      label: 'Weekend Rest',
      repeatDays: [6, 7],
      isEnabled: false,
      sunriseDuration: 45,
    ),
    AlarmModel(
      id: '3',
      time: DateTime(2026, 6, 2, 7, 15),
      label: 'Gym Session',
      repeatDays: [1, 3, 5],
      isEnabled: true,
      sunriseDuration: 20,
    ),
  ];
}
