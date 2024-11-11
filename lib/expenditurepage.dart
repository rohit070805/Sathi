import 'package:flutter/material.dart';
class expenditurePage extends StatefulWidget {
  const expenditurePage({super.key});

  @override
  State<expenditurePage> createState() => _expenditurePageState();
}

class _expenditurePageState extends State<expenditurePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
          child:Text("Coming Soon",style: TextStyle(fontSize: 30),)
      ),
    );
  }
}
