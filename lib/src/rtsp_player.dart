import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rtsp_player/src/rtsp_player_controller.dart';
import 'package:visibility_detector/visibility_detector.dart';

class RtspPlayer extends StatefulWidget {
  final double aspectRatio;
  final Widget? placeholder;
  final RtspPlayerController controller;
  final bool? virtualDisplay;

  const RtspPlayer(
      {super.key,
      required this.aspectRatio,
      this.placeholder,
      this.virtualDisplay,
      required this.controller});

  @override
  State<RtspPlayer> createState() => _RtspPlayerState();
}

class _RtspPlayerState extends State<RtspPlayer>
    with AutomaticKeepAliveClientMixin, WidgetsBindingObserver {
  ///platformview created
  bool get _isInitialized => widget.controller.isInitialized;

  GlobalKey _key = GlobalKey();

  @override
  bool get wantKeepAlive => true;

  bool _visibility = false;

  @override
  void initState() {
    widget.controller.addListener(refresh);
    super.initState();
  }

  void refresh() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(refresh);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return VisibilityDetector(
      key: _key,
      onVisibilityChanged: (info) {
        if (info.visibleFraction == 1) {
          _visibility = true;
          _onVisibilityChanged();
        } else if (info.visibleFraction == 0) {
          _visibility = false;
          _onVisibilityChanged();
        }
      },
      child: AspectRatio(
        aspectRatio: widget.aspectRatio,
        child: Stack(
          children: [
            Offstage(
              offstage: _isInitialized,
              child: widget.placeholder ?? Container(),
            ),
            Offstage(
              offstage: !_isInitialized,
              child: _buildPlatformView(
                  virtualDisplay: widget.virtualDisplay ?? true),
            ),
          ],
        ),
      ),
    );
  }

  /// The `virtualDisplay` specifies whether Virtual displays or Hybrid composition is used on Android.
  Widget _buildPlatformView({required bool virtualDisplay}) {
    String viewType = "rtsp_player";
    if (Platform.isAndroid) {
      if (virtualDisplay) {
        return AndroidView(
          viewType: viewType,
          hitTestBehavior: PlatformViewHitTestBehavior.transparent,
          creationParamsCodec: const StandardMessageCodec(),
          onPlatformViewCreated: (id) {
            widget.controller.onPlatformViewCreated(id);
          },
        );
      } else {
        return PlatformViewLink(
          viewType: viewType,
          surfaceFactory: (
            BuildContext context,
            PlatformViewController controller,
          ) {
            return AndroidViewSurface(
              controller: controller as AndroidViewController,
              gestureRecognizers: const {},
              hitTestBehavior: PlatformViewHitTestBehavior.transparent,
            );
          },
          onCreatePlatformView: (PlatformViewCreationParams params) {
            return PlatformViewsService.initSurfaceAndroidView(
              id: params.id,
              viewType: viewType,
              layoutDirection: TextDirection.ltr,
              creationParamsCodec: const StandardMessageCodec(),
            )
              ..addOnPlatformViewCreatedListener(params.onPlatformViewCreated)
              ..addOnPlatformViewCreatedListener((id) {
                widget.controller.onPlatformViewCreated(id);
              })
              ..create();
          },
        );
      }
    } else if (Platform.isIOS) {
      return UiKitView(
        viewType: viewType,
        onPlatformViewCreated: (id) {
          widget.controller.onPlatformViewCreated(id);
        },
        hitTestBehavior: PlatformViewHitTestBehavior.transparent,
        creationParamsCodec: const StandardMessageCodec(),
      );
    }

    return Container();
  }

  void _onVisibilityChanged() async {
    if (!mounted) {
      return;
    }
    if (widget.controller.isInitialized) {
      if (_visibility) {
        if (widget.controller.autoPlay &&
            widget.controller.playInterrupted == false) {
          widget.controller.play();
        }
      } else {
        widget.controller.stop();
      }
    }
  }
}
