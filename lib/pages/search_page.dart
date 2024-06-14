import 'package:chat_app/helper/helper_function.dart';
import 'package:chat_app/pages/chat_page.dart';
import 'package:chat_app/services/databaseservice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../constant.dart';
import '../widgets/widgets.dart';
class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}
class _SearchPageState extends State<SearchPage> {
  bool isLoading= false;
  QuerySnapshot? searchSnapshot;
  bool hasUserSearched=false;
  String fullName='';
  TextEditingController searchController=TextEditingController();
  User? user;
  bool isJoined=false;
  @override
  void initState()
  {
    super.initState();
    getCurrentUserIdAndName();
  }

  getCurrentUserIdAndName()async
  {
   await HelperFunction.getUserFullNameFromSf().then((value)  {
     setState(() {
       if(value!=null) {
         fullName = value;
       }
     });
     user=FirebaseAuth.instance.currentUser;
   });
  }
  getAdminName(String res)
  {
    return res.substring(res.indexOf("_")+1);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        backgroundColor: Constants().primaryColor,
        title:const Text("Search",
        style: TextStyle(
          fontSize: 27,
          fontWeight: FontWeight.bold,
          color: Colors.white
        ),),),
      body: Column(
        children: [
          Container(
            color: Constants().primaryColor.withOpacity(0.8),
            padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
            child: Row(
              children: [
                Expanded(child: TextField(
                  controller: searchController,
                  style: TextStyle(color: Colors.white),
                  decoration:InputDecoration(
                    border: InputBorder.none,
                    hintText: "Search Group.....",
                    hintStyle: TextStyle(color: Colors.white)
                  ),
                )),
                GestureDetector(
                  onTap: (){
                    initiateSearchMethod();
                  },
                  child: Container(
                    width: 40,
                      height: 40,
                    decoration: BoxDecoration(
                      color: Constants().primaryColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Icon(Icons.search,
                    color: Colors.white,),
                  ),
                )
              ],
            ),

          ),

          isLoading?Center(child: CircularProgressIndicator(
            color: Constants().primaryColor,
          )):groupList(),
        ],
      ),
    );
  }
  initiateSearchMethod()async
  {
    if(searchController.text.isNotEmpty)
      {
        setState(() {
          isLoading=true;
        });
        await DatabaseService().searchByName(searchController.text).then((snapshots){
          setState(() {
            searchSnapshot=snapshots;
            isLoading=false;
            hasUserSearched=true;
          });
        });
      }
  }
  groupList()
  {
      return hasUserSearched?SingleChildScrollView(
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: searchSnapshot!.docs.length,
            itemBuilder: (context,index)
        {
          return groupTile(fullName,searchSnapshot!.docs[index]['groupId'],
              searchSnapshot!.docs[index]['groupName'],
              searchSnapshot!.docs[index]['admin']);
        }),
      ):Container();
  }

  joinedOrNot(String fullName,String groupId,String groupName,String admin)async
  {
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).
    isUserJoined(groupName, groupId, fullName).then((value) {

     setState(() {
       isJoined=value;
     });
    });
  }
  Widget groupTile(String fullName,String groupId,String groupName,String admin)
  {
    joinedOrNot(fullName,groupId,groupName,admin);
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
      leading: CircleAvatar(
        radius: 30,
        backgroundColor: Constants().primaryColor,
        child: Text(groupName.substring(0,1).toUpperCase(),
        style: TextStyle(fontSize: 25,
        fontWeight: FontWeight.w500),),
      ),
      title: Text(groupName,style: TextStyle(fontWeight: FontWeight.w600),),
      subtitle: Text("Admin:  ${getAdminName(admin)}"),
      trailing: InkWell(
        onTap: ()async{
        DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).
        toggleGroupJoin(groupId, fullName, groupName);
        if(isJoined)
          {
            setState(() {
              isJoined=!isJoined;
            });
            showSnackBar(context,Colors.red,"Left the group ${groupName}");
            Future.delayed(Duration(seconds: 3),(){

            });
          }
        else
          {
            setState(() {
              isJoined=!isJoined;
              showSnackBar(context, Colors.green, "Successfully joined the chat");
              nextScreen(context, ChatPage(groupId: groupId,
                  groupName: groupName, fullName: fullName));
            });
          }

        },
        child: isJoined?Container(
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(width: 1,color: Colors.white)
          ),
          padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
          child: Text("Joined",style: TextStyle(color: Colors.white,
          fontSize: 16),),
        ):Container(
          decoration: BoxDecoration(
              color: Constants().primaryColor,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(width: 1,color: Colors.white)
          ),
          padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
          child: Text("Join",
          style: TextStyle(fontSize: 17,color: Colors.white),),
        )
      ),
    );
  }
}




