import 'package:chat_app/helper/helper_function.dart';
import 'package:chat_app/pages/auth/loginpage.dart';
import 'package:chat_app/pages/homepage.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../constant.dart';
import '../widgets/widgets.dart';
class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey=GlobalKey<FormState>();
  String? email;
  String? password;
  String? fullName;
  bool isLoading=false;
  bool showPassword=false;
  AuthService authService=AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body: isLoading?Center(child: CircularProgressIndicator(
      color: Constants().primaryColor,
    )):  SingleChildScrollView(
    child: Form(
    key: formKey,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
   Column(children: [
     Text("Groupie",style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold),),

     SizedBox(height: 10,),

     Text("Create your account now to chat and explore",
       style: TextStyle(fontSize: 15,fontWeight: FontWeight.w400),),

     SizedBox(height: 10,),

     Image.asset("assets/registerpic.webp"),


   ],),

      TweenAnimationBuilder(
          tween: Tween(begin: 0.1,end: 1.0),
          duration: Duration(milliseconds: 1700),
          builder: (_,val,child){
            return Column(
              children: [
                SizedBox(
                  width:val*MediaQuery.of(context).size.width,
                  child: TextFormField(
                    decoration: textInputDecoration.copyWith(
                      labelText: "Full Name",
                      prefixIcon: Icon(Icons.person,
                        color: Constants().primaryColor,),
                    ),
                    validator: (value){
                      print(value);
                      if(value!.isEmpty)
                      {
                        return "Please enter your name";
                      }
                      else
                      {
                        return null;
                      }
                    },
                    onChanged: (val)
                    {
                      setState(() {
                        fullName=val;
                        (fullName);
                      });
                    },
                  ),
                ),
              ],
            );
          }),


    const SizedBox(height: 15,),
    TweenAnimationBuilder(tween: Tween(begin: 0.1,end: 1.0),
        duration: Duration(milliseconds: 1900),
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
                  if(val!.isEmpty)
                  {
                    return "Please Enter your Email";
                  }
                  else{
                    return (RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(val!)?null:"Please Enter a valid email");
                  }
                }
            ),
          ),
        ],
      );
        }),

    SizedBox(height: 15,),

    TweenAnimationBuilder(tween: Tween(begin: 0.1,end: 1.0),
        duration: Duration(milliseconds: 2100),
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
                   child: showPassword?Icon(Icons.visibility,
                   color: Constants().primaryColor,):Icon(Icons.visibility_off,color: Constants().primaryColor,),
                ),
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
                if(value!.isEmpty)
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
        ],
      );
        }),

    SizedBox(height: 15,),
    TweenAnimationBuilder(
        tween: Tween(begin: 0.1,end: 1.0),
        duration: Duration(milliseconds: 2300),
        builder: (_,val,child){
      return  Column(
        children: [
          SizedBox(
            width: val*MediaQuery.of(context).size.width,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Constants().primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))
                ),
                onPressed: ()async{
                  if(formKey.currentState!.validate())
                  {
                    setState(() {
                      isLoading=true;
                    });
                    await authService.registerUserWithEmailPassword(fullName!, email!, password!).
                    then((value)async {
                      if(value==true)
                      {
                        await HelperFunction().saveUserLoggedInStatus(value);
                        await HelperFunction().saveUserNameSf(fullName!);
                        await HelperFunction().saveUserEmailSf(email!);
                        nextScreen(context, HomePage());

                      }
                      else
                      {
                        showSnackBar(context, Colors.red, value);
                        setState(() {
                          isLoading=false;
                        });
                      }
                    });

                  }
                }, child: const Text("Register",
              style: TextStyle(fontSize: 16),)),
          ),
        ],
      );
        }),

    SizedBox(height: 10,),

Column(
  children: [
    Text.rich(
        TextSpan(
            text: "Already have an account?",
            style: TextStyle(color: Colors.black, fontSize: 16),
            children: [
              TextSpan(
                  text: "  "
              ),
              TextSpan(
                  text: "Sign In.",
                  style: TextStyle(color:Colors.black,fontSize: 16,
                      decoration: TextDecoration.underline),
                  recognizer: TapGestureRecognizer()..onTap=() {
                    nextScreen(context, LoginPage());
                  } )
            ]
        ))
  ],
)
    ],
    ),
    ),
    ),
    );
  }
}
