import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService
{
  final String? uid;
  DatabaseService({ this.uid});

  //.....Reference of our collection.....//

  final CollectionReference userCollection=
  FirebaseFirestore.instance.collection('users');

  final CollectionReference groupCollection=
  FirebaseFirestore.instance.collection('groups');

  CollectionReference? collectionReference;




  //.... For saving user data in the database......//

  Future updateUserData(String fullName, String email)async
  {
    return await userCollection.doc(uid).set({
    "fullName":fullName,
    "email":email,
    "groups":[],
    "profilePic":"",
    "userId":uid
    });
  }

  //.....Getting user data.....//

Future gettingUserData(String email) async{
    QuerySnapshot snapshot= await userCollection.where('email',isEqualTo: email).get();
    return snapshot;

}

//.....get user groups.....//

getUserGroups()async
{
  return userCollection.doc(uid).snapshots();

}


//..... Creating a group.....//

Future createGroup( String fullName, String id,String groupName)async
{

  DocumentReference groupDocumentReference= await groupCollection.add(
    {
      "groupName":groupName,
      "groupIcon":"",
      "admin":"${id}_$fullName",
      "members":[],
      "groupId":"",
      'chatMessage':[],
      "recentMessage":'',
      "recentMessageSender":""
    });
   // collectionReference= groupCollection.doc(groupDocumentReference.id).collection('messages');
   // collectionReference!.doc('chat').set({'message':[]});


  //....Update the member.....//
  await groupDocumentReference.update({
    "members":FieldValue.arrayUnion(["${uid}_$fullName"]),
    "groupId":groupDocumentReference.id
  });
  DocumentReference userReference=  userCollection.doc(uid);
  return await userReference.update({
    "groups": FieldValue.arrayUnion(["${groupDocumentReference.id}_$groupName"])
  });
}

gettingChats(String groupId)async{
    return groupCollection.
    doc(groupId).
    collection('messages').
    orderBy('time').snapshots();
}

Future getGroupAdmin(String groupId)async{
    DocumentReference documentReference=groupCollection.doc(groupId);
    DocumentSnapshot documentSnapshot= await documentReference.get();

    return documentSnapshot['admin'];
}

//.....for getting members.....//

getGroupMembers(String groupId)async
{
  return groupCollection.doc(groupId).snapshots();
}

//.....Search.....//

searchByName(String groupName)async
{
  return await groupCollection.where('groupName',isEqualTo:groupName).get();
}

//....For joining group.....//

Future<bool> isUserJoined(String groupName,String groupId,String fullName)async
{
    DocumentReference documentReference=userCollection.doc(uid);
    DocumentSnapshot documentSnapshot=await documentReference.get();
   List<dynamic>group= await documentSnapshot['groups'];
   if(group.contains("${groupId}_$groupName"))
     {
       return true;
     }
   else{
     return false;
   }
}

//.....toggling the group join and exit.....//

Future toggleGroupJoin(String groupId,String fullName,String groupName)async
{
  DocumentReference userDocumentReference=userCollection.doc(uid);
  DocumentReference groupDocumentReference=groupCollection.doc(groupId);

  DocumentSnapshot userDocumentSnapshot=await userDocumentReference.get();
  List<dynamic>groups= await userDocumentSnapshot['groups'];
  DocumentSnapshot groupDocumentSnapshot=await groupDocumentReference.get();


  //....if user has our group then remove them or also
  
  if(groups.contains("${groupId}_$groupName"))
    {
      await userDocumentReference.update({
        "groups":FieldValue.arrayRemove(["${groupId}_$groupName"]),
      });

      await groupDocumentReference.update({
        "members":FieldValue.arrayRemove(["${uid}_$fullName"]),
      });
    }
  else
    {
      await userDocumentReference.update({
        "groups":FieldValue.arrayUnion(["${groupId}_$groupName"]),
      });

      await groupDocumentReference.update({
        "members":FieldValue.arrayUnion(["${uid}_$fullName"]),
      });

    }
}

//.... send message....//

sendMessage(String groupId,Map<String,dynamic>chatMessageData)async
{
  groupCollection.doc(groupId).collection('messages').add(chatMessageData);
  groupCollection.doc(groupId).update({
    'recentMessage':chatMessageData['message'],
    'recentMessageSender':chatMessageData['sender'],
    'recentMessageTime':chatMessageData['time'].toString()
  });
}


createMessage(String groupId,Map<String,dynamic> messageData)async
{


  // await collectionReference!.add({"data":"jhfh"});
    // DocumentReference documentReference= collectionReference!.doc('chat');
    //
    // await documentReference.update({
    //   'message':FieldValue.arrayUnion([messageData]),
    //   'time':time,
    //   'sender':sender
    // });

  groupCollection.doc(groupId).update({

    'chatMessage':FieldValue.arrayUnion([messageData]),

    'recentMessage':messageData['message'],
    'recentMessageSender':messageData['sender']
  });
}

showMessage(String groupId)async
{
  return groupCollection.doc(groupId).snapshots();
}

//.....delete chat.....//

deleteChat(String groupId)async{
      DocumentReference documentReference= groupCollection.doc(groupId);
      DocumentSnapshot documentSnapshot=await documentReference.get();

      return documentSnapshot['admin'];
}

deleteChatData(String groupId)async{
    DocumentReference documentReference=groupCollection.doc(groupId);
    documentReference.update({
      'chatMessage':[]
    });

}
}
