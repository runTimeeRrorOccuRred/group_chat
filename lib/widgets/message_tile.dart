import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../constant.dart';
import '../constant.dart';
import '../constant.dart';
class MessageTile extends StatefulWidget {
  final String message;
  final String sender;
  final bool sendByMe;
  final Timestamp timestamp;


   const MessageTile({Key? key,
    required this.message,
    required this.sender,
    required this.sendByMe,
    required this.timestamp}) : super(key: key);
   @override
  State<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  DateTime? dateTime;
  @override
  Widget build(BuildContext context) {
    dateTime=widget.timestamp.toDate();

    //   Container(
    //   padding: EdgeInsets.only(top: 4,bottom: 4,left: widget.sendByMe?0:24,
    //   right: widget.sendByMe?24:0),
    //   alignment: widget.sendByMe?Alignment.centerRight:Alignment.centerLeft,
    //   child: Container(
    //     padding:const EdgeInsets.only(top: 3,bottom: 10,left: 20,right: 20),
    //     margin: widget.sendByMe?const EdgeInsets.only(left: 20):const EdgeInsets.only(right: 30),
    //     decoration: BoxDecoration(
    //       boxShadow: const
    //       [
    //         BoxShadow(
    //           color: Colors.blueGrey,
    //           //offset: Offset(0.0, 1.0), //(x,y)
    //           blurRadius: 3.0,
    //       )],
    //       borderRadius:widget.sendByMe?
    //       const BorderRadius.only(topLeft: Radius.circular(20),
    //       topRight:Radius.circular(20),
    //       bottomLeft: Radius.circular(20)):
    //
    //       const BorderRadius.only(topLeft: Radius.circular(20),
    //       topRight:Radius.circular(20),
    //       bottomRight: Radius.circular(20)),
    //       color: widget.sendByMe?Colors.indigo.withOpacity(0.6):Colors.cyan.withOpacity(0.8)
    //     ),
    //     child:
    //     Column(
    //       crossAxisAlignment: CrossAxisAlignment.end,
    //       children: [
    //         widget.sendByMe?SizedBox():Text(widget.sender,
    //         textAlign: TextAlign.center,
    //         style: TextStyle(
    //           color:widget.sendByMe? Colors.white:Colors.deepPurple,
    //           letterSpacing: 0.8,
    //           fontSize: 17,
    //           fontWeight: FontWeight.bold
    //         ),),
    //        const SizedBox(height: 8,),
    //         Text(widget.message,
    //         //textAlign: TextAlign.center,
    //         style: TextStyle(fontSize: 21,
    //         color: widget.sendByMe?Colors.white:Colors.white),),
    //         SizedBox(height: 5,),
    //         Text(dateTime!.hour.toString() +":"+dateTime!.minute.toString(),
    //         textAlign: TextAlign.right,
    //         style: TextStyle(color:widget.sendByMe? Colors.white.withOpacity(0.8):Colors.white),)
    //       ],
    //     ),
    //   ),
    // );


    return  Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8,right: 5,left: 5),
      child: Column(
        crossAxisAlignment: widget.sendByMe
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 300,
            child: Card(
              elevation: 5,
              color:widget.sendByMe? Colors.indigo.withOpacity(0.8):Colors.cyan.withOpacity(0.7),
              shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: Colors.grey,
                  ),
                  borderRadius: widget.sendByMe?
                  BorderRadius.only(
                      topRight: Radius.circular(40),
                      topLeft: Radius.circular(40),
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(0)):BorderRadius.only(
                      topRight: Radius.circular(40),
                      topLeft: Radius.circular(40),
                      bottomLeft: Radius.circular(0),
                      bottomRight: Radius.circular(40)
                  )
              ),
              child: ListTile(
               // tileColor: widget.sendByMe?Colors.indigoAccent:Colors.cyan.withOpacity(0.7),
//tileColor: Colors.white,
                title: Text(
                  widget.sender,
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.6),
                    fontSize: 17,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 200,
                        child: Text(
                         widget.message,
                          softWrap: true,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Text(
                        dateTime!.hour.toString() + ":" + dateTime!.minute.toString(),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


}
