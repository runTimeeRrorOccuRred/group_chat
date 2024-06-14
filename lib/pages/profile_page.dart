import 'package:chat_app/constant.dart';
import 'package:chat_app/pages/homepage.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:flutter/material.dart';

import '../widgets/widgets.dart';
import 'auth/loginpage.dart';
class ProfilePage extends StatefulWidget {
  String fullName;
  String email;
   ProfilePage({required this.fullName,required this.email,Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  AuthService authService=AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title:const Text("Profile",
      style: TextStyle(color: Colors.white,
      fontSize: 27,fontWeight: FontWeight.bold),),
      backgroundColor: Constants().primaryColor,),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 50),
          children: [
            Icon(Icons.account_circle,
              size: 100,
              color: Colors.grey[700],),
            SizedBox(height: 15,),
            Text(widget.fullName,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold,
                  fontSize: 30),),
            SizedBox(height: 15,),
            Divider(height: 2,),
            ListTile(
              onTap: (){
                nextScreen(context, HomePage());
              },

              contentPadding: EdgeInsets.symmetric(horizontal: 20),
              leading: Icon(Icons.group),
              title: Text("Groups",
                style: TextStyle(color: Colors.black),),
            ),
            ListTile(
              onTap: (){
               // nextScreen(context, ProfilePage());
              },
              selectedColor: Constants().primaryColor,
              selected: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 20),
              leading: Icon(Icons.person),
              title: Text("Profile",
                style: TextStyle(color: Colors.black),),
            ),
            ListTile(
              onTap: ()async
              {
                showDialog(
                    barrierDismissible:false,
                    context: context,
                    builder: (context){
                      return AlertDialog(
                        content: Text("Are you sure you want to Log Out?"),
                        actions: [
                          IconButton(onPressed: (){
                            Navigator.pop(context);
                          }, icon: Icon(Icons.cancel,
                            color: Colors.red,)),
                          IconButton(onPressed: ()async{
                            await authService.signOut();
                            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder:
                                (context)=>const LoginPage()),
                                    (route) => false);
                          }, icon: Icon(Icons.exit_to_app,
                            color: Colors.green,))
                        ],
                      );
                    });
                //  nextScreen(context, ProfilePage());



                // authService.signOut().whenComplete(() {
                //   nextScreenReplace(context, LoginPage());
                // });
              },
              contentPadding: EdgeInsets.symmetric(horizontal: 20),
              leading: Icon(Icons.exit_to_app),
              title: Text("Log Out",
                style: TextStyle(color: Colors.black),),
            )
          ],
        ),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 170),
          child: Column(
            children: [
              Icon(Icons.account_circle,
              size: 200,
              color: Colors.grey[200],),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Full Name",
                  style: TextStyle(fontSize: 20),),
                  Text(widget.fullName,style: TextStyle(fontSize: 20),)
                ],
              ),
              Divider(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Email",
                    style: TextStyle(fontSize: 20),),
                  Text(widget.email,style: TextStyle(fontSize: 20),)


                ],
              )

            ],
          ),
        ),
      ),
    );

  }
}
