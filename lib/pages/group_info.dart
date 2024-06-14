import 'package:chat_app/constant.dart';
import 'package:chat_app/helper/helper_function.dart';
import 'package:chat_app/pages/homepage.dart';
import 'package:chat_app/services/databaseservice.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class GroupInfo extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String adminName;
  const GroupInfo({ required this.groupId, required this.groupName, required this.adminName,Key? key}) : super(key: key);

  @override
  State<GroupInfo> createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfo> {
Stream? members;
String fullName='';
  @override
  void initState()
  {
    super.initState();
    getMembers();
    getFullName();
  }
  getFullName()async
  {
    HelperFunction.getUserFullNameFromSf().then((value) {
      fullName=value!;
      print(fullName);
    });
  }
  getMembers()async
  {
    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).
    getGroupMembers(widget.groupId).then((value){
     setState(() {
       members=value;
     });
    });
  }
  getAdminName(String res)
  {
    return res.substring(res.indexOf("_")+1);
  }

  getAdminId(String res)
  {
    return res.substring(0,res.indexOf("_"));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Constants().primaryColor,
        title: Text('Group Info'),
        actions: [
          IconButton(onPressed: (){
            {
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("Exit"),
                      content: Text("Are you sure you want to exit the group?"),
                      actions: [
                        IconButton(onPressed: () {
                          Navigator.pop(context);
                        }, icon: Icon(Icons.cancel,
                          color: Colors.red,)),
                        IconButton(onPressed: () async {
                          DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).
                          toggleGroupJoin(widget.groupId,fullName,
                              widget.groupName ).whenComplete((){
                                showSnackBar(context, Colors.red, "$fullName has left the group ${widget.groupName}");
                               nextScreenReplace(context, HomePage()) ;
                          });

                        }, icon: Icon(Icons.exit_to_app,
                          color: Colors.green,))
                      ],
                    );
                  });
              //  nextScreen(context, ProfilePage());


              // authService.signOut().whenComplete(() {
              //   nextScreenReplace(context, LoginPage());
              // });
            }

          }, icon: Icon(Icons.exit_to_app))
        ],
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Constants().primaryColor.withOpacity(0.2),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        child: Text(widget.groupName.substring(0,1).toUpperCase(),
                        style: TextStyle(fontSize: 25,
                        fontWeight: FontWeight.w500),),
                        radius: 30,
                        backgroundColor: Constants().primaryColor,
                      ),
                      SizedBox(width: 20,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Group:  ${widget.groupName}',
                            style: TextStyle(fontWeight: FontWeight.bold),),
                          SizedBox(height: 10,),
                          Text("Admin:  ${getAdminName(widget.adminName)}",
                          style: TextStyle(fontWeight: FontWeight.bold),)
                        ],
                      )
                    ],
                  ),
                ),),
              memberList()
            ],
          ),
        ),
      ),
    );
  }
  memberList()
  {
    return StreamBuilder(
        stream: members,
        builder: (context,AsyncSnapshot snapshot)
        {
          if(snapshot.hasData)
            {
              if(snapshot.data['members']!=null)
                {
                 if(snapshot.data['members']!=0)
                   {
                     return ListView.builder(
                         itemCount: snapshot.data['members'].length,
                         shrinkWrap: true,
                         itemBuilder: (context,index)
                         {
                       return Container(
                         padding: EdgeInsets.symmetric(horizontal: 5,vertical: 10),
                         child: ListTile(
                           leading: CircleAvatar(
                             radius: 30,
                             backgroundColor: Constants().primaryColor,
                             child: Text(getAdminName(snapshot.data['members'][index]).toString().substring(0,1).toUpperCase(),
                             style: TextStyle(fontWeight: FontWeight.w400,
                             fontSize: 25),),
                           ),
                           title: Text(getAdminName(snapshot.data['members'][index]).toString()),
                           subtitle: Text(getAdminId(snapshot.data['members'][index]))
                           
                         ),
                       );
                     });
                   }
                 else{
                   return Container();
                 }
                }
              else
                {
                  return Container();
                }
            }
          else
            {
              return CircularProgressIndicator(
                color: Constants().primaryColor,
              );
            }
        });
  }
}
