class TrackingStatusModel {
  final String status;
  final String description;
  final DateTime timestamp;
  final String icon;

  TrackingStatusModel({
    required this.status,
    required this.description,
    required this.timestamp,
    required this.icon,
  });

  factory TrackingStatusModel.fromJson(Map<String, dynamic> json) =>
      TrackingStatusModel(
        status: json["status"],
        description: json["description"],
        timestamp: DateTime.parse(json["timestamp"]),
        icon: json["icon"],
      );
}
