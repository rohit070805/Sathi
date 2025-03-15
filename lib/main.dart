import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sathi/colors.dart';
import 'package:sathi/profilepage.dart';
import 'package:sathi/splashscreen.dart';
import 'aichatscreen.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'consts.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'Addtrip.dart';
import 'expenditurepage.dart';
import 'scrollpage.dart';

Future main() async{
  Gemini.init(apiKey: GEMINI_API_KEY);
  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb){
    await Firebase.initializeApp(options: FirebaseOptions(
        apiKey: Firebase_Api,
        appId: Firebase_AppId,
        messagingSenderId: "177562704830",
        projectId: "sathi-e746c"));
  }
  await Firebase.initializeApp();
  runApp(const MyApp());
}
List<ChatMessage> messages = [];

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:const SplashScreen()
    );
  }
}

class BottomNavigate extends StatefulWidget {
  const BottomNavigate({super.key});
  @override
  State<BottomNavigate> createState() => _BottomNavigateState();
}
class _BottomNavigateState extends State<BottomNavigate> {
  int myIndex = 0;
  List<Widget> _widgetList = [
    const ProfilePage(),
    const addTrip(),
    const scrollpage(),
    const expenditurePage(),
    const aichatscreen()
  ];
  final List<Widget> _navigationitems = [
    const Icon(Icons.home,color: Colors.white,),
    const Icon(Icons.add,color: Colors.white,),
    const Icon(Icons.travel_explore_outlined,color: Colors.white,),
    const Icon(Icons.people,color: Colors.white,),
    const Icon(Icons.ac_unit,color: Colors.white,)
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetList[myIndex],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.white,
        color: appColor,
        height: 55,
        items: _navigationitems,
        onTap: (index){
          setState(() {
            myIndex = index;
          });
        },

      ),
    );
  }
}
