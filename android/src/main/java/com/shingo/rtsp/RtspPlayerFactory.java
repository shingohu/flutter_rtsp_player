package com.shingo.rtsp;

import android.content.Context;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import io.flutter.plugin.common.BinaryMessenger;

import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;
import io.flutter.view.TextureRegistry;

public class RtspPlayerFactory extends PlatformViewFactory {
    private BinaryMessenger messenger;
    private TextureRegistry textureRegistry;

    public RtspPlayerFactory(BinaryMessenger messenger, TextureRegistry textureRegistry) {
        super(StandardMessageCodec.INSTANCE);
        this.messenger = messenger;
        this.textureRegistry = textureRegistry;
    }

    @NonNull
    @Override
    public PlatformView create(Context context, int viewId, @Nullable Object args) {
        return new RtspPlayer(viewId, context, messenger, textureRegistry);
    }

}
