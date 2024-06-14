import 'package:chat_app/helper/helper_function.dart';
import 'package:chat_app/services/databaseservice.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService
{
  final FirebaseAuth firebaseAuth=FirebaseAuth.instance;
  Future registerUserWithEmailPassword(String fullName,String email, String password)
  async{
    try
        {
        User user= ( await firebaseAuth.createUserWithEmailAndPassword
          (email: email, password: password)).user!;
        if(user!=null)
          {
          await DatabaseService(uid: user.uid).updateUserData(fullName, email);
            return true;

          }
        }
        on FirebaseAuthException catch(e)
    {
      print(e);
      return e.message;
    }
  }
  Future signOut()async
  {
    try
        {
          await HelperFunction().saveUserLoggedInStatus(false);
          await HelperFunction().saveUserNameSf("");
          await HelperFunction().saveUserEmailSf("");
          await firebaseAuth.signOut();
        }
        catch(e)
    {
      return null;
    }
  }

  Future loginWithUserNameAndPassword(String email, String password)async
  {
    try
        {
          User user= (await firebaseAuth.signInWithEmailAndPassword
            (email: email, password: password)).user!;
          if(user!=null)
            {
              return true;
            }
        }
        on FirebaseAuthException catch(e)
    {
      return e.message;
    }
  }
}