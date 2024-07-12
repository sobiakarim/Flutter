import 'package:hive/hive.dart';
import 'package:flutter/material.dart';

part 'task.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String description;

  @HiveField(2)
  bool isCompleted;

  @HiveField(3)
  DateTime dueDate;

  @HiveField(4)
  int? alarmTimeMinutes;  // Store alarm time as minutes past midnight

  Task({
    required this.title,
    this.description = '',
    this.isCompleted = false,
    required this.dueDate,
    TimeOfDay? alarmTime,  // Add this parameter
  }) {
    if (alarmTime != null) {
      alarmTimeMinutes = alarmTime.hour * 60 + alarmTime.minute;
    }
  }

  TimeOfDay? get alarmTime {
    if (alarmTimeMinutes == null) return null;
    final int hours = alarmTimeMinutes! ~/ 60;
    final int minutes = alarmTimeMinutes! % 60;
    return TimeOfDay(hour: hours, minute: minutes);
  }

  set alarmTime(TimeOfDay? time) {
    if (time == null) {
      alarmTimeMinutes = null;
    } else {
      alarmTimeMinutes = time.hour * 60 + time.minute;
    }
  }
}
