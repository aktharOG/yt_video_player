import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:yt/utility/connection_check.dart';
import 'package:yt/utility/custom_text.dart';

bool isFullScreen = false;

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen(
      {Key? key,
})
      : super(key: key);


  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  static const MethodChannel _channel = MethodChannel('video_player');
  double _currentPosition = 0.0;

  void _handleRetryButtonClick() {
    // Implement your retry logic here
    // For example, you might want to restart the video, show a message, etc.
    print('Retry button clicked!');
    // You could also trigger a video reload or reset the video player state here
  }

  final  String videoUrl = "https://youtu.be/0pWsCiBvLOk?si=uhi0wUdcySI7mqZx";

  void _initializeMethodChannel() async {
    await InternetConnectivity().checking();

    _channel.setMethodCallHandler((MethodCall call) async {
      switch (call.method) {
        case 'updatePosition':
          double position = call.arguments as double;
          setState(() {
            _currentPosition = position;
            log("position : $_currentPosition");
          });
          break;
        case 'onPositionChanged':
          double position = call.arguments as double;
          _currentPosition = position;
          print("Video position: $position");
          break;
        case 'onStateChanged':
          setState(() {
            String status = call.arguments as String;
            log("Current Status: $status");
          });
          break;
        case 'onRetryButtonClicked':
          _handleRetryButtonClick();
          break;
        default:
          throw MissingPluginException('notImplemented');
      }
    });
  }

  @override
  void initState() {
    _initializeMethodChannel();
    super.initState();
  }

  @override
  void dispose() {
    _channel.setMethodCallHandler(null);

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  Future<void> openUrl(String url, String title) async {
    try {
      const channel = MethodChannel('video_player');
      await channel.invokeMethod('loadUrl', {'url': url, 'title': title});
    } catch (e) {
      debugPrint('Error opening url: $e');
    }
  }

  String? youTubeVideoId(String url) {
    final RegExp regExp = RegExp(
      r'(?:https?:\/\/)?(?:www\.)?(?:youtube\.com\/(?:[^\/\n\s]+\/\S+\/|(?:v|e(?:mbed|live)?)\/|\S*?[?&]v=)|youtu\.be\/|youtube\.com\/live\/)([a-zA-Z0-9_-]{11})',
      caseSensitive: false,
      multiLine: false,
    );

    final Match? match = regExp.firstMatch(url);
    return match?.group(1); // Returns the video ID or null if not found
  }

  Orientation orientation = Orientation.portrait;
  @override
  Widget build(BuildContext context) {
   
    orientation = MediaQuery.of(context).orientation;

    if (orientation == Orientation.landscape) {
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.immersiveSticky,
      ); // to only hide the status bar
    } else {
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: SystemUiOverlay.values,
      );
    }

    // return OrientationBuilder(builder: (context, Orientation orientation) {
    //   if (orientation == Orientation.landscape) {
    //     SystemChrome.setEnabledSystemUIM,,,ode(SystemUiMode.manual, overlays: [
    //       SystemUiOverlay.bottom,
    //       SystemUiOverlay.top
    //     ]); // to only hide the status bar

    // log("https://www.youtube.com/embed/${youTubeVideoId(widget.singleLesson.url.toString())}?rel=0");

    return PopScope(
    
      child: Scaffold(
        appBar: orientation == Orientation.portrait
            ? AppBar(title: Text("video"),)
            : null,
        body: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: const AssetImage("assets/images/scaffold_image.png"),
                colorFilter: orientation == Orientation.landscape
                    ? const ColorFilter.mode(Colors.black, BlendMode.src)
                    : null,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(
                  orientation == Orientation.landscape ? 0 : 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (InternetConnectivity.isInternetAvilable == true)
                    Flexible(
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: orientation == Orientation.portrait
                                ? BorderRadius.circular(10)
                                : BorderRadius.zero,
                            child: AspectRatio(
                              aspectRatio: orientation == Orientation.landscape
                                  ? MediaQuery.of(context).size.aspectRatio
                                  : 16 / 9,
                              child: Container(
                                color: Colors.black,
                                child: AndroidView(
                                  viewType: 'native_video_view',
                                  creationParams: {
                                    'url':
                                        'https://www.youtube.com/embed/${youTubeVideoId(videoUrl.toString())}?rel=0&autoplay=1',
                                  },
                                  creationParamsCodec:
                                      const StandardMessageCodec(),
                                ),
                              ),
                            ),
                          ),
                          if (orientation == Orientation.portrait)
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Stack(
                                children: [
                                  GestureDetector(
                                    onTap: () {},
                                    child: Opacity(
                                      opacity: 0,
                                      child: Container(
                                        height: 50,
                                        width: 70,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 8,
                                    right: 22,
                                    child: InkWell(
                                      onTap: () {
                                        SystemChrome.setPreferredOrientations([
                                          DeviceOrientation.landscapeRight,
                                          DeviceOrientation.landscapeLeft,
                                        ]);
                                      },
                                      child: const Opacity(
                                        opacity: 0,
                                        child: Icon(
                                          Icons.fullscreen,
                                          color: Colors.white,
                                          size: 30,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          if (orientation == Orientation.landscape)
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Stack(
                                children: [
                                  GestureDetector(
                                    onTap: () {},
                                    child: Opacity(
                                      opacity: 0,
                                      child: Container(
                                        height: 100,
                                        width: 70,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 8,
                                    right: 21,
                                    child: InkWell(
                                      onTap: () {
                                        SystemChrome.setPreferredOrientations([
                                          DeviceOrientation.portraitUp,
                                        ]);
                                        SystemChrome.setEnabledSystemUIMode(
                                            SystemUiMode.manual);
                                      },
                                      child: const Opacity(
                                        opacity: 0,
                                        child: Icon(
                                          Icons.fullscreen,
                                          color: Colors.white,
                                          size: 30,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    )
                  else
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: AspectRatio(
                        aspectRatio: orientation == Orientation.landscape
                            ? MediaQuery.of(context).size.aspectRatio
                            : 16 / 9,
                        child: Container(
                            color: Colors.black,
                            child: const Center(
                              child: RefractedTextWidget(
                                  textColor: Colors.white,
                                  text: "No Internet Connection"),
                            )),
                      ),
                    ),
                  if (orientation == Orientation.portrait) ...[
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: RefractedTextWidget(
                        text: "video title",
                        maxLines: 5,
                        textSize: 16,
                        textWeight: FontWeight.w600,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: RefractedTextWidget(
                        text: "description",
                        maxLines: 5,
                        textSize: 16,
                        textWeight: FontWeight.w400,
                      ),
                    ),
                   
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
