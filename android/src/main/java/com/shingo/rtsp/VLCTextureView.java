package com.shingo.rtsp;

import android.content.Context;
import android.graphics.SurfaceTexture;
import android.os.Build;
import android.os.Handler;
import android.os.Looper;
import android.util.AttributeSet;
import android.util.Log;
import android.util.Size;
import android.view.TextureView;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import org.videolan.libvlc.MediaPlayer;
import org.videolan.libvlc.interfaces.IVLCVout;

import io.flutter.view.TextureRegistry;

public class VLCTextureView extends TextureView implements View.OnLayoutChangeListener {


    private MediaPlayer mMediaPlayer;

    public VLCTextureView(@NonNull Context context) {
        super(context);
        initView();
    }

    public VLCTextureView(@NonNull Context context, @Nullable AttributeSet attrs) {
        super(context, attrs);
        initView();
    }

    public VLCTextureView(@NonNull Context context, @Nullable AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        initView();
    }


    private void initView() {
        addOnLayoutChangeListener(this);
    }

    @Override
    protected void onLayout(boolean changed, int left, int top, int right, int bottom) {
        super.onLayout(changed, left, top, right, bottom);
        updateLayoutSize();
    }

    @Override
    public void addOnLayoutChangeListener(OnLayoutChangeListener listener) {
        super.addOnLayoutChangeListener(listener);
    }

    @Override
    public void onLayoutChange(View v, int left, int top, int right, int bottom, int oldLeft, int oldTop, int oldRight, int oldBottom) {
        if (left != oldLeft || top != oldTop || right != oldRight || bottom != oldBottom) {
            updateLayoutSize();
        }
    }


    public void setMediaPlayer(MediaPlayer mediaPlayer) {
        mMediaPlayer = mediaPlayer;
    }

    public void updateLayoutSize() {
        int width = getWidth();
        int height = getHeight();
        if (mMediaPlayer != null) {
            mMediaPlayer.getVLCVout().setWindowSize(width, height);
        }
    }
}