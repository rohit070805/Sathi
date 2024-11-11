import 'package:flutter/material.dart';

import 'package:sathi/colors.dart';


class addTrip extends StatefulWidget {
  const addTrip({super.key});

  @override
  State<addTrip> createState() => _addTripState();
}

class _addTripState extends State<addTrip> {

  TextEditingController start = TextEditingController();
  TextEditingController people = TextEditingController();
  TextEditingController end = TextEditingController();
  TextEditingController startdate = TextEditingController();
  TextEditingController enddate = TextEditingController();
  DateTime? startDate;

  Future<void> _selectDate(TextEditingController temp) async{
    DateTime? _picked = await showDatePicker(
      builder: (context,child)=>Theme(data: ThemeData().copyWith(
        colorScheme: ColorScheme.light(
          primary: appColor
        )
      ), child: child!),
        context: context,
        initialDate: temp == enddate? startDate!:DateTime.now(),
        firstDate: temp == enddate? startDate!:DateTime.now(),
        lastDate: DateTime(2100));
    if(_picked != null){
      setState(() {
        if(temp == startdate) {
          startDate = _picked;
        }
        temp.text = _picked.toString().split(" ")[0];
      });
    }
  }
  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: appColor,
        shape:const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom:Radius.circular(30) )
        ),
        title: const Text("P o s t",style: TextStyle(color: Colors.white,fontSize: 30),),
      ),
      body: Center(
        child: Container(
            margin: EdgeInsets.only(left: 20,right: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      margin: const EdgeInsets.only(left: 20),
                      child: const Text("Add Trip",style: TextStyle(color: Color(0xFF4472C4), fontSize: 38,fontWeight: FontWeight.bold),)),
                  const SizedBox(height: 20,),
                  TextField(
                    style: const TextStyle(fontSize: 16),
                    controller:start ,

                    decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.location_on),
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blueAccent)
                        ),
                        hintText: "Starting",
                        labelText: "Starting",
                        labelStyle: const TextStyle(fontSize: 16,color: Colors.black),
                        hintStyle: const TextStyle(fontSize: 16),
                        fillColor: Colors.cyan.shade50,

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),

                        )
                    ),
                  ),
                  const SizedBox(height: 20,),
                  TextField(

                    controller:end ,
                    style: const TextStyle(fontSize: 16),
                    decoration: InputDecoration(

                        prefixIcon:const Icon(Icons.location_on),
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blueAccent)
                        ),
                        hintText: "Destination",
                        labelText: "Destination",
                        labelStyle: const TextStyle(fontSize: 16,color: Colors.black),
                        hintStyle: const TextStyle(fontSize: 16),
                        fillColor: Colors.cyan.shade50,

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        )
                    ),
                  ),
                  const SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment:MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: TextField(

                          controller:startdate ,
                          style: const TextStyle(fontSize: 16),
                          decoration: InputDecoration(

                              prefixIcon:const Icon(Icons.calendar_month_sharp),
                              focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blueAccent)
                              ),
                              hintText: "From",
                              labelText: "From",

                              labelStyle: const TextStyle(fontSize: 16,color: Colors.black),
                              hintStyle: const TextStyle(fontSize: 16),
                              fillColor: Colors.cyan.shade50,

                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              )
                          ),
                          readOnly: true,
                          onTap: (){
                            _selectDate(startdate);
                          },
                        ),
                      ),
                      const SizedBox(width: 50,),
                      Expanded(
                        child: TextField(

                          controller:enddate ,
                          style: const TextStyle(fontSize: 16),
                          decoration: InputDecoration(

                              prefixIcon:const Icon(Icons.calendar_month_sharp),
                              focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blueAccent)
                              ),
                              hintText: "To",
                              labelText: "To",
                              labelStyle: const TextStyle(fontSize: 16,color: Colors.black),
                              hintStyle: const TextStyle(fontSize: 16),
                              fillColor: Colors.cyan.shade50,

                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              )
                          ),
                          readOnly: true,
                          onTap: (){
                            if(startDate == null){
                              const snackbar = SnackBar(content: Text("Select Starting Date First!!"));
                              ScaffoldMessenger.of(context).showSnackBar(snackbar);
                            }else {
                              _selectDate(enddate);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment:MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: TextField(
                          controller:people ,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(fontSize: 16),
                          decoration: InputDecoration(

                              prefixIcon:const Icon(Icons.people),
                              focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blueAccent)
                              ),
                              hintText: "Members",
                              labelText: "Members",
                              labelStyle: const TextStyle(fontSize: 16,color: Colors.black),
                              hintStyle: const TextStyle(fontSize: 16),
                              fillColor: Colors.cyan.shade50,

                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              )
                          ),
                        ),
                      ),
                      const SizedBox(width: 50,),
                      SizedBox(
                        height: 60,
                        child: ElevatedButton(onPressed: ()async{
                          },
                            style:  ElevatedButton.styleFrom(
                              backgroundColor: appColor,
                            ),
                            child: const Icon(Icons.done,color: Colors.white,size: 40,)),
                      )
                    ],
                  ),
                ],
              ),
            )

        ),
      ),
    );

  }
}
