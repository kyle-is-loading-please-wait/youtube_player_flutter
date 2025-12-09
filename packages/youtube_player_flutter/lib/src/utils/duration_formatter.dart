// Copyright 2020 Sarbagya Dhaubanjar. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:youtube_player_flutter/src/utils/youtube_player_controller.dart';

/// Formats duration in milliseconds to xx:xx:xx format.
String durationFormatter(int milliseconds, bool isLive) {
  var seconds = milliseconds ~/ 1000;
  final hours = seconds ~/ 3600;
  seconds = seconds % 3600;
  var minutes = seconds ~/ 60;
  seconds = seconds % 60;
  final hoursString = hours >= 10
      ? '$hours'
      : hours == 0
          ? '00'
          : '0$hours';
  final minutesString = minutes >= 10
      ? '$minutes'
      : minutes == 0
          ? '00'
          : '0$minutes';
  final secondsString = seconds >= 10
      ? '$seconds'
      : seconds == 0
          ? '00'
          : '0$seconds';
  final formattedTime =
      '${hoursString == '00' ? '' : '$hoursString:'}$minutesString:$secondsString';
  if (isLive) {
    return '-$formattedTime';
  }

  return formattedTime;
}

String durationFormatterFromController(YoutubePlayerController controller,
    {int? selectedTimeMs}) {
  final isLive = controller.flags.isLive;
  final duration = controller.metadata.duration.inMilliseconds;
  final position = selectedTimeMs ?? controller.value.position.inMilliseconds;
  final videoLengthMs = controller.metadata.totalVideoLengthMs;

  if (isLive && position == videoLengthMs) {
    return 'Live';
  }

  final offset = videoLengthMs - position;

  return durationFormatter(offset, controller.flags.isLive);
}
