class Mapping {
  final String gesture;
  String action;
  String deviceId;

  Mapping({
    required this.gesture,
    required this.action,
    this.deviceId = '',
  });

  factory Mapping.fromJson(Map<String, dynamic> json) {
    return Mapping(
      gesture: json['gesture'],
      action: json['action'],
      deviceId: json['device_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'gesture': gesture,
      'action': action,
      'device_id': deviceId,
    };
  }
  
  // Helper display name for gesture
  String get gestureDisplayName {
    return gesture.replaceAll('_', ' ').toUpperCase();
  }
}
