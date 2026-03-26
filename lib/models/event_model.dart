class Event {
  final String type;
  final String name;
  final DateTime timestamp;

  Event({
    required this.type,
    required this.name,
    required this.timestamp,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      type: json['type'] ?? 'unknown',
      name: json['name'] ?? 'unknown',
      timestamp: json['timestamp'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(json['timestamp'] * 1000)
          : DateTime.now(),
    );
  }
}
