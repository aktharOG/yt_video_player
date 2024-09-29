package com.example.yt
import android.content.Context
import android.util.TypedValue
import android.view.LayoutInflater
import android.view.View
import android.view.WindowManager
import android.webkit.WebChromeClient
import android.webkit.WebResourceRequest
import android.webkit.WebView
import android.webkit.WebViewClient
import android.widget.FrameLayout
import android.widget.ProgressBar
import androidx.appcompat.app.AppCompatActivity
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.launch
import android.os.Bundle
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.delay
import io.flutter.plugin.common.BinaryMessenger
import android.webkit.JavascriptInterface





class NativeVideoView(context: Context,messenger: BinaryMessenger, id: Int, creationParams: Map<String?, Any?>?) : PlatformView {
    private val view: View = LayoutInflater.from(context).inflate(R.layout.native_video_view, null, false)
    private val webView: WebView = view.findViewById(R.id.webView)
    private val progressBar: ProgressBar = view.findViewById(R.id.loadingIndicator)
    private var customView: View? = null
    private val fullscreenContainer: FrameLayout = FrameLayout(context)
    private val mainLayout: FrameLayout = FrameLayout(context) // Adjust as needed
    private var playingPositionJob: Job? = null
    private var webViewBundle: Bundle? = null
    private val methodChannel = MethodChannel(messenger, "video_player")

