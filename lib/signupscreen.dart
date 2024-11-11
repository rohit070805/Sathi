import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sathi/colors.dart';
import 'package:sathi/firebase_auth_services.dart';
import 'package:sathi/imagepicker.dart';
import 'package:sathi/loginscreen.dart';
import 'package:sathi/main.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  File? _imageFile;
  final FirebaseAuthServices _auth = FirebaseAuthServices();
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController name = TextEditingController();
  void _signup()async{
    String username = name.text;
    String usermail = email.text;
    String userpass = pass.text;
    User? user = await _auth.signUpWithEmailAndPassword(username,usermail, userpass);
    if(user!= null){
      Fluttertoast.showToast(msg: "Registered Successfully");
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  BottomNavigate() ));
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: ()async{
                        File _imageFilee = await ImagePickerr().uploadImage('gallery');
                        setState(() {
                          _imageFile = _imageFilee;
                        });
                      },
                      child:
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey ,
                        child: _imageFile==null?
                        CircleAvatar(
                          radius: 49,
                          backgroundImage: AssetImage('assets/images/person.png'),
                          backgroundColor: Colors.grey.shade200,
                        ):CircleAvatar(
                          radius: 49,
                          backgroundImage: Image.file(_imageFile!,fit: BoxFit.cover,).image,
                          backgroundColor: Colors.grey.shade200,
                        )
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20,),
                Container(
                    margin:const EdgeInsets.only(left: 20),
                    child: const Text("Sign Up",style: TextStyle(fontSize: 30,fontWeight: FontWeight.w400),)),
                const SizedBox(height: 20,),
                TextField(
                  style:const TextStyle(fontSize: 16),
                  controller:name,

                  decoration: InputDecoration(
                      prefixIcon:const Icon(Icons.person),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blueAccent)
                      ),
                      hintText: "Name",
                      labelText: "Name",
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
                  style:const TextStyle(fontSize: 16),
                  controller:email ,

                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.email_outlined),
                      focusedBorder:const OutlineInputBorder(
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                       const Text("Already have an Account?",style: TextStyle(fontSize: 16),),
                        InkWell(
                            onTap: (){
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const LoginScreen()));
                            },
                            child:const Text("Sign In!",style: TextStyle(fontSize: 18,color: Colors.blue),))
                      ],
                    ),
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
