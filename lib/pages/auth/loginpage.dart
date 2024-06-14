import 'package:chat_app/constant.dart';
import 'package:chat_app/pages/registerpage.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/databaseservice.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../helper/helper_function.dart';
import '../homepage.dart';
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? email;
  String? password;
  bool isLoading=false;
  final formKey=GlobalKey<FormState>();
  AuthService authService=AuthService();
  bool showPassword=false;
  @override
  // void initState()
  // {
  //   super.initState();
  //   controller=AnimationController(
  //       duration:const Duration(milliseconds: 500),
  //       vsync: this);
  //
  //   sizeAnimation=TweenSequence(
  //       <TweenSequenceItem>[
  //         TweenSequenceItem(tween: Tween(begin:1200,end: 100),
  //             weight: 50),
  //
  //
  //       ]
  //   ).animate(controller as Animation<double>);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading?Center(child: CircularProgressIndicator(
        color: Constants().primaryColor,
      )):
      SingleChildScrollView(
        child: Form(
          key: formKey,
          child:
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
            Column(
              children: [
                const SizedBox(height: 60,),

                const Text("Groupie",style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold),),

                const SizedBox(height: 10,),

                const Text("Login to see what they are talking",
                  style: TextStyle(fontSize: 15,fontWeight: FontWeight.w400),),

                const SizedBox(height: 10,),

                Image.asset("assets/loginpicture.png"),

              ],
            ),
              TweenAnimationBuilder(
                  tween: Tween(begin: 0.1,end: 1.0),
                  duration: Duration(milliseconds: 1900),
                  curve:Curves.fastOutSlowIn,
                  builder: (_,val,child){
                return Column(
                  children: [
                    SizedBox(
                      width:val*MediaQuery.of(context).size.width,
                      child: TextFormField(
                          decoration: textInputDecoration.copyWith(
                            labelText: "Email",
                            prefixIcon: Icon(Icons.email,
                              color: Constants().primaryColor,
                            ),),
                          onChanged: (val)
                          {
                            setState(() {
                              email=val;
                              (email);
                            });

                          },
                          validator: (val)
                          {
                            if(val==null)
                            {
                              return "Please Enter your Email";
                            }
                            else{
                              return (RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(val!)?null:"Please Enter valid email");
                            }
                          }
                      ),
                    ),
                  ],
                );
              }),

              const SizedBox(height: 15,),
              TweenAnimationBuilder(tween: Tween(begin: 0.1,end: 1.0),
                  duration:const Duration(milliseconds: 2100),
                  curve:Curves.fastOutSlowIn,
                  builder: (_,val,child){
                return Column(
                  children: [
                    SizedBox(
                      width:val*MediaQuery.of(context).size.width,
                      child: TextFormField(
                        obscureText: showPassword?false:true,
                        decoration: textInputDecoration.copyWith(
                          suffixIcon: GestureDetector(
                              onTap:(){
                                setState(() {
                                  showPassword=!showPassword;
                                });
                              },
                              child:showPassword?Icon(Icons.visibility,
                              color:Constants().primaryColor,):Icon(Icons.visibility_off,
                              color: Constants().primaryColor,)),
                          labelText: "Password",

                          prefixIcon: Icon(Icons.lock,
                            color: Constants().primaryColor,),
                        ),
                        onChanged: (val)
                        {
                          setState(() {
                            password=val;
                            (password);
                          });
                        },
                        validator: (value)
                        {
                          if(value==null)
                          {
                            return "Please enter password";
                          }
                          else if(value.length<6)
                          {
                            return "Password can not be less than 6";
                          }
                          else
                          {
                            return null;
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 15,),
                    TweenAnimationBuilder(
                      tween: Tween(begin: 0.1,end: 1.0),
                      duration: Duration(milliseconds: 2300),
                      curve:Curves.fastOutSlowIn,
                      builder: (_,val,child){
                        return SizedBox(
                          width: val*MediaQuery.of(context).size.width,
                          child:  ElevatedButton(
                              style: ElevatedButton.styleFrom(

                                  primary: Constants().primaryColor,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))
                              ),
                              onPressed: ()async {
                                if (formKey.currentState!.validate())
                                {
                                  setState(() {});
                                  isLoading=true;
                                  await authService.loginWithUserNameAndPassword(email!, password!).
                                  then((value) async {
                                    if (value == true) {
                                      QuerySnapshot snapshot = await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).
                                      gettingUserData(email!);

                                      // print(snapshot.docs[0]['fullName']);


                                      //.....Saving to sharedpreferences.....//


                                      await HelperFunction().saveUserLoggedInStatus(value);
                                      await HelperFunction().saveUserNameSf(snapshot.docs[0]['fullName']);
                                      await HelperFunction().saveUserEmailSf(email!);
                                     // print(email);
                                      nextScreen(context, HomePage());


                                    }
                                    else {
                                      showSnackBar(context, Colors.red, value);
                                      setState(() {
                                        isLoading = false;
                                      });
                                    }
                                  });
                                }
                              }, child: const Text("Sign In",
                            style: TextStyle(fontSize: 16),)),
                        );
                      },


                    ),
                  ],
                );
              }),

               const SizedBox(height: 15,),

              const SizedBox(height: 10,),
              Column(
                children: [
                  Text.rich(
                    TextSpan(
                    text: "Dont Have an account?",
                    style: TextStyle(color: Colors.black, fontSize: 16),
                    children: [
                      const TextSpan(
                        text: "  "
                      ),
                      TextSpan(
                        text: "Register here.",
                        style: TextStyle(color:Colors.black,fontSize: 16,
                            decoration: TextDecoration.underline),
                        recognizer: TapGestureRecognizer()..onTap=() {
                          nextScreen(context, RegisterPage());
                        } )
                    ]
                  )),
                ],
              )

            ],
          ),
        ),
      ),
    );
  }
}
