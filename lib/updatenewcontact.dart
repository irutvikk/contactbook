import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';

import 'contactpage.dart';
import 'dbhelper.dart';

class updatenewcontact extends StatefulWidget {
  int index;
  List<Map<dynamic, dynamic>> datalist;
  updatenewcontact(this.index, this.datalist);




  @override
  State<updatenewcontact> createState() => _updatenewcontactState();
}

class _updatenewcontactState extends State<updatenewcontact> {
  Database? db;

  String gender = "";
  bool playing = false;
  bool reading = false;
  bool travelling = false;
  bool writing = false;
  bool cooking = false;
  String selectededucation = "Choose";
  List education = [
    "Choose",
    "10th",
    "12th",
    "BCA",
    "MCA",
    "BBA",
    "MBA",
    "BCOM",
    "MCOM",
    "LLB",
    "BMS",
    "CA",
    "CS",
    "CWA",
    "Bsc",
    "Msc",
    "BPharma",
    "BE",
    "CFP",
    "B Tech",
    "M Tech"
  ];
  TextEditingController username = TextEditingController();
  TextEditingController phone = TextEditingController();

  bool usernametext = false;
  bool phonetext = false;

  String? usernameerror;
  String? phoneerror;

  @override
  void initState() {
    super.initState();
    getdatabase();

    setState(() {
      username.text=widget.datalist[widget.index]['USERNAME'];
      phone.text=widget.datalist[widget.index]['PHONE'];

      widget.datalist[widget.index]['PLAYING'].toString().contains("true",0) ? playing=true:null;
      widget.datalist[widget.index]['READING'].toString().contains("true",0) ? reading=true:null;
      widget.datalist[widget.index]['TRAVELLING'].toString().contains("true",0) ? travelling=true:null;
      widget.datalist[widget.index]['WRITING'].toString().contains("true",0) ? writing=true:null;
      widget.datalist[widget.index]['COOKING'].toString().contains("true",0) ? cooking=true:null;
    });
  }

