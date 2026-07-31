class TrackingModel {
  const TrackingModel({
    required this.title,
    required this.timestamp,
    required this.isCompleted,
    required this.isCurrent,
  });

  final String title;
  final String timestamp;
  final bool isCompleted;
  final bool isCurrent;
}
