import 'dart:io';
import './Project.dart';
import './DBHelper.dart';
import './Add_project.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './Clip_cutting.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:thumbnails/thumbnails.dart';
import 'package:path_provider/path_provider.dart';

class ProjectList extends StatefulWidget {
  @override
  _ProjectListState createState() => _ProjectListState();
}

class _ProjectListState extends State<ProjectList> {
  DatabaseHelper db = new DatabaseHelper();
  List<Project> items = new List();
  List<String> thumbnailImage = new List();
  Project project;
  int position = 0;

  Future getProjectDetails() async {
    var result = await db.getAllProjects();
    // await new Future.delayed(Duration(milliseconds: 500));
    return result;
  }

  _getImage(videoPathUrl) async {
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
//
    setState(() {
      thumbnailImage[position] = thumb;
    });
    position++;
    //return thumbnailImage;
  }

  @override
  void initState() {
    int position = 0;
    super.initState();

    db.getAllProjects().then((notes) {
      setState(() {
        notes.forEach((note) {
          items.add(Project.fromMap(note));
          _getImage(items[position].path);
          position++;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
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
                    onPressed: () => exit(0),
                  ),
                  title: Padding(
                    padding: const EdgeInsets.only(top: 12),
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
              // mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  color: Colors.white,
                  height: 55,
                  child: Center(
                      child: Text("My Projects",
                          style: TextStyle(
                              fontSize: 25,
                              color: Color(0xFF242B42),
                              fontFamily: 'BreeSerif',
                              fontWeight: FontWeight.bold))),
                ),
                FutureBuilder(
                    future: getProjectDetails(),
                    builder: (context, snapshoot) {
                      if (snapshoot.connectionState == ConnectionState.done) {
                      
                        List<Project> it = new List();
                        debugPrint(snapshoot.data.length.toString());
                        for (int i = 0; i < snapshoot.data.length; i++) {
                          it.add(Project.fromMap(snapshoot.data[i]));
                        }

                        return SizedBox(
                          height: MediaQuery.of(context).size.height - 137,
                          child: ListView.builder(
                              padding: EdgeInsets.all(15),
                              itemCount: it.length,
                              itemBuilder: (context, position) {
                                return Column(
                                  children: <Widget>[
                                    SizedBox(
                                      height: 80,
                                      child: ListTile(
                                        title: Text('${it[position].title}',
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 19,
                                                color: Color(0xFF242B42),
                                                fontFamily: 'BreeSerif')),
                                        subtitle: Text(
                                            '${it[position].description}',
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color: Color(0xFF242B42),
                                                fontFamily: 'Roboto')),
                                        leading: Image.file(
                                            File(thumbnailImage[position])),
                                        trailing: IconButton(
                                            icon: Icon(
                                              MdiIcons.trashCanOutline,
                                              size: 30,
                                              color: Colors.blue,
                                            ),
                                            onPressed: () {
                                              thumbnailImage.removeAt(position);
                                              db.deleteProject(it[position].id);
                                              setState(() {
                                                it.removeAt(position);
                                              });
                                            }),
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Clipcutting(
                                                          Project(
                                                              items[position]
                                                                  .title,
                                                              items[position]
                                                                  .description,
                                                              items[position]
                                                                  .path),
                                                          items[position].id)));
                                          db
                                              .getProject(items[position].id)
                                              .then((val) {
                                            setState(() {
                                              project = val;
                                            });
                                          });
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Divider(
                                      color: Colors.blue,
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
                                  strokeWidth: 4.0,
                                ),
                              ),
                            )
                          ],
                        );
                      }
                    })
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
              child: Icon(
                Icons.add,
                size: 35,
              ),
              backgroundColor: Color(0xFF242B42),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Addproject()));
              })),
    );
  }
}
