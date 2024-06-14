import 'package:chat_app/helper/helper_function.dart';
import 'package:chat_app/pages/auth/loginpage.dart';
import 'package:chat_app/pages/homepage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constant.dart';
void main()async
{
  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb)
    {
      await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey:Constants.apiKey ,
            authDomain: Constants.authDomain,
            projectId: Constants.projectId,
            storageBucket: Constants.projectId,
            messagingSenderId: Constants.messagingSenderId,
            appId: Constants.appId
        ));
    }
  else
    {
      await Firebase.initializeApp();
    }


  runApp(const MyApp());
}
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isSignedIn=false;
  @override
  void initState()
  {
    super.initState();
    getUserLoggedInStatus();
  }
  getUserLoggedInStatus()async
  {
    await HelperFunction.getUserLoggedInStatus().then((value) => {
      (value),
      if(value!=null)
        {
          setState((){
      isSignedIn=value;
    })

        }
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Constants().primaryColor,
      scaffoldBackgroundColor: Colors.white),
      debugShowCheckedModeBanner: false,
      home:isSignedIn? HomePage():LoginPage(),
    );
  }
}
