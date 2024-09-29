package com.example.yt


import android.content.Intent
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformViewRegistry
import com.example.yt.NativeVideoViewFactory
import io.flutter.embedding.engine.FlutterEngine
import android.view.WindowManager


class MainActivity : FlutterActivity() {

        private lateinit var nativeVideoView: NativeVideoView

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        //block scrennshot
        window.addFlags(WindowManager.LayoutParams.FLAG_SECURE)

        // Register the native view factory
        flutterEngine!!.platformViewsController?.registry?.registerViewFactory(
            "native_video_view",
            NativeVideoViewFactory(flutterEngine!!.dartExecutor.binaryMessenger)
        )

         if (savedInstanceState != null) {
            nativeVideoView.restoreState()
        }

       
    }

     override fun onSaveInstanceState(outState: Bundle) {
        super.onSaveInstanceState(outState)
        if (::nativeVideoView.isInitialized) {
   nativeVideoView.saveState()
        }
     
    }
}
