

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sathi/colors.dart';
import 'package:sathi/firebase_auth_services.dart';
import 'package:sathi/firestor.dart';

import 'package:sathi/loginscreen.dart';
import 'package:sathi/main.dart';

class SignupScreen extends StatefulWidget {
  final String name;
  final String dob;
  final String aadharNumber;
   SignupScreen({super.key,required this.name, required this.dob, required this.aadharNumber});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  final FirebaseAuthServices _auth = FirebaseAuthServices();
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();

  void _signup()async{
    String username = widget.name;
    String usermail = email.text;
    String userpass = pass.text;
    User? user = await _auth.signUpWithEmailAndPassword(username,usermail,widget.aadharNumber,widget.dob, userpass);

    if(user!= null) {

        Fluttertoast.showToast(msg: "Registered Successfully");

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => BottomNavigate()));

    }
    else{
      print("some error occured");
    }
  }
  @override
  Widget build(BuildContext context) {
    var mediaquery = MediaQuery.of(context);
    return Container(
      decoration:const  BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/signupbg.png'),
              fit: BoxFit.cover,

          )
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(

          margin: EdgeInsets.only(left: 50,right: 50,top: mediaquery.size.height*0.16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Container(
                    margin:const EdgeInsets.only(left: 20),
                    child: const Text("Sign Up",style: TextStyle(fontSize: 30,fontWeight: FontWeight.w400),)),

                const SizedBox(height: 20,),
                Container(
                    width: mediaquery.size.width*0.8,
                    height: 55,
                    decoration: BoxDecoration(
                        borderRadius:BorderRadius.all(Radius.circular(10)),
                        border: Border.all(
                            color: appColor
                        )
                    ),

                    child:
                    ListTile(
                      leading: Icon(Icons.person),
                      title: Text(widget.name),
                    )

                ),
                const SizedBox(height: 20,),
                Container(
                    width: mediaquery.size.width*0.8,
                    height: 55,
                    decoration: BoxDecoration(
                        borderRadius:BorderRadius.all(Radius.circular(10)),
                        border: Border.all(
                            color: appColor
                        )
                    ),

                    child:
                    ListTile(
                      leading: Icon(Icons.date_range),
                      title: Text(widget.dob),
                    )

                ),
                const SizedBox(height: 20,),
                Container(
                  width: mediaquery.size.width*0.8,
                  height: 55,
                  decoration: BoxDecoration(
                      borderRadius:BorderRadius.all(Radius.circular(10)),
                      border: Border.all(
                          color: appColor
                      )
                  ),

                  child:
                  ListTile(
                    leading: Icon(Icons.credit_score),
                    title: Text(widget.aadharNumber),
                  )

                ),

                const SizedBox(height: 20,),
                TextField(
                  style:const TextStyle(fontSize: 16),
                  controller:email,

                  decoration: InputDecoration(
                      prefixIcon:const Icon(Icons.email),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blueAccent)
                      ),
                      hintText: "Email",
                      labelText: "Email",
                      labelStyle: const TextStyle(fontSize: 16,color: Colors.black),
                      hintStyle:const TextStyle(fontSize: 16),
                      fillColor: Colors.cyan.shade50,

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),

                      )
                  ),
                ),
                const SizedBox(height: 20,),
                TextField(
                  obscureText: true,
                  obscuringCharacter: '*',
                  controller:pass ,
                  style:const TextStyle(fontSize: 16),
                  decoration: InputDecoration(

                      prefixIcon:const Icon(Icons.lock),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blueAccent)
                      ),
                      hintText: "Password",
                      labelText: "Password",
                      labelStyle:const TextStyle(fontSize: 16,color: Colors.black),
                      hintStyle:const TextStyle(fontSize: 16),
                      fillColor: Colors.cyan.shade50,

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      )
                  ),
                ),
                const SizedBox(height: 40,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  SizedBox(width: mediaquery.size.width*0.5,),
                    SizedBox(
                      height: 60,
                      child: ElevatedButton(onPressed: (){
                       _signup();
                      },
                          style:  ElevatedButton.styleFrom(
                            backgroundColor: appColor,
                          ),
                          child:const Icon(Icons.arrow_forward_ios,color: Colors.white,)),
                    )
                  ],
                ),

              ],
            ),
          ),
        ),
      ),
    );

  }
}
