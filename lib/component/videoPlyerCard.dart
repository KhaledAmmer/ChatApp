import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:khaledchat/component/Icon.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerCard extends StatefulWidget {
  final videoPath;
  final isStatus;

  VideoPlayerCard(this.videoPath, {this.isStatus = false});

  @override
  _VideoPlayerCardState createState() => _VideoPlayerCardState();
}

class _VideoPlayerCardState extends State<VideoPlayerCard> {
  VideoPlayerController? cVideo;
  bool isPlay = false;
  bool isIntialize = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cVideo = VideoPlayerController.network(widget.videoPath)
      ..initialize().then((value) {
        isIntialize = true;
        setState(() {});
      });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if(cVideo!=null)
    cVideo!.pause();
  }

  @override
  Widget build(BuildContext context) {
    return !widget.isStatus
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: MediaQuery.of(context).size.width / 1.8,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1),
              ),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                      height: MediaQuery.of(context).size.width / 2,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12, width: 1),
                      ),
                      child: VideoPlayer(cVideo!)),
                  VideoIcons()
                ],
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black,
            ),
            body: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                isIntialize
                    ? VideoPlayer(cVideo!)
                    : Align(alignment: Alignment.center,child: CircularProgressIndicator()),
                VideoIcons()
              ],
            ),
          );
  }

  Container VideoIcons() {
    return Container(
      color: Color.fromRGBO(246, 243, 242, 0.11764705882352941),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildIcon(
              icon: isPlay ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
              size: 30.0,
              fun: () {
                if (isPlay) {
                  isPlay = false;
                  cVideo!.pause();
                  setState(() {});
                } else {
                  isPlay = true;
                  cVideo!.play();
                  setState(() {});
                }
              }),
          buildIcon(
              icon: Icons.stop,
              color: Colors.white,
              size: 30.0,
              fun: () {
                isPlay = false;
                cVideo!.pause();
                cVideo!.seekTo(Duration(seconds: 0));
                setState(() {});
              }),
        ],
      ),
    );
  }
}