  getdatabase() {
    dbhelper().getdatabase().then((value) {
      setState(() {
        db = value;
      });
    });
  }
  Future<bool> showdialogue(String usernamee, String phoneno) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Are you sure to Update?",
            style: TextStyle(fontSize: 18, letterSpacing: 1),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                dbhelper().updatecontact(
                    usernamee,
                    phoneno,
                    gender,
                    selectededucation,
                    playing,
                    reading,
                    travelling,
                    writing,
                    cooking,
                    widget.datalist[widget.index]['ID'],
                    db!);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.pinkAccent,
                    content: Text(
                      "1 Record Updated",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                );
                Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) {
                    return contactpage();

                  },
                ));
              },
              child: Text(
                "YES",
                style: TextStyle(fontSize: 18, letterSpacing: 1),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("NO",
                style: TextStyle(fontSize: 18, letterSpacing: 1),),)
          ],
        );
      },
    );
    return Future.value(true);
  }

  backoncontactpage() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return contactpage();
    },));
  }

  @override
  Widget build(BuildContext context) {
    double fullhight = MediaQuery.of(context).size.height;
    double fullwidth = MediaQuery.of(context).size.width;
    return WillPopScope(child: Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(centerTitle: true,
        title: Text("Update Contact"),
        backgroundColor: Colors.pinkAccent,
      ),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          children: [
            SizedBox(
              height: fullhight * .05,
            ),
            Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              child: TextField(
                controller: username,
                autofocus: false,
                decoration: InputDecoration(
                  labelText: "Enter Name",
                  errorText: usernametext ? usernameerror : null,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.pinkAccent),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: fullhight * .01,
            ),
            Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              child: TextField(
                controller: phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                keyboardType: TextInputType.number,
                autofocus: false,
                decoration: InputDecoration(
                  labelText: "Enter Phone Number",
                  errorText: phonetext ? phoneerror : null,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.pinkAccent),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: fullhight * .01,
            ),
            Container(
              margin: EdgeInsets.only(left: fullhight * 0.02,top: fullhight * 0.01),
              alignment: Alignment.centerLeft,
              child: Text(
                "Gender : ",
                style: TextStyle(fontSize: fullhight * 0.025, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: fullwidth * 0.03),
              child: Row(
                children: [
                  Radio(
                    activeColor: Colors.pinkAccent,
                    value: "Male",
                    groupValue: gender == ""
                        ? "${widget.datalist[widget.index]["GENDER"]}"
                        : gender,
                    onChanged: (value) {
                      setState(() {
                        gender = value!;
                        print(gender);
                      });
                    },
                  ),
                  Text(
                    "Male",
                    style: TextStyle(fontSize: fullhight * 0.020),
                  ),
                  Radio(
                    activeColor: Colors.pinkAccent,
                    value: "Female",
                    groupValue: gender == ""
                        ? "${widget.datalist[widget.index]["GENDER"]}"
                        : gender,
                    onChanged: (value) {
                      setState(() {
                        gender = value!;
                        print(gender);
                      });
                    },
                  ),
                  Text(
                    "Female",
                    style: TextStyle(fontSize: fullhight * 0.020),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left: fullhight * 0.02),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Qualification : ",
                    style: TextStyle(fontSize: fullhight * 0.025, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  width: 100,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.grey.shade200),
                  margin: EdgeInsets.only(left: fullhight * .02),
                  child: DropdownButton(
                    alignment: Alignment.center,
                    underline: Container(),
                    value: selectededucation == "Choose"
                        ? "${widget.datalist[widget.index]["QUALIFICATION"]}"
                        : selectededucation,
                    items: education.map((var education) {
                      return DropdownMenuItem(
                        child: Text("$education"),
                        value: education,
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(
                            () {
                          selectededucation = "$value";
                          print(selectededucation);
                        },
                      );
                    },
                  ),
                )
              ],
            ),
            SizedBox(
              height: fullhight * .01,
            ),
            Container(
              margin: EdgeInsets.only(left: fullhight * 0.02),
              alignment: Alignment.centerLeft,
              child: Text(
                "Hobbies : ",
                style: TextStyle(fontSize: fullhight * 0.025, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: fullhight * .01,
            ),
            Wrap(
              alignment: WrapAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: fullwidth * .005),
                  width: 120,
                  child: Row(
                    children: [
                      Transform.scale(
                        scale: 1.3,
                        child: Checkbox(
                          side: BorderSide(strokeAlign: StrokeAlign.inside),
                          // shape: CircleBorder(),
                          checkColor: Colors.pinkAccent,
                          activeColor: Colors.transparent,
                          value: playing,
                          onChanged: (value) {
                            setState(
                                  () {
                                playing = value!;
                                print("Playing=$playing");
                              },
                            );
                          },
                        ),
                      ),
                      Text(
                        "Playing",
                        style: TextStyle(fontSize: fullhight * 0.020),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: fullwidth * .005),
                  width: 120,
                  child: Row(
                    children: [
                      Transform.scale(
                        scale: 1.3,
                        child: Checkbox(
                          side: BorderSide(strokeAlign: StrokeAlign.inside),
                          //shape: CircleBorder(),
                          checkColor: Colors.pinkAccent,
                          activeColor: Colors.transparent,
                          value: reading,
                          onChanged: (value) {
                            setState(
                                  () {
                                reading = value!;
                                print("Reading=$reading");
                              },
                            );
                          },
                        ),
                      ),
                      Text(
                        "Reading",
                        style: TextStyle(fontSize: fullhight * 0.020),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: fullwidth * .005),
                  width: 120,
                  child: Row(
                    children: [
                      Transform.scale(
                        scale: 1.3,
                        child: Checkbox(
                          side: BorderSide(strokeAlign: StrokeAlign.inside),
                          //shape: CircleBorder(),
                          checkColor: Colors.pinkAccent,
                          activeColor: Colors.transparent,
                          value: travelling,
                          onChanged: (value) {
                            setState(
                                  () {
                                travelling = value!;
                                print("Travelling=$travelling");
                              },
                            );
                          },
                        ),
                      ),
                      Text(
                        "Travelling",
                        style: TextStyle(fontSize: fullhight * 0.020),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: fullwidth * .005),
                  width: 120,
                  child: Row(
                    children: [
                      Transform.scale(
                        scale: 1.3,
                        child: Checkbox(
                          side: BorderSide(strokeAlign: StrokeAlign.inside),
                          //shape: CircleBorder(),
                          checkColor: Colors.pinkAccent,
                          activeColor: Colors.transparent,
                          value: writing,
                          onChanged: (value) {
                            setState(
                                  () {
                                writing = value!;
                                print("Writing=$writing");
                              },
                            );
                          },
                        ),
                      ),
                      Text(
                        "Writing",
                        style: TextStyle(fontSize: fullhight * 0.020),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: fullwidth * .005),
                  width: 120,
                  child: Row(
                    children: [
                      Transform.scale(
                        scale: 1.3,
                        child: Checkbox(
                          side: BorderSide(strokeAlign: StrokeAlign.inside),
                          //shape: CircleBorder(),
                          checkColor: Colors.pinkAccent,
                          activeColor: Colors.transparent,
                          value: cooking,
                          onChanged: (value) {
                            setState(
                                  () {
                                cooking = value!;
                                print("Cooking=$cooking");
                              },
                            );
                          },
                        ),
                      ),
                      Text(
                        "Cooking",
                        style: TextStyle(fontSize: fullhight * 0.020),
                      )
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: fullhight * .01,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
              height: fullhight * 0.065,
              width: fullwidth,
              margin: EdgeInsets.only(left: 15, right: 15),
              child: ElevatedButton(
                style: ButtonStyle(
                  splashFactory: NoSplash.splashFactory,
                  backgroundColor: MaterialStatePropertyAll(Colors.pinkAccent.shade200),
                  shape: MaterialStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                onPressed: () {
                  RegExp nameRegExpusername = RegExp(r'^[A-Za-z][A-Za-z0-9_]{7,29}$');
                  RegExp nameRegExppassword = RegExp(r'^(?=.{4,12})(?![_.])(?!.*[_.]{2})[a-zA-Z0-9._]+(?<![_.])$');

                  String usernamee = username.text;
                  String phoneno = phone.text;
                  usernametext = false;
                  phonetext = false;

                  setState(
                        () {
                      if (usernamee.isEmpty && phoneno.isEmpty) {
                        usernametext = true;
                        usernameerror = "Enter Name";
                        phonetext = true;
                        phoneerror = "Enter Phone Number";
                      } else if (usernamee.isEmpty) {
                        usernametext = true;
                        usernameerror = "Enter Name";
                      }  else if (phoneno.isEmpty) {
                        phonetext = true;
                        phoneerror = "Enter Phone Number";
                      } else if (!nameRegExpusername.hasMatch(usernamee)) {
                        usernametext = true;
                        usernameerror = "Enter Valid Username";
                      }else {
                        FocusManager.instance.primaryFocus?.unfocus();
                        showdialogue(usernamee,phoneno);

                      }
                    },
                  );
                },
                child: Text(
                  "Save Contact",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    ), onWillPop: () {
      return backoncontactpage();
    },);
  }
}
