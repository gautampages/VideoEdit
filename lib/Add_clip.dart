import './Clip.dart';
import './DBHelper.dart';
import './Clip_cutting.dart';
import './Project.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

class AddClip extends StatefulWidget {
  Project value;
  String start;
  String end;
  int id;
  AddClip(this.id,this.value,this.start,this.end);
  @override
  AddClipState createState() => AddClipState(id,value,start,end);
}

class AddClipState extends State<AddClip> {
  DatabaseHelper db= new DatabaseHelper();
  Project project;
  int id;
  String startTime;
  String endTime;
  AddClipState(this.id,this.project,this.startTime,this.endTime);
  String color =  Colors.blue.toString().substring(35,Colors.blue.toString().length-2);
  ColorSwatch _tempMainColor;
  ColorSwatch _mainColor = Colors.blue;
  void _openDialog(String title, Widget content) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(6.0),
          title: Text(title),
          content: content,
          actions: [
            FlatButton(
              child: Text('CANCEL'),
              onPressed: Navigator.of(context).pop,
            ),
            FlatButton(
              child: Text('SUBMIT'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _mainColor = _tempMainColor;
                  color = _mainColor.toString().substring(35,Colors.blue.toString().length-2);                });
              },
            ),
          ],
        );
      },
    );
  }

  void _openMainColorPicker() async {
    _openDialog(
      "Main Color picker",
      MaterialColorPicker(
        selectedColor: _mainColor,
        allowShades: false,
        onMainColorChange: (color) => setState(() 
        {
           _tempMainColor = color;
           
        }),
      ),
    );
  }




  final _formKey = GlobalKey<FormState>();
  TextEditingController title = new TextEditingController();
  TextEditingController desc = new TextEditingController();

  


  @override
  Widget build(BuildContext context)
  {var deviceData=MediaQuery.of(context); 
  double x=deviceData.size.width;
  print(deviceData.size.width);
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
                    child: Text(project.title,
                        style: TextStyle(
                            fontSize: 25,
                            color: Color(0xFF242B42),
                            fontFamily: 'BreeSerif'))),
              ),
              Container(
                padding: EdgeInsets.all(30.0),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Add clip details",
                        style: TextStyle(
                            fontSize: 30,
                            color: Color(0xFF242B42),
                            fontFamily: 'BreeSerif')),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text("Clip Title"),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      autofocus: true,
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
                      minLines: 3,
                      validator: (val) {
                        if (val.isEmpty) {
                          return 'Please enter some description';
                        } else {
                          return null;
                        }
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text("Color"),
                    SizedBox(
                      height: 10,
                    ),
                    Stack(
                      children: <Widget>[
//                        TextFormField(
//                          enabled: false,
//                          decoration: InputDecoration(
//                              contentPadding: new EdgeInsets.symmetric(
//                                  vertical: 16.0, horizontal: 7.0),
//                              enabledBorder: OutlineInputBorder(
//                                  borderSide: BorderSide(color: Colors.white)),
//                              //hintText: '$color',
//                              fillColor: color,
//                              filled: true),
//                        ),
                          //padding: EdgeInsets.all(MediaQuery.of(context).size.width/10),
                          SizedBox(
                            height: 50,
                            width: deviceData.size.width,
                            child: RaisedButton(
                              onPressed: _openMainColorPicker,
                              color: _mainColor,
                              shape: RoundedRectangleBorder(side: BorderSide(color: Colors.white,width: 2.0)),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      width: double.maxFinite,
                      height: 50,
                      child: FlatButton(
                        child: Text(
                          "Submit",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        color: Color(0xFF242B42),
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            debugPrint(_mainColor.toString());
                            db.saveClip(Clip(id,title.text, desc.text, project.path, color.toString(), startTime, endTime));
                            Navigator.of(context).pop();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Clipcutting(project,id)));
                            debugPrint("Result:: "+project.path);

                          }
                        },
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(5.0)),
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
