//Maximum length of youtube live video in ms (12hr)
const int maxDurationMs = 43200000;

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

  /// The actual total ms length of video
  /// Livestreams can be many hundreds of hours long, but can only be
  /// rewound a total of 12hr at max
  final int totalVideoLengthMs;

  /// Creates [YoutubeMetaData] for Youtube Video.
  const YoutubeMetaData({
    this.videoId = '',
    this.title = '',
    this.author = '',
    this.duration = const Duration(),
    this.totalVideoLengthMs = 0,
  });

  /// Creates [YoutubeMetaData] from raw json video data.
  factory YoutubeMetaData.fromRawData(dynamic rawData) {
    final data = rawData as Map<String, dynamic>;
    final int totalLength =
        (((data['duration'] ?? 0).toDouble() * 1000).floor());

    final bool isLive = data['isLive'] ?? false;

    //Calculate duration based on live stream or prerecorded video
    //Live streams can only be 12hr max
    //If a livestream is less than 12hr long, use the actual duration of the livestream
    late final int duration;
    if (isLive) {
      duration = totalLength < maxDurationMs ? totalLength : maxDurationMs;
    } else {
      duration = totalLength;
    }

    return YoutubeMetaData(
      videoId: data['videoId'],
      title: data['title'],
      author: data['author'],
      duration: Duration(milliseconds: duration),
      totalVideoLengthMs: totalLength,
    );
  }

  @override
  String toString() {
    return '$runtimeType('
        'videoId: $videoId, '
        'title: $title, '
        'author: $author, '
        'duration: ${duration.inSeconds} sec.,'
        'totalVideoLengthMs: $totalVideoLengthMs}';
  }
}
