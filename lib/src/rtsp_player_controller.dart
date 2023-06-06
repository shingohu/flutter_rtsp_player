import 'package:flutter/cupertino.dart';
import 'package:flutter_rtsp_player/src/rtsp_player_channel.dart';

class RtspPlayerController extends ChangeNotifier {
  /// The viewId for this controller
  late int _viewId;

  final String url;

  final List<String> options;
  final bool autoPlay;

  /// Indicates whether or not the vlc is ready to play.
  bool isInitialized = false;

  Future<void> onPlatformViewCreated(int viewId) async {
    _viewId = viewId;
    await _initialize();
    isInitialized = true;
    notifyListeners();
  }

  RtspPlayerController(this.url, {required this.options, this.autoPlay = false})
      : assert(url.startsWith("rtsp"), "仅支持rtsp");

  Future<void> _initialize() async {
    RtspPlayerChannel.create(_viewId, {
      "options": options,
      "autoPlay": autoPlay,
      "url": url,
    });
  }

  Future<void> play() async {
    if (isInitialized) {
      RtspPlayerChannel.play(_viewId);
    }
  }

  Future<void> stop() async {
    if (isInitialized) {
      RtspPlayerChannel.stop(_viewId);
    }
  }

  Future<void> pause() async {
    if (isInitialized) {
      RtspPlayerChannel.pause(_viewId);
    }
  }
}
