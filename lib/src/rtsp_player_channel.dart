import 'package:flutter/services.dart';

late _RtspPlayerChannel RtspPlayerChannel = _RtspPlayerChannel._();

class _RtspPlayerChannel {
  _RtspPlayerChannel._();

  MethodChannel methodChannel(int viewId) {
    return MethodChannel("rtsp_player_$viewId");
  }

  Future<void> create(int viewId, dynamic arg) async {
    MethodChannel channel = methodChannel(viewId);
    channel.invokeMethod("initialize", arg);
  }

  Future<void> play(int viewId) async {
    MethodChannel channel = methodChannel(viewId);
    channel.invokeMethod("play");
  }

  Future<void> stop(int viewId) async {
    MethodChannel channel = methodChannel(viewId);
    channel.invokeMethod("stop");
  }

  Future<void> pause(int viewId) async {
    MethodChannel channel = methodChannel(viewId);
    channel.invokeMethod("pause");
  }
}
