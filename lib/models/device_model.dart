enum DeviceType { light, plug, tv, fan, other }

class Device {
  final String id;
  final String name;
  final DeviceType type;
  bool isOn;
  double value; // e.g., brightness or volume
  final String roomId;

  Device({
    required this.id,
    required this.name,
    required this.type,
    this.isOn = false,
    this.value = 0.0,
    required this.roomId,
  });

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      id: json['id'],
      name: json['name'],
      type: _parseType(json['type']),
      isOn: json['is_on'] ?? false,
      value: (json['value'] ?? 0).toDouble(),
      roomId: json['room_id'] ?? 'unknown',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.toString().split('.').last,
      'is_on': isOn,
      'value': value,
      'room_id': roomId,
    };
  }

  static DeviceType _parseType(String? typeStr) {
    switch (typeStr?.toLowerCase()) {
      case 'light': return DeviceType.light;
      case 'plug': return DeviceType.plug;
      case 'tv': return DeviceType.tv;
      case 'fan': return DeviceType.fan;
      default: return DeviceType.other;
    }
  }
  
  // Helper to get icon asset path based on type
  String get iconPath {
    switch (type) {
      case DeviceType.light: return 'assets/icons/light.svg';
      case DeviceType.tv: return 'assets/icons/tv.svg';
      case DeviceType.plug: return 'assets/icons/plug.svg';
      case DeviceType.fan: return 'assets/icons/fan.svg';
      default: return 'assets/icons/device.svg';
    }
  }
}
