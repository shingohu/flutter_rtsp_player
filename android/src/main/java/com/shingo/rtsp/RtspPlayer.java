package com.shingo.rtsp;

import android.content.Context;
import android.net.Uri;
import android.util.Log;
import android.view.View;


import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import org.videolan.libvlc.LibVLC;
import org.videolan.libvlc.Media;
import org.videolan.libvlc.MediaPlayer;
import org.videolan.libvlc.interfaces.IVLCVout;

import java.util.ArrayList;
import java.util.List;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.view.TextureRegistry;

public class RtspPlayer implements PlatformView, MethodChannel.MethodCallHandler {


    private LibVLC libVLC;
    private Media media;


    private VLCTextureView textureView;


    private MediaPlayer mediaPlayer;

    private List<String> options;
    private Context context;
    private int viewId;

    private MethodChannel methodChannel;

    public RtspPlayer(int viewId, Context context, BinaryMessenger binaryMessenger, TextureRegistry textureRegistry) {
        this.viewId = viewId;
        this.context = context;
        textureView = new VLCTextureView(context);
        methodChannel = new MethodChannel(binaryMessenger, "rtsp_player" + "_" + viewId);
        methodChannel.setMethodCallHandler(this);
    }


    public void initialize(List<String> options, String url, boolean autoPlay) {
        this.options = options;
        libVLC = new LibVLC(context, options);
        mediaPlayer = new MediaPlayer(libVLC);

        mediaPlayer.getVLCVout().setVideoView(textureView);
        mediaPlayer.getVLCVout().setWindowSize(textureView.getWidth(), textureView.getHeight());
        textureView.setMediaPlayer(mediaPlayer);
        mediaPlayer.setVideoTrackEnabled(true);

        mediaPlayer.getVLCVout().attachViews();
        media = new Media(libVLC, Uri.parse(url));
        for (int i = 0; i < options.size(); i++) {
            media.addOption(options.get(i));
        }
        media.setHWDecoderEnabled(true, false);
        mediaPlayer.setMedia(media);
        media.release();
        if (autoPlay) {
            play();
        }
    }


    void play() {
        if (mediaPlayer != null) {
            mediaPlayer.play();
        }
    }

    void pause() {
        if (mediaPlayer != null) {
            mediaPlayer.pause();
        }
    }

    void stop() {
        if (mediaPlayer != null) {
            mediaPlayer.stop();
        }
    }

    boolean isPlaying() {
        if (mediaPlayer == null) return false;
        return mediaPlayer.isPlaying();
    }


    @Nullable
    @Override
    public View getView() {
        return textureView;
    }

    @Override
    public void dispose() {
        release();
    }


    void release() {

        if (mediaPlayer != null) {
            mediaPlayer.stop();
            mediaPlayer.getVLCVout().detachViews();
            mediaPlayer.release();
        }
        if (libVLC != null) {
            libVLC.release();
            libVLC = null;
        }
        methodChannel = null;
        mediaPlayer = null;
        media = null;
        textureView = null;
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        String method = call.method;
        if ("initialize".equals(method)) {
            List<String> options = call.argument("options");
            String url = call.argument("url");
            boolean autoPlay = call.argument("autoPlay");

            initialize(options, url, autoPlay);
            result.success(true);
        } else if ("play".equals(method)) {
            play();
            result.success(true);
        } else if ("stop".equals(method)) {
            stop();
            result.success(true);
        } else if ("pause".equals(method)) {
            pause();
            result.success(true);
        } else if ("isPlaying".equals(method)) {
            result.success(isPlaying());
        }


    }
}
