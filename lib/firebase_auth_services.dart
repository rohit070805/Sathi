
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'firestor.dart';

class FirebaseAuthServices {
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUpWithEmailAndPassword(String name,String email,
      String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await credential.user!.updateDisplayName(name);
      await credential.user!.reload();
      await Firebase_firestor().CreateUser(email: email, username: name);
      return credential.user;

    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(msg: "Already a User,Log In!!", toastLength: Toast.LENGTH_SHORT);
      }  else {
        Fluttertoast.showToast(msg: "Sign Up Failed: ${e.message}", toastLength: Toast.LENGTH_SHORT);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "An error occurred", toastLength: Toast.LENGTH_SHORT);
    }


    return null;
  }
  Future<User?> signInWithEmailAndPassword(String email,
      String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    }  on FirebaseAuthException catch (e) {
      print('Error code: ${e.code}'); // Debugging: print the error code
      if (e.code == "invalid-credential") {
        Fluttertoast.showToast(msg: "Incorrect email or Password", toastLength: Toast.LENGTH_SHORT);
      }  else {
        // Handle other errors
        Fluttertoast.showToast(msg: "Login Failed: ${e.message}", toastLength: Toast.LENGTH_SHORT);
      }
    } catch (e) {
      // In case something unexpected happens
      print("Unexpected error: $e");
      Fluttertoast.showToast(msg: "An unexpected error occurred", toastLength: Toast.LENGTH_SHORT);
    }

    return null;
  }
  Future<void> signOut() async{
    try{
      await _auth.signOut();
    }
    catch (e) {
      print("some error occured");
    }
  }
  String? getUserName(){
    User? user =  _auth.currentUser;
    if(user!=null){
      return user.displayName;
    }
    return "No User Found";
  }
}