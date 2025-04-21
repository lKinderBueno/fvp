import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:fvp/fvp.dart' as fvp;

void main() {
  //registerWith(options: {
  //    'lowLatency': 1, // optional for network streams
  //    });
  //
  runApp(const VideoApp());
}

/// Stateful widget to fetch and then display video content.
class VideoApp extends StatefulWidget {
  const VideoApp({super.key});

  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    fvp.registerWith();
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse('https://mirror.selfnet.de/CCC/congress/2019/h264-hd/36c3-10517-deu-eng-fra-Megatons_to_Megawatts_hd.mp4'));
    _controller.play();
    //test();
    _initializeVideoPlayerFuture = _controller.initialize();
  }
  
  void test() async{
    var audio = await _controller.getAudioTracks();
    _controller.setAudioTrackByIndex(1);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Demo',
      home: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
                          test();

          },
          child: Icon(
            _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          ),
        ),

        body: Center(
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: FutureBuilder(
              future: _initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  // If the VideoPlayerController has finished initialization, use
                  // the data it provides to limit the aspect ratio of the video.
                  return AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    // Use the VideoPlayer widget to display the video.
                    child: VideoPlayer(_controller),
                  );
                } else {
                  // If the VideoPlayerController is still initializing, show a
                  // loading spinner.
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
