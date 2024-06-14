import 'package:flutter/material.dart';

import '../constant.dart';
var textInputDecoration=InputDecoration(
  labelStyle: TextStyle(color: Colors.black),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Constants().primaryColor,
    width: 2)
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Constants().primaryColor,
    width: 2)),
  errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Constants().primaryColor
  ,
  width: 2))
);

void nextScreen(context,page)
{
  Navigator.push(context, MaterialPageRoute(builder: (context)=>page));
}
void nextScreenReplace(context,page)
{
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>page));
}

void showSnackBar(context,color,message)
{
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message,
    style: TextStyle(fontSize: 14),),
  backgroundColor: color,
    duration: Duration(seconds: 4),
    action: SnackBarAction(
      label: "Ok",
    onPressed: (){},
    textColor: Colors.white,),
  ));
}





