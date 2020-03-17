import 'dart:io';
import './Project_list.dart';
import './Project.dart';
import './Clip.dart';
import './Clip_description.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import './Add_clip.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'DBHelper.dart';
import 'package:thumbnails/thumbnails.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class Clipcutting extends StatefulWidget {
  int id;
  Project image;

  Clipcutting(this.image, this.id);

  @override
  ClipcuttingState createState() => ClipcuttingState(image, id);
}

class ClipcuttingState extends State<Clipcutting> {
  final scaff = GlobalKey<ScaffoldState>();
  bool status = false;
  int id;
  String endTime;
  int clipCount;
  Project data;
  String start;
  String end;
  List<String> thumbnailImage = new List();
  int position = 0;
  Duration lastDuration;
  bool clipPlay = false;

  ClipcuttingState(this.data, this.id);

  DatabaseHelper db = new DatabaseHelper();
  List<Clip> items = new List();
  Clip clip;

  Future getClipDetails() async {
    var result = await db.getAllClip(id);
    return result;
  }

  getClips(int id) {
    db.getAllClip(id).then((notes) {
      setState(() {
        notes.forEach((note) {
          items.add(Clip.fromMap(note));
          _getImage(data.path);
        });
      });

      clipCount = items.length;
      print(clipCount - 1);
      List<String> end = items[clipCount - 1].endTime.split(":");
      lastDuration = new Duration(
          hours: int.parse(end[0]),
          minutes: int.parse(end[1]),
          seconds: double.parse(end[2]).round());

      print('Last Duration: ' + lastDuration.toString());
      if (items.length > 0) {
        setState(() {
          enabled = true;
          cutVisible = true;
        });
      }
    });
  }

  _getImage(videoPathUrl) async {
    var items = videoPathUrl;
//    print(videoPathUrl);
    var appDocDir = await getApplicationDocumentsDirectory();
    final folderPath = appDocDir.path;
    String thumb = await Thumbnails.getThumbnail(
        thumbnailFolder: folderPath,
        videoFile: videoPathUrl,
        imageType: ThumbFormat.PNG,
        //this image will store in created folderpath
        quality: 30);
    thumbnailImage.add(thumb);
    print(thumbnailImage);

    setState(() {
      thumbnailImage[position] = thumb;
      print(thumbnailImage);
    });
    position++;
  }

  VideoPlayerController controller;
  ChewieController chewieController;
  bool enabled = false;
  bool cutVisible = false;
  Duration time = new Duration(seconds: 00);
  Future future;

