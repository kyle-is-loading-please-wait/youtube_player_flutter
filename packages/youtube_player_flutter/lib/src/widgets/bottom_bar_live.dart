// Copyright 2020 Sarbagya Dhaubanjar. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import '../utils/youtube_player_controller.dart';
import 'duration_widgets.dart';
import 'full_screen_button.dart';

/// A widget to display bottom controls bar on Live Video Mode.
class LiveBottomBar extends StatefulWidget {
  /// Creates [LiveBottomBar] widget.
  const LiveBottomBar({
    super.key,
    this.controller,
    required this.liveUIColor,
    required this.showLiveFullscreenButton,
  });

  /// Overrides the default [YoutubePlayerController].
  final YoutubePlayerController? controller;

  /// Defines color for UI.
  final Color liveUIColor;

  /// Defines whether to show or hide the fullscreen button
  final bool showLiveFullscreenButton;

  @override
  State<LiveBottomBar> createState() => _LiveBottomBarState();
}

class _LiveBottomBarState extends State<LiveBottomBar> {
  double _currentSliderPosition = 0.0;
  late YoutubePlayerController _controller;
  bool init = false;
  int selectedTimeMs = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final controller = YoutubePlayerController.of(context);
    if (controller == null) {
      assert(
      widget.controller != null,
      '\n\nNo controller could be found in the provided context.\n\n'
          'Try passing the controller explicitly.',
      );
      _controller = widget.controller!;
    } else {
      _controller = controller;
    }
    _controller.addListener(listener);
  }

  @override
  void dispose() {
    _controller.removeListener(listener);
    super.dispose();
  }

  void listener() {
    if (mounted) {
      final totalTimeMs = _controller.metadata.totalVideoLengthMs;

      final durationMs = _controller.value.metaData.duration.inMilliseconds;

      final minimumTimeMs = totalTimeMs - durationMs;
      final newPositionMs = selectedTimeMs - minimumTimeMs;

      final double newPosition = totalTimeMs == 0 || newPositionMs < 0
          ? 0
          : newPositionMs / durationMs;

      setState(() {
        if(!init && totalTimeMs > 0){
          selectedTimeMs = totalTimeMs;
          init = true;
        }
        _currentSliderPosition = newPosition > 1 ? 1 : newPosition;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLive = selectedTimeMs == _controller.metadata.totalVideoLengthMs;
    final liveButton = isLive ? Container() : InkWell(
      onTap: () {
        _controller.seekTo(Duration(
            milliseconds: _controller.metadata.totalVideoLengthMs));
        selectedTimeMs = _controller.value.position.inMilliseconds;
      },
      child: Material(
        color: widget.liveUIColor,
        child: const Text(
          ' LIVE ',
          style: TextStyle(
            color: Colors.white,
            fontSize: 12.0,
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
    );
    return Visibility(
      visible: _controller.value.isControlsVisible,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SizedBox(
            width: 14.0,
          ),
          CurrentPosition(selectedTimeMs: selectedTimeMs),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Slider(
                value: _currentSliderPosition,
                onChanged: (value) {
                  final durationMs = _controller.metadata.totalVideoLengthMs;
                  final vidLengthMs =
                      _controller.metadata.duration.inMilliseconds;
                  final minMs = durationMs - vidLengthMs;

                  final selectedPosition =
                      (vidLengthMs * value).round() + minMs;
                  final newPosition = selectedPosition > durationMs
                      ? durationMs
                      : selectedPosition;

                  _controller.seekTo(
                    Duration(
                      milliseconds: newPosition,
                    ),
                  );
                  selectedTimeMs = _controller.value.position.inMilliseconds;
                },
                activeColor: widget.liveUIColor,
                inactiveColor: Colors.transparent,
              ),
            ),
          ),
          liveButton,
          widget.showLiveFullscreenButton
              ? FullScreenButton(controller:
          _controller) : const SizedBox(width: 14.0),
        ],
      )
      ,
    );
  }
}
