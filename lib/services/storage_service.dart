import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckInRecord {
  CheckInRecord({
    required this.id,
    required this.qrCode,
    required this.latitude,
    required this.longitude,
    required this.timestamp,
    required this.previousTopic,
    required this.expectedTopic,
    required this.mood,
  });

  final String id;
  final String qrCode;
  final double latitude;
  final double longitude;
  final String timestamp;
  final String previousTopic;
  final String expectedTopic;
  final int mood;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'qrCode': qrCode,
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': timestamp,
      'previousTopic': previousTopic,
      'expectedTopic': expectedTopic,
      'mood': mood,
    };
  }

  factory CheckInRecord.fromJson(Map<String, dynamic> json) {
    return CheckInRecord(
      id: json['id'] as String,
      qrCode: json['qrCode'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      timestamp: json['timestamp'] as String,
      previousTopic: json['previousTopic'] as String,
      expectedTopic: json['expectedTopic'] as String,
      mood: json['mood'] as int,
    );
  }
}

class CheckOutRecord {
  CheckOutRecord({
    required this.id,
    required this.qrCode,
    required this.latitude,
    required this.longitude,
    required this.timestamp,
    required this.learnedToday,
    required this.feedback,
  });

  final String id;
  final String qrCode;
  final double latitude;
  final double longitude;
  final String timestamp;
  final String learnedToday;
  final String feedback;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'qrCode': qrCode,
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': timestamp,
      'learnedToday': learnedToday,
      'feedback': feedback,
    };
  }

  factory CheckOutRecord.fromJson(Map<String, dynamic> json) {
    return CheckOutRecord(
      id: json['id'] as String,
      qrCode: json['qrCode'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      timestamp: json['timestamp'] as String,
      learnedToday: json['learnedToday'] as String,
      feedback: json['feedback'] as String,
    );
  }
}

class StorageService {
  static const String _checkInKey = 'check_in_records';
  static const String _checkOutKey = 'check_out_records';

  StorageService();

  Future<void> saveCheckIn(CheckInRecord record) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final List<CheckInRecord> existing = await getCheckIns();
      existing.add(record);

      final List<String> encoded = existing
          .map((CheckInRecord item) => jsonEncode(item.toJson()))
          .toList();

      await prefs.setStringList(_checkInKey, encoded);
      print('Check-in saved locally');
    } catch (e) {
      print('Error saving check-in: $e');
      rethrow;
    }
  }

  Future<void> saveCheckOut(CheckOutRecord record) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final List<CheckOutRecord> existing = await getCheckOuts();
      existing.add(record);

      final List<String> encoded = existing
          .map((CheckOutRecord item) => jsonEncode(item.toJson()))
          .toList();

      await prefs.setStringList(_checkOutKey, encoded);
      print('Check-out saved locally');
    } catch (e) {
      print('Error saving check-out: $e');
      rethrow;
    }
  }

  Future<List<CheckInRecord>> getCheckIns() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final List<String> raw = prefs.getStringList(_checkInKey) ?? <String>[];

      return raw.map((String item) {
        final Object? decoded = jsonDecode(item);
        if (decoded is Map<String, dynamic>) {
          return CheckInRecord.fromJson(decoded);
        }
        return CheckInRecord.fromJson(Map<String, dynamic>.from(decoded as Map));
      }).toList();
    } catch (e) {
      print('Error loading check-ins: $e');
      return <CheckInRecord>[];
    }
  }

  Future<List<CheckOutRecord>> getCheckOuts() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final List<String> raw = prefs.getStringList(_checkOutKey) ?? <String>[];

      return raw.map((String item) {
        final Object? decoded = jsonDecode(item);
        if (decoded is Map<String, dynamic>) {
          return CheckOutRecord.fromJson(decoded);
        }
        return CheckOutRecord.fromJson(Map<String, dynamic>.from(decoded as Map));
      }).toList();
    } catch (e) {
      print('Error loading check-outs: $e');
      return <CheckOutRecord>[];
    }
  }

  Future<void> clearAllData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_checkInKey);
    await prefs.remove(_checkOutKey);
  }
}