  @override
  void initState() {
    future = getClipDetails();
    getClips(id);
    super.initState();
    debugPrint(data.path);
    controller = VideoPlayerController.file(File(data.path));
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      child: Scaffold(
          key: scaff,
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
                    onPressed: () => Navigator.pop(context,
                        MaterialPageRoute(builder: (context) => ProjectList())),
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
                  height: 2,
//                  child: Center(
//                      child: Text("${data.title}",
//                          overflow: TextOverflow.ellipsis,
//                          style: TextStyle(
//                              fontSize: 25,
//                              color: Color(0xFF242B42),
//                              fontFamily: 'BreeSerif'))),
                ),
                FutureBuilder(
                    future: future,
                    builder: (context, snapshoot) {
                      if (snapshoot.connectionState == ConnectionState.done) {
                        if (clipPlay == false) {
                          chewieController = ChewieController(
                            videoPlayerController: controller,
                            aspectRatio: 3 / 2,
                            autoPlay: false,
                            startAt: lastDuration,
                            autoInitialize: true,
                            looping: true,
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
                        }
                        return Chewie(
                          controller: chewieController,
                        );
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    }),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                          width: 60,
                          height: 25,
                          child: FlatButton(
                            child: Icon(Icons.fast_rewind,
                                color: Colors.white, size: 20),
                            color: Color(0xFF242B42),
                            onPressed: () {
                              controller.seekTo(controller.value.position -
                                  Duration(seconds: 10));
                            },
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(5)),
                          )),
                      SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                          width: 60,
                          height: 25,
                          child: FlatButton(
                            child: Icon(Icons.play_arrow,
                                color: Colors.white, size: 20),
                            color: Color(0xFF242B42),
                            onPressed: () {
                              controller.play();
                              setState(() {
                                clipPlay = true;
                                status = true;
                                enabled = true;
                                cutVisible = true;
                                start = controller.value.position.toString();
                              });
                            },
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(5)),
                          )),
                      SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                            width: 60,
                            height: 25,
                            child: FlatButton(
                              child: Icon(Icons.content_cut,
                                  color: Colors.white, size: 20),
                              color: Color(0xFF242B42),
                              onPressed: (){
                                  controller.pause();
                                    setState(() {
                                      if(lastDuration==null && start==null){
                                        start=Duration(hours: 00,minutes: 00,seconds: 00,milliseconds: 00).toString();
                                        end = controller.value.position.toString();
                                      }
                                      else if(lastDuration!=null && start==null){
                                        end = controller.value.position.toString();
                                        start = lastDuration.toString();
                                      }
                                      else if(lastDuration!=null && start!=null){
                                        end = controller.value.position.toString();
                                      }
                                    });

                                  Navigator.of(context).pop();
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AddClip(id, data, start, end)));
                              },
                              shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(5)),
                            )),
                      SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                          width: 60,
                          height: 25,
                          child: FlatButton(
                            child: Icon(Icons.rotate_left,
                                color: Colors.white, size: 20),
                            color: Color(0xFF242B42),
                            onPressed: () {
                              if (items.length != 0) {
                                controller.seekTo(lastDuration);
                              } else if (items.length == 0) {
                                controller.seekTo(new Duration(
                                    hours: 00,
                                    minutes: 00,
                                    seconds: 00,
                                    milliseconds: 00));
                              }
                            },
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(5)),
                          )),
                      SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                          width: 60,
                          height: 25,
                          child: FlatButton(
                            child: Icon(Icons.fast_forward,
                                color: Colors.white, size: 20),
                            color: Color(0xFF242B42),
                            onPressed: () {
                              controller.seekTo(controller.value.position +
                                  Duration(seconds: 10));
                            },
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(5)),
                          ))
                    ],
                  ),
                ),
                SizedBox(
                  height: 0,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "${data.title} - Clips",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                FutureBuilder(
                    future: getClipDetails(),
                    builder: (context, snapshoot) {
                      if (snapshoot.connectionState == ConnectionState.done) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height / 3,
                          child: ListView.builder(
                              padding: EdgeInsets.all(5),
                              itemCount: items.length,
                              itemBuilder: (context, position) {
                                int count = position + 1;
                                return Column(
                                  children: <Widget>[
                                    ListTile(
                                      title: Text('${items[position].title}',
                                          style: TextStyle(
                                              fontSize: 19,
                                              color: Color(0xFF242B42),
                                              fontFamily: 'BreeSerif')),
                                      subtitle: Text(
                                          '${items[position].description}',
                                          style: TextStyle(
                                              color: Color(0xFF242B42),
                                              fontFamily: 'Roboto')),
                                      leading: SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height /
                                                10,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                3.5,
                                        child: Center(
                                          child: Row(
                                            children: <Widget>[
                                              CircleAvatar(
                                                backgroundColor:
                                                    Color(0xFF7ADBFF),
                                                radius: 12.0,
                                                child: Text(
                                                  count.toString(),
                                                  style: TextStyle(
                                                    fontSize: 15.0,
                                                    color: Color(0xFF242B42),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                  padding:
                                                      EdgeInsets.only(left: 8)),
                                              Container(
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          width: 3,
                                                          color: Color(
                                                              int.parse(items[
                                                                      position]
                                                                  .color)))),
                                                  child: SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            6,
                                                    child: Image.file(File(
                                                        thumbnailImage[
                                                            position])),
                                                  )),
                                            ],
                                          ),
                                        ),
                                      ),
                                      trailing: IconButton(
                                          icon: Icon(
                                            MdiIcons.trashCanOutline,
                                            size: 30,
                                            color: Colors.blue,
                                          ),
                                          onPressed: () {
                                            showDialog<Null>(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (BuildContext context) {
                                                return new AlertDialog(
                                                  title: Center(
                                                      child: Text('Clip List')),
                                                  content: Text(
                                                      'Are you sure want to delete ?'),
                                                  actions: <Widget>[
                                                    FlatButton(
                                                      child: new Text('Cancel'),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                    FlatButton(
                                                        onPressed: () {
                                                          db.deleteClip(
                                                              items[position]
                                                                  .clipId);
                                                          // for (int i = position;
                                                          //     i < items.length;
                                                          //     i++) {
                                                          //   setState(() {
                                                          //     print(i);
                                                          //     items.removeAt(i);
                                                          //   });
                                                          // }
                                                          // deletefun(position);

                                                          deletefun(position);

                                                          Navigator.of(context)
                                                              .pop();

                                                          if (items.length !=
                                                              0) {
                                                            controller.seekTo(
                                                                lastDuration);
                                                          } else if (items
                                                                  .length ==
                                                              0) {
                                                            controller.seekTo(
                                                                new Duration(
                                                                    hours: 00,
                                                                    minutes: 00,
                                                                    seconds: 00,
                                                                    milliseconds:
                                                                        00));
                                                          }

                                                          final snackBar = SnackBar(
                                                              duration:
                                                                  Duration(
                                                                      seconds:
                                                                          3),
                                                              backgroundColor:
                                                                  Colors.blue,
                                                              content: Text(
                                                                  'Clip deleted..'));
                                                          scaff.currentState
                                                              .showSnackBar(
                                                                  snackBar);
                                                        },
                                                        child: Text('Delete'))
                                                  ],
                                                );
                                              },
                                            );
                                          }),
                                      onTap: () {
                                        controller.pause();
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ClipDescription(
                                                        Clip(
                                                            items[position]
                                                                .projectId,
                                                            items[position]
                                                                .title,
                                                            items[position]
                                                                .description,
                                                            items[position]
                                                                .path,
                                                            items[position]
                                                                .color,
                                                            items[position]
                                                                .startTime,
                                                            items[position]
                                                                .endTime),
                                                        data.title,
                                                        count)));
                                      },
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Divider(
                                      color: Colors.blue[300],
                                      thickness: 1.5,
                                      height: 5,
                                    )
                                  ],
                                );
                              }),
                        );
                      } else {
                        return Column(
                          children: <Widget>[
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 3,
                            ),
                            Center(
                              child: new SizedBox(
                                height: 50.0,
                                width: 50.0,
                                child: new CircularProgressIndicator(
                                  value: null,
                                  strokeWidth: 7.0,
                                ),
                              ),
                            )
                          ],
                        );
                      }
                    })
              ],
            ),
          )),
    );
  }

  deletefun(int position) {
    int length = items.length;
    if (length > 1) {
      if (position == 0) {
        lastDuration =
            Duration(hours: 00, minutes: 00, seconds: 00, milliseconds: 00);
        start =
            Duration(hours: 00, minutes: 00, seconds: 00, milliseconds: 00).toString();
      } else {
        List<String> end = items[position].endTime.split(":");
        lastDuration = new Duration(
            hours: int.parse(end[0]),
            minutes: int.parse(end[1]),
            seconds: double.parse(end[2]).round());
      }
    }
    for (int i = position; i < length; i++) {
      //items.removeAt(i);
      setState(() {
        items.removeAt(position);
      });
      if (items.length == 0) {
        enabled = false;
        cutVisible = false;
      }

      //Navigator.of(context).pop();

    }
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }
}
