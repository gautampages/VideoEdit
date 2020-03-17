import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http_request/Project_list.dart';
class Splashscreen extends StatefulWidget {
  @override
  _SplashscreenState createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
 

  @override
  void initState() {

    
    Timer(Duration(seconds: 2), ()
    {
      Navigator.push(context, MaterialPageRoute(builder: (context)=>ProjectList()));
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image(image: AssetImage('assets/home.jpg'),fit: BoxFit.cover,),
      
    );
  }
}