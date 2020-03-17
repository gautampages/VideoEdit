import 'dart:async';
import 'dart:io';

import './Clip.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ClipDescription extends StatefulWidget {
  Clip image;
  String title;
  int position;
  ClipDescription(this.image, this.title, this.position);
  @override
  _ClipDescriptionState createState() =>
      _ClipDescriptionState(image, title, position);
}

class _ClipDescriptionState extends State<ClipDescription> {
  bool isVisible = false;
  int position;
  String title;
  String code;
  Clip data;
  String text="Play";
  _ClipDescriptionState(this.data, this.title, this.position);

  VideoPlayerController controller;
  ChewieController chewieController;
  Future<void> initilizer;
  Duration startTime;
  Duration endTime;
  bool hasEnded = false;
  @override
  void initState() {
    super.initState();
    code = data.color;
    debugPrint(data.startTime);
    List<String> start = data.startTime.split(":");
    startTime = new Duration(
        hours: int.parse(start[0]),
        minutes: int.parse(start[1]),
        seconds: double.parse(start[2]).round());

    List<String> end = data.endTime.split(":");
    endTime = new Duration(
        hours: int.parse(end[0]),
        minutes: int.parse(end[1]),
        seconds: double.parse(end[2]).round());
    //milliseconds: double.parse(start[2]).round());
    startTimer();
  }

  startTimer() {
    controller = VideoPlayerController.file(File(data.path));
    if(hasEnded==false){
      chewieController = ChewieController(
        videoPlayerController: controller,
        aspectRatio: 3 / 2,
        autoPlay: false,
        autoInitialize: true,
        looping: true,
        startAt: startTime,
        showControls: false,
        materialProgressColors: new ChewieProgressColors(
          playedColor: Colors.red,
          handleColor: Colors.blue,
          backgroundColor: Colors.grey,
          bufferedColor: Colors.lightGreen,

        ),
        placeholder: new Container(
          color: Colors.grey,
        ),
      );
      controller.seekTo(startTime);
    }
    else{
      //controller.seekTo(startTime);
      chewieController = ChewieController(
        videoPlayerController: controller,
        aspectRatio: 3 / 2,
        autoPlay: true,
        autoInitialize: true,
        looping: true,
        startAt: startTime,
        showControls: false,
        materialProgressColors: new ChewieProgressColors(
          playedColor: Colors.red,
          handleColor: Colors.blue,
          backgroundColor: Colors.grey,
          bufferedColor: Colors.lightGreen,

        ),
        placeholder: new Container(
          color: Colors.grey,
        ),
      );
      controller.seekTo(startTime);
//      controller.play();
    }

//    initilizer = controller.initialize().then((_) {
//      setState(() {
//        controller.play();
//        controller.seekTo(startTime);
//      });
//    });
    Timer.periodic(Duration(seconds: 1), (timer) {
      debugPrint("End Time: " + endTime.toString());
      debugPrint("Start Time: " + controller.value.position.toString());
      if (endTime < controller.value.position) {
        print(controller.value.position);
        timer.cancel();
        controller.pause();
        controller.seekTo(startTime);
        hasEnded=true;
        setState(() {
          text="Play";
        });
        //startTimer();
      } else
        hasEnded = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  // @override
  // void initState() {
  //   super.initState();
  //   controller=VideoPlayerController.file(File(data.path));
  //   initilizer=controller.initialize();
  //   var time=DateTime.fromMillisecondsSinceEpoch(data.startTime);
  //   Duration finalTime=new Duration(hours: time.hour,minutes: time.minute,seconds: time.second);
  //   controller.seekTo(finalTime);
  //   controller.setLooping(true);
  //   controller.play();
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        bottomNavigationBar: BottomAppBar(
          child: SizedBox(
              width: double.maxFinite,
              height: 60,
              child: RaisedButton(
                onPressed: () {
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => ProjectList()));
                  Navigator.of(context).pop();
                },
                color: Color(0xFF242B42),
                child: Text(
                  'Back',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              )),
        ),
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(68),
            child: AppBar(
                leading: new IconButton(
                  icon: new Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                    size: 25,
                  ),
                  padding: EdgeInsets.only(top: 12),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                title: Padding(
                  padding: EdgeInsets.only(top: 12),
                  child: Image.asset(
                    'assets/leanedit-logo.png',
                    height: 70,
                    width: 120,
                  ),
                ),
                centerTitle: true,
                backgroundColor: Color(0xFF242B42))),
        backgroundColor: Color(0xFF7ADBFF),
        body: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  color: Colors.white,
                  height: 55,
                  child: Center(
                      child: Text("$title",
                          style: TextStyle(
                              fontSize: 25,
                              color: Color(0xFF242B42),
                              fontFamily: 'BreeSerif'))),
                ),
//
                Chewie(
                  controller: chewieController,
                ),

                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                          width: 75,
                          height: 25,
                          child: FlatButton(
                            child: Text(
                              "$text",
                              style: TextStyle(
                                  color: Color(0xFF242B42),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                            color: Colors.white,
                            onPressed: () {
                              if(controller.value.isPlaying){
                                controller.pause();
                                setState(() {
                                  text="Play";
                                });
                              }
                              else{
                                if(hasEnded){
                                  setState(() {
                                    text="Pause";
                                  });
                                  startTimer();
                                }
                                else{
                                  setState(() {
                                    text="Pause";
                                  });
                                  controller.play();
                                }
                              }
                            },
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(5)),
                          )),
                      SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                          width: 75,
                          height: 25,
                          child: FlatButton(
                            child: Text(
                              "Reset",
                              style: TextStyle(
                                  color: Color(0xFF242B42),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                            color: Colors.white,
                            onPressed: (){
                              controller.pause();
                              controller.seekTo(startTime);
                              setState(() {
                                text="Play";
                              });
                              },
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(5)),
                          ))
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(position.toString() + '. ' + data.title,
                          style: TextStyle(
                              fontSize: 30,
                              color: Color(0xFF242B42),
                              fontFamily: 'BreeSerif')),
                      SizedBox(
                        height: 20,
                      ),
                      Text(data.description),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        children: <Widget>[
                          Text('Color- '),
                          SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            height: 18,
                            width: 249,
                            child: RaisedButton(
                              onPressed: () {},
                              // color: hexToColor(code),
                              color: Color(int.parse(data.color)),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
              ]),
        ),
        // floatingActionButton: Visibility(
        //   visible: isVisible,
        //   child: Container(
        //     padding: EdgeInsets.only(
        //         left: 70.0, top: 30.0, bottom: 320.0, right: 160.0),
        //     child: FloatingActionButton(
        //       backgroundColor: Colors.transparent,
        //       onPressed: () {
        //         setState(() {
        //           controller.value.isPlaying
        //               ? controller.pause()
        //               : controller.play();
        //         });
        //       },
        //       child: Icon(
        //         controller.value.isPlaying ? Icons.pause : Icons.play_arrow,size: 50,
        //       ),
        //     ),
        //   ),
        // ),
      ),
    );
  }

  Color hexToColor(String code1) {
    return new Color(int.parse(code1));
  }
}
