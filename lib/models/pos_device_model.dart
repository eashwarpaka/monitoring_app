import 'package:cloud_firestore/cloud_firestore.dart';

class PosDeviceModel {
  final String posId;
  final String branchId;
  final String deviceName;
  final DateTime lastActive;

  PosDeviceModel({
    required this.posId,
    required this.branchId,
    required this.deviceName,
    required this.lastActive,
  });

  factory PosDeviceModel.fromJson(Map<String, dynamic> json, String id) {
    DateTime parseDate(dynamic val) {
      if (val is Timestamp) return val.toDate();
      if (val is String) return DateTime.parse(val);
      if (val is int) return DateTime.fromMillisecondsSinceEpoch(val);
      return DateTime.now();
    }

    return PosDeviceModel(
      posId: id,
      branchId: json['branch_id'] ?? 'unknown',
      deviceName: json['device_name'] ?? 'POS Terminal',
      lastActive: parseDate(json['last_active']),
    );
  }

  bool get isActive {
    final diff = DateTime.now().difference(lastActive);
    return diff.inMinutes < 15; // Considered active if pinged in last 15 mins
  }
}
