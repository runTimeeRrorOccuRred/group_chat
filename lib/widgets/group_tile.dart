import 'package:chat_app/constant.dart';
import 'package:chat_app/pages/chat_page.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
class GroupTile extends StatefulWidget {
  final String fullName;
  final String groupId;
  final String groupName;
  const GroupTile({required this.fullName,required this.groupId,required this.groupName,Key? key}) : super(key: key);

  @override
  State<GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        nextScreen(context, ChatPage(
            groupId: widget.groupId,
            groupName: widget.groupName,
            fullName: widget.fullName));
      },
      child: Padding(
        padding:  EdgeInsets.symmetric(vertical: 10,horizontal: 5),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: Constants().primaryColor,
            child: Text(widget.groupName.substring(0,1).toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.w500
            ),),
          ),
          title: Text(widget.groupName,
          style: TextStyle(fontWeight: FontWeight.bold),),
          subtitle: Text("Join the conversation as ${widget.fullName}",
          style: TextStyle(fontSize: 15),),
        ),
      ),
    );
  }
}
