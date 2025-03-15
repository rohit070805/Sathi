import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sathi/colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:sathi/loginscreen.dart';
import 'package:sathi/signupscreen.dart';
class Scanaadhar extends StatefulWidget {
  const Scanaadhar({super.key});

  @override
  State<Scanaadhar> createState() => _ScanaadharState();
}

class _ScanaadharState extends State<Scanaadhar> {
  @override

  Future<void> scanAadhaar() async {
    var status = await Permission.camera.request();
    if (status.isGranted) {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
      if (pickedFile == null) return; // User canceled camera

      File imageFile = File(pickedFile.path);
      final extractedText = await extractAadhaarData(imageFile);

      // Navigate to details screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SignupScreen(
            name: extractedText['name'] ?? '',
            dob: extractedText['dob'] ?? '',
            aadharNumber: extractedText['aadharNumber'] ?? '',
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Camera permission is required!')),
      );
    }
  }


  Future<Map<String, String>> extractAadhaarData(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);
    final textRecognizer = TextRecognizer();
    final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
    await textRecognizer.close(); // Free memory

    String text = recognizedText.text;
    print(text);


    RegExp nameRegex = RegExp(r'(?<=Government of India\s*)(\S+\s+\S+)');
    RegExp dobRegex = RegExp(r'DOB: \s*(\d{2}/\d{2}/\d{4})');
    RegExp aadharRegex = RegExp(r"\d{4} \d{4} \d{4}");

    String? dob = dobRegex.firstMatch(text)?.group(1);
    String? aadharNumber = aadharRegex.firstMatch(text)?.group(0);
    String? name = nameRegex.firstMatch(text)?.group(1)?.trim();
    return {
      'name': name ?? 'Not Found',
      'dob': dob ?? 'Not Found',
      'aadharNumber': aadharNumber ?? 'Not Found',
    };
  }

  Widget build(BuildContext context) {
    var mediaquery = MediaQuery.of(context);
    return Container(
      decoration:const  BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/loginbg.png'),
            fit: BoxFit.cover,

          )
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(

          margin: EdgeInsets.only(left: 50,right: 50,top: mediaquery.size.height*0.40),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(onPressed: (){
                  scanAadhaar();
                },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: appColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(10)
                        )
                      )
                    ),

                    child: Text("Scan Aadhar",style: TextStyle(color:Colors.white),)),
                Spacer(),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an Account?",style: TextStyle(fontSize: 16),),

                    SizedBox(width: 10,),
                    InkWell(
                        onTap: (){
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const LoginScreen()));
                        },
                        child:const Text("Sign In!",style: TextStyle(fontSize: 18,color: Colors.blue),))
                  ],
                ),
                SizedBox(height: 20,)
              ],
            ),
          )
        ),
      ),
    );
  }
}
