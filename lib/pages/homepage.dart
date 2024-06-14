

import 'package:chat_app/helper/helper_function.dart';
import 'package:chat_app/pages/auth/loginpage.dart';
import 'package:chat_app/pages/profile_page.dart';
import 'package:chat_app/pages/search_page.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../constant.dart';
import '../services/databaseservice.dart';
import '../widgets/group_tile.dart';
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String email='';
  String fullName='';
  AuthService authService=AuthService();
  Stream? groups;
  bool isLoading=false;
  String groupName='';
  @override
  void initState()
  {
    super.initState();
    gettingUserData();
  }


  //....String manipulation for getting group Id.....//

  String getGroupId(String res)
  {
    return res.substring(0,res.indexOf("_"));
  }

  //.....String manipulation for getting group name.....//
  String getGroupName(String res)
  {
    return res.substring(res.indexOf("_")+1);
  }
  gettingUserData()async{
    await HelperFunction.getUserFullNameFromSf().then((value){
      setState(() {
        fullName=value!;

      });
    });
    await HelperFunction.getUserEmailFromSf().then((value){
      setState(() {
        email=value!;
      });
    });
    await DatabaseService(uid:FirebaseAuth.instance.currentUser!.uid).getUserGroups().
    then((snapshot){
      setState(() {
        groups=snapshot;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        centerTitle: true,
        title:const Text("Groups",
        style: TextStyle(fontSize: 27,
        fontWeight: FontWeight.bold),),
        backgroundColor: Constants().primaryColor,
        actions: [
          IconButton(onPressed: (){
            nextScreen(context, const SearchPage());
          }, icon:const Icon(Icons.search))
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 50),
          children: [
            Icon(Icons.account_circle,
            size: 100,
            color: Colors.grey[700],),
            SizedBox(height: 15,),
            Text(fullName,
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold,
            fontSize: 30),),
            SizedBox(height: 15,),
            Divider(height: 2,),
            ListTile(
              onTap: (){},
              selectedColor: Constants().primaryColor,
              selected: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 20),
              leading: Icon(Icons.group),
              title: Text("Groups",
              style: TextStyle(color: Colors.black),),
            ),
            ListTile(
              onTap: (){
                nextScreenReplace(context, ProfilePage(fullName: fullName,email: email,));
                },
              contentPadding: EdgeInsets.symmetric(horizontal: 20),
              leading: Icon(Icons.person),
              title: Text("Profile",
                style: TextStyle(color: Colors.black),),
            ),
            ListTile(
              onTap: ()async{
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
      body:groupList(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          popUpDialog(context);
        },
        elevation: 0,
        backgroundColor: Constants().primaryColor,
        child: Icon(Icons.add,
        color: Colors.white,
        size: 30
      )
    ));
  }
  popUpDialog(BuildContext context)
  {
    showDialog(barrierDismissible:false,context: context, builder: (context)
    {
      return AlertDialog(
        title: Text("Create a group",
        textAlign: TextAlign.left,),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            isLoading?Center(child: CircularProgressIndicator(
              color: Constants().primaryColor,
            ),):TextField(
              onChanged: (value){
                groupName=value;
              },
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Constants().primaryColor,),
                    borderRadius: BorderRadius.circular(30)
                  ),
                errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.red),
                    borderRadius: BorderRadius.circular(30)
                ),
                focusedBorder: OutlineInputBorder( borderSide: BorderSide(
                  color: Constants().primaryColor,),
                    borderRadius: BorderRadius.circular(30))
              ),
            ),

          ],
        ),
        actions: [
          ElevatedButton(onPressed: (){
            Navigator.of(context).pop();
          }, child: Text("Cancel"),
          style: ElevatedButton.styleFrom(primary: Constants().primaryColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),),
          ElevatedButton(onPressed: ()async{
            if(groupName.isNotEmpty)
              {
                setState(() {
                  isLoading=true;
                  DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).
                  createGroup(fullName, FirebaseAuth.instance.currentUser!.uid, groupName);
                });
                Navigator.of(context).pop();
                showSnackBar(context, Colors.green, "Group has been created successfully");
              }


          }, child: Text("Create"),
            style: ElevatedButton.styleFrom(primary: Constants().primaryColor,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          ))
        ],
        
      );
    });
  }
  groupList()
  {
    return StreamBuilder(
        stream: groups,
        builder: (context,AsyncSnapshot snapshot)
    {
      if(snapshot.hasData)
        {
          if(snapshot.data['groups']!=null)
            {
              if(snapshot.data['groups'].length!=0)
                {
                  return ListView.builder(
                    itemCount: snapshot.data['groups'].length,
                      itemBuilder: (context,index)
                  {
                    int reverseIndex= snapshot.data['groups'].length-index-1;
                    return GroupTile(fullName: snapshot.data['fullName'],
                        groupId:getGroupId(snapshot.data['groups'][reverseIndex]) ,
                        groupName: getGroupName(snapshot.data['groups'][reverseIndex]));
                  });

                }
              else
                {
                  return noGroupWidget(context);
                }
            }
          else
            {
              return noGroupWidget(context);
            }
        }
      else
        {
          return Center(child: CircularProgressIndicator(
            color: Constants().primaryColor,
          ));
        }
    });

  }
  noGroupWidget(BuildContext context)
  {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: (){
                popUpDialog(context);
              },
              child: Icon(Icons.add_circle,
              size: 70,
              color: Colors.grey[700],),
            ),
            SizedBox(height: 20),
            Text("You've not joined any group, tap on the add icon to create a group or also search from"
                " top serach.",
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,)
          ],
        ),
      ),
    );
  }

}
