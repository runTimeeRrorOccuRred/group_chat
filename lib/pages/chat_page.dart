import 'package:chat_app/constant.dart';
import 'package:chat_app/pages/group_info.dart';
import 'package:chat_app/services/databaseservice.dart';
import 'package:chat_app/widgets/message_tile.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class ChatPage extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String fullName;
  const ChatPage({required this.groupId,required this.groupName,required this.fullName,Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin{
  String admin='';
  TextEditingController messageController=TextEditingController();
  Stream<DocumentSnapshot>? chat;
  String adminId="";
  AnimationController? animationController;
  Animation? sizeAnimation;
  bool clicked=false;
  @override
  void initState()
  {
    super.initState();
    // animationController=AnimationController(
    //     duration: Duration(milliseconds: 300),
    //
    //     vsync: this);
    //
    // sizeAnimation=TweenSequence(
    // <TweenSequenceItem>[
    // TweenSequenceItem(tween: Tween(begin:50,end: 60),
    // weight: 50),
    // TweenSequenceItem(tween: Tween(begin: 60,end: 50), weight: 50)
    // ]
    // ).animate(animationController as Animation<double>);
    // animationController?.addStatusListener((status) {
    //   if(status==AnimationStatus.completed)
    //   {
    //     setState(() {
    //       clicked=true;
    //       print(status);
    //     });
    //   }
    //   if(status==AnimationStatus.dismissed)
    //   {
    //     setState(() {
    //       clicked=false;
    //       print(status);
    //     });
    //   }
    // });


    //getChatAdmin();

    showChatMessage();
  }

  showChatMessage()
  {
    DatabaseService().showMessage(widget.groupId).then((value){
      setState(() {
        chat=value;
      });
    });
  }

  getChatAdmin()
  {
    DatabaseService().gettingChats(widget.groupId).then((value)
    {
      setState(() {
        chat=value;
      });
    });
    DatabaseService().getGroupAdmin(widget.groupId).then((value){
      setState(() {
        admin=value;
      });
    });
  }

  showAdmin(String res)async
  {
    return res.substring(0,res.indexOf("_"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 5,
        title: Text(widget.groupName),
        backgroundColor: Constants().primaryColor,
        actions: [
          GestureDetector(
              onTap: (){
                popUpDialog(context);
              },
              child: Icon((Icons.delete))),
       SizedBox(width: 10,),
       Padding(
         padding: const EdgeInsets.only(right: 10),
         child: GestureDetector(
             onTap: (){
                 nextScreen(context, GroupInfo(
                 groupId: widget.groupId,
                 groupName: widget.groupName,
                 adminName: admin));},
             child: Icon(Icons.info)),
       )
        ],
      ),
      body: Stack(
        children: [
         // chatMessages(),
          chatMessagesData(),
          Container(
            alignment: Alignment.bottomCenter,
            width: MediaQuery.of(context).size.width,
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
              color: Colors.indigo.withOpacity(0.6),
              child:
              Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintStyle: TextStyle(color: Colors.white,fontSize: 16),
                        hintText: "Send a message...",
                        border: InputBorder.none,
                      ),
                    controller: messageController,
                    style: TextStyle(color: Colors.white,
                    fontSize: 20),
                    ),
                  ),
                  SizedBox(width: 12,),
                  GestureDetector(
                    onTap: (){
                      //sendMessage();
                   // clicked?animationController!.reverse():animationController!.forward();
                      creatingMessage();
                    },
                    child: Container(
                      height:50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Constants().primaryColor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Icon(Icons.send,
                        color: Colors.white,),
                    ),
                  ),

                ],
              ),
            ),
          )
        ],
      ),
    );
  }
  sendMessage()
  {
    if(messageController.text.isNotEmpty)
      {
        Map<String,dynamic>chatMessage={
          "message":messageController.text,
          "sender":widget.fullName,
          "time":DateTime.now()
        };
        DatabaseService().sendMessage(widget.groupId, chatMessage);
        setState(() {
          messageController.clear();
        });
      }
  }
  // chatMessages()
  // {
  //   return StreamBuilder(
  //       stream: chat,
  //       builder: (context,AsyncSnapshot snapshot){
  //         if(snapshot.hasData)
  //           {
  //              return ListView.builder(
  //                 itemCount: snapshot.data.docs.length,
  //                 itemBuilder: (context,index){
  //                   return MessageTile(message: snapshot.data.docs[index]['message'],
  //                       sender: snapshot.data.docs[index]['sender'],
  //                       sendByMe: widget.fullName==snapshot.data.docs[index]['sender'],
  //                   timestamp: snapshot.data.docs[index]['time'],);
  //                 });
  //           }
  //         else
  //           {
  //             return Container();
  //           }
  //       });
  // }
  chatMessagesData()
  {
    return Container(
      color: Colors.indigoAccent.withOpacity(0.2),
      padding:const EdgeInsets.only(bottom: 70),
      child: StreamBuilder(
          stream: chat,
          builder: (context,AsyncSnapshot snapshot){
            if(snapshot.hasData)
            {
              return ListView.builder(
                  itemCount: snapshot.data['chatMessage'].length,
                  itemBuilder: (context,index){
                    return MessageTile(message: snapshot.data['chatMessage'][index]['message'],
                        sender: snapshot.data['chatMessage'][index]['sender'],
                        sendByMe: widget.fullName==snapshot.data['chatMessage'][index]['sender'],
                    timestamp: snapshot.data['chatMessage'][index]['time']);
                  });
            }
            else
            {
              return Container();
            }
          }),
    );
  }

  creatingMessage()
  {
    // if(messageController.text.isNotEmpty)
    // {
    //   DatabaseService().createMessage(widget.groupId, messageController.text,widget.fullName,
    //       DateTime.now().millisecondsSinceEpoch.toString());
    //   setState(() {
    //     messageController.clear();
    //   });
    // }
    if(messageController.text.isNotEmpty)
    {
      Map<String,dynamic>chatMessage={
        "message":messageController.text,
        "sender":widget.fullName,
        "time":DateTime.now()
      };
      DatabaseService().createMessage(widget.groupId, chatMessage);
      setState(() {
        messageController.clear();
      });
    }
  }

  popUpDialog(BuildContext context)
  {
    showDialog(barrierDismissible:false,context: context, builder: (context)
    {
      return AlertDialog(
        title: const Text("Do you want to delete the entire chat?",
          textAlign: TextAlign.left,),
        actions: [
          ElevatedButton(onPressed: ()
          {
            Navigator.of(context).pop();
          }, child: Text("Cancel"),
            style: ElevatedButton.styleFrom(primary: Constants().primaryColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),),
          ElevatedButton(
              onPressed: ()async
         {
         DatabaseService().deleteChat(widget.groupId).then((value){
         setState(() {
         adminId=value;
         });
         showAdmin(adminId).then((value){
         if(FirebaseAuth.instance.currentUser!.uid==value)
         {

             DatabaseService().deleteChatData(widget.groupId).then((value){
             showSnackBar(context, Colors.green, "Chat has been deleted successfully");
             Navigator.of(context).pop();
         });
         }
         else
         {

             showSnackBar(context, Colors.red, "Only admin can delete chat");
         }
         });
         });
         },
              child: Text("Delete"),
              style: ElevatedButton.styleFrom(primary: Constants().primaryColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ))
        ],

      );
    });
  }



}
