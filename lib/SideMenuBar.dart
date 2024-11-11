import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sathi/colors.dart';
import 'package:sathi/firebase_auth_services.dart';
import 'package:sathi/loginscreen.dart';
class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  FirebaseAuthServices _auth = FirebaseAuthServices();
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 25,vertical: 16),
                  child: Text("S A T H I",style: TextStyle(color: appColor,fontSize: 25,fontWeight: FontWeight.w500),)),
              Divider(
                color: Colors.black.withOpacity(0.2),
              ),
              Container(
                padding: EdgeInsets.only(left: 5,right: 5,top: 5),
                margin: EdgeInsets.only(right: 20),
                child: TextButton(
                    onPressed: ()async {
                      await _auth.signOut();
                      Fluttertoast.showToast(msg: "Signed out Successfully",
                          fontSize: 18);
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));

                    }, child: Row(
                  children: [
                    Icon(Icons.outbond_outlined,color: Colors.red,size: 24),
                    SizedBox(width: 10,),
                    Text("Log Out",style:TextStyle(color: Colors.red,fontSize: 18))
                  ],
                )
                ),
              ),

            ],
          ),
        ),
      ),

    );
  }
}
