import 'dart:io';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import './DBHelper.dart';
import './Project.dart';
import './Project_list.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Addproject extends StatefulWidget {
  @override
  AddprojectState createState() => AddprojectState();
}

class AddprojectState extends State<Addproject> {
  DatabaseHelper db = new DatabaseHelper();
  String name = "no video selected";
  File image;

  Future getImage() async {
    var temp = await ImagePicker.pickVideo(source: ImageSource.gallery);
    setState(() {
      image = temp;
      name = image.path.split('/').last;
    });
  }

  final _formKey = GlobalKey<FormState>();
  TextEditingController title = new TextEditingController();
  TextEditingController desc = new TextEditingController();

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
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                color: Colors.white,
                height: 55,
                child: Center(
                    child: Text("Create New Project",
                        style: TextStyle(
                            fontSize: 25,
                            color: Color(0xFF242B42),
                            fontFamily: 'BreeSerif'))),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.only(left: 30, right: 30),
                child: Text("Select Video"),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: Row(
                  children: <Widget>[
                    ButtonTheme(
                      height: 59,
                      minWidth: MediaQuery.of(context).size.width/3,
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(6),
                                bottomLeft: Radius.circular(6))),
                        color: Color(0xFF242B42),
                        child: Text(
                          'Choose Video',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                        onPressed: getImage,
                      ),
                    ),
                    Expanded(
                      child: Stack(
                        children: <Widget>[
                          TextFormField(
                            enabled: false,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(6),
                                        bottomRight: Radius.circular(6))),
                                hintText: '$name',
                                hintStyle: TextStyle(
                                    color: Color(0xFF242B42),
                                    fontWeight: FontWeight.w700),
                                fillColor: Colors.white,
                                filled: true),
                          ),
                          Positioned(
                             left: MediaQuery.of(context).size.width/2.5, top: 15, right:MediaQuery.of(context).size.width/150 ,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    name = 'no image selected';
                                  });
                                },
                                child: Icon(
                                 MdiIcons.closeCircleOutline,size: 30,
                                ),
                              ))
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(30.0),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Project Title"),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          contentPadding: new EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 7.0),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          hintText: 'Some headling...',
                          fillColor: Colors.white,
                          filled: true),
                      controller: title,
                      validator: (val) {
                        if (val.isEmpty) {
                          return 'Please enter some text';
                        } else {
                          return null;
                        }
                      },
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text("Description"),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'About project....',
                        fillColor: Colors.white,
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                      ),
                      controller: desc,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      minLines: 6,
                      validator: (val) {
                        if (val.isEmpty) {
                          return 'Please enter some description';
                        } else {
                          return null;
                        }
                      },
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      width: double.maxFinite,
                      height: 60,
                      child: FlatButton(
                        child: Text(
                          "Create Now",
                          style: TextStyle(color: Colors.white, fontSize: 25),
                        ),
                        color: Color(0xFF242B42),
                        onPressed: () {
                          if (_formKey.currentState.validate() &&
                              name != 'no video selected') {
                            db.saveProject(
                                Project(title.text, desc.text, image.path));
                            debugPrint(image.path);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProjectList()));
                          }
                        },
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(10.0)),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }
}
