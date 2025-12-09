//Milliseconds prior max for live YouTube video
const int _maxDurationMs = 43200000;

/// Meta data for Youtube Video.
class YoutubeMetaData {
  /// Youtube video ID of the currently loaded video.
  final String videoId;

  /// Video title of the currently loaded video.
  final String title;

  /// Channel name or uploader of the currently loaded video.
  final String author;

  /// Total duration of the currently loaded video.
  final Duration duration;

  final int totalVideoLengthMs;

  final DateTime? startedTime;

  /// Creates [YoutubeMetaData] for Youtube Video.
  const YoutubeMetaData(
      {this.videoId = '',
      this.title = '',
      this.author = '',
      this.duration = const Duration(),
      this.totalVideoLengthMs = 0,
      this.startedTime});

  /// Creates [YoutubeMetaData] from raw json video data.
  factory YoutubeMetaData.fromRawData(dynamic rawData, {bool isLive = false}) {
    final data = rawData as Map<String, dynamic>;
    final int totalLength =
        (((data['duration'] ?? 0).toDouble() * 1000).floor());

    return YoutubeMetaData(
      videoId: data['videoId'],
      title: data['title'],
      author: data['author'],
      duration: Duration(milliseconds: isLive ? _maxDurationMs : totalLength),
      startedTime: DateTime.now(),
      totalVideoLengthMs: totalLength,
    );
  }

  @override
  String toString() {
    return '$runtimeType('
        'videoId: $videoId, '
        'title: $title, '
        'author: $author, '
        'duration: ${duration.inSeconds} sec.)';
  }
}
