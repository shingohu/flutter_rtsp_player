package com.shingo.rtsp;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/**
 * FlutterRtspPlayerPlugin
 */
public class FlutterRtspPlayerPlugin implements FlutterPlugin {


    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        flutterPluginBinding.getPlatformViewRegistry().registerViewFactory("rtsp_player", new RtspPlayerFactory(
                flutterPluginBinding.getBinaryMessenger(),
                flutterPluginBinding.getTextureRegistry()
        ));
    }


    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {

    }
}