    init {
        // WebView setup
        webView.settings.javaScriptEnabled = true
        webView.settings.mediaPlaybackRequiresUserGesture = false


           webView.addJavascriptInterface(object {
    @JavascriptInterface
    fun onPositionChanged(position: Double) {
        // Send the position to Flutter
        CoroutineScope(Dispatchers.Main).launch {
            methodChannel.invokeMethod("onPositionChanged", position)
        }
    }
}, "Android")


        webView.webViewClient = object : WebViewClient() {
            override fun onPageFinished(view: WebView?, url: String?) {
                 val jsCode = """


              // Function to hide elements
    

             function hideElements() {
    var myyoutube = document.getElementsByClassName("ytp-menuitem");
    if (myyoutube.length > 3) {
        myyoutube[4].style.display = 'none';
    }
}

hideElements();
setInterval(hideElements, 500);





                    var fullscreenButton = document.getElementsByClassName("ytp-fullscreen-button ytp-button")
        for (var i=0 ; i<fullscreenButton.length ; i++){fullscreenButton[i].style.display = 'none';}
                   var myyoutubelogo = document.getElementsByClassName("ytp-large-play-button ytp-button ytp-large-play-button-red-bg")
        for (var i=0 ; i<myyoutubelogo.length ; i++){myyoutubelogo[i].style.display = 'none';}
                var myyoutube = document.getElementsByClassName("ytp-youtube-button ytp-button yt-uix-sessionlink")
        for (var i=0 ; i<myyoutube.length ; i++){myyoutube[i].style.display = 'none';}
        
        var title = document.getElementsByClassName("ytp-chrome-top ytp-show-cards-title")
        for (var i=0 ; i<title.length ; i++){title[i].style.display = 'none';}
        var endscreen = document.getElementsByClassName("html5-endscreen ytp-player-content videowall-endscreen ytp-endscreen-paginate ytp-show-tiles")
        for (var i=0 ; i<endscreen.length ; i++){endscreen[i].style.display = 'none';}
        var logo = document.getElementsByClassName("annotation annotation-type-custom iv-branding")
        for (var i=0 ; i<logo.length ; i++){logo[i].style.display = 'none';}
        

        var hideOverlayElements = function() {
                    var overlays = document.getElementsByClassName("ytp-pause-overlay-container");
                    for (var i = 0; i < overlays.length; i++) {
                        overlays[i].style.display = 'none';
                    }
                };

                var video = document.querySelector('video');


                 video.addEventListener('timeupdate', function() {
        var position = video.currentTime;
        // Send the position to Flutter
        Android.onPositionChanged(position);
    });

                
                video.addEventListener('pause', function() {
                    hideOverlayElements();
                });

                // Call hideOverlayElements initially to handle the case where the video might already be paused
                hideOverlayElements();

                video.addEventListener('play', function() {
                    setTimeout(function() {
                        hideOverlayElements();
                    }, 500);
                });
        var video = document.querySelector('video');

       video.addEventListener('play', function() {
     var checkElements = setInterval(function() {
        var myyoutube = document.getElementsByClassName("ytp-menuitem");

          for (var i=0 ; i<myyoutube.length ; i++){
      myyoutube[4].style.display = 'none'
            myyoutube[5].style.display = 'none'
            clearInterval(checkElements);
          }
           
           
   
        
        var sub = document.getElementsByClassName("branding-img-container ytp-button")
        for (var i=0 ; i<sub.length ; i++){sub[i].style.display = 'none';}
        

     }, 500); 
      var checkRelatedVideos = setInterval(function() {
        var relatedVideos = document.getElementsByClassName("ytp-endscreen-content");

        if (relatedVideos.length > 0) {
            for (var i = 0; i < relatedVideos.length; i++) {
                relatedVideos[i].style.display = 'none'; 
            }
            clearInterval(checkRelatedVideos);
        }
      }, 500);
       var checkButtons = setInterval(function() {
        var previousButton = document.getElementsByClassName("ytp-button ytp-endscreen-previous");

        if (previousButton.length > 0) {
            for (var i = 0; i < previousButton.length; i++) {
                previousButton[i].style.display = 'none'; 
            }
            clearInterval(checkButtons);
        }
        var nextButton = document.getElementsByClassName("ytp-button ytp-endscreen-next");

        if (nextButton.length > 0) {
            for (var i = 0; i < nextButton.length; i++) {
                nextButton[i].style.display = 'none'; 
            }
            clearInterval(checkButtons);
        }
      }, 500);
          });

        """
                view?.evaluateJavascript(jsCode) { result ->
                    println("JavaScript Injection Result: $result")
                }

                progressBar.visibility = View.GONE
                webView.visibility = View.VISIBLE
            }
        }

        webView.webChromeClient = object : WebChromeClient() {
            override fun onShowCustomView(view: View?, callback: CustomViewCallback?) {
                if (customView != null) {
                    callback?.onCustomViewHidden()
                    return
                }

                // Fullscreen logic
                customView = view
                fullscreenContainer.addView(view)
                fullscreenContainer.visibility = View.VISIBLE
                webView.visibility = View.GONE

                // Assuming this is an Activity
                val activity = context as? AppCompatActivity
                activity?.supportActionBar?.hide()
                activity?.window?.addFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN)
                activity?.window?.decorView?.systemUiVisibility = (
                        View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY
                                or View.SYSTEM_UI_FLAG_HIDE_NAVIGATION
                                or View.SYSTEM_UI_FLAG_FULLSCREEN)
            }

            override fun onHideCustomView() {
                // Exit fullscreen
                if (customView == null) return

                fullscreenContainer.removeView(customView)
                customView = null
                fullscreenContainer.visibility = View.GONE
                val heightInDp = 250
                val heightInPixels = TypedValue.applyDimension(
                    TypedValue.COMPLEX_UNIT_DIP,
                    heightInDp.toFloat(),
                    view.resources.displayMetrics
                ).toInt()
                mainLayout.layoutParams.height = heightInPixels
                webView.visibility = View.VISIBLE

                val activity = context as? AppCompatActivity
                activity?.supportActionBar?.show()
                activity?.window?.clearFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN)
                activity?.window?.decorView?.systemUiVisibility = View.SYSTEM_UI_FLAG_VISIBLE
            }
        }

               webViewBundle?.let { webView.restoreState(it) } ?: webView.loadUrl(creationParams?.get("url") as? String ?: "")

   
             // Polling to get the video position and update Flutter
        playingPositionJob = CoroutineScope(Dispatchers.Main).launch {
            while (true) {
                webView.evaluateJavascript("document.querySelector('video').currentTime.toString();") { result ->
                    if (result != null) {
                        try {
                            val currentPosition = result.toDoubleOrNull() ?: 0.0
                            methodChannel.invokeMethod("updatePosition", currentPosition)
                        } catch (e: Exception) {
                            e.printStackTrace()
                        }
                    }
                }
                delay(500) // Poll every 500 milliseconds
            }
        }
    }

    fun saveState() {
        // Save the WebView state in a Bundle
        webViewBundle = Bundle()
        webView.saveState(webViewBundle!!)
    }
     fun restoreState() {
        webViewBundle?.let {it:Bundle -> webView.restoreState(it) }
    }

    

    override fun getView(): View {
        return view
    }

   override fun dispose() {
        playingPositionJob?.cancel() // Stop tracking when the view is disposed
    }
}

class NativeVideoViewFactory(private val messenger: BinaryMessenger) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(context: Context, id: Int, creationParams: Any?): PlatformView {
        return NativeVideoView(context,messenger, id, creationParams as Map<String?, Any?>?)
    }
}
