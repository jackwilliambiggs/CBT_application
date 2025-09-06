class ThoughtEntry {
  final String thought;
  final List<String> distortions;
  final String response;
  final DateTime timestamp;

  ThoughtEntry({
    required this.thought,
    required this.distortions,
    required this.response,
    required this.timestamp,
  });
}