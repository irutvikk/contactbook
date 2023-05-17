import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:registerlogin/contactpage.dart';
import 'package:sqflite/sqflite.dart';

import 'dbhelper.dart';

class contactupdatepage extends StatefulWidget {
  int index;
  List<Map> datalist;

  contactupdatepage(this.index, this.datalist);

  @override
  State<contactupdatepage> createState() => _contactupdatepageState();
}

class _contactupdatepageState extends State<contactupdatepage> {

  Icon visiblepass=Icon(Icons.visibility_rounded,color: Colors.pinkAccent,);
  Icon hidepass=Icon(Icons.visibility_off_rounded,color: Colors.pinkAccent,);
  bool hidepassword=true;

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
  TextEditingController password = TextEditingController();
  TextEditingController phone = TextEditingController();

  bool usernametext = false;
  bool passwordtext = false;
  bool phonetext = false;

  String? usernameerror;
  String? passworderror;
  String? phoneerror;

  Database? db;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdatabase();

    setState(() {
      gender = "${widget.datalist[widget.index]['GENDER']}";
      selectededucation = "${widget.datalist[widget.index]['QUALIFICATION']}";
      widget.datalist[widget.index]['PLAYING'].toString().contains("true",0) ? playing=true:null;
      widget.datalist[widget.index]['READING'].toString().contains("true",0) ? reading=true:null;
      widget.datalist[widget.index]['TRAVELLING'].toString().contains("true",0) ? travelling=true:null;
      widget.datalist[widget.index]['WRITING'].toString().contains("true",0) ? writing=true:null;
      widget.datalist[widget.index]['COOKING'].toString().contains("true",0) ? cooking=true:null;
    });
  }

  List<Map> datalist = [];

  getdatabase() {
    dbhelper().getdatabase().then((value) {
      setState(() {
        db = value;
      });
    });
  }

  Future<bool> backonupdatedialogue() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Cancel Update?",style: TextStyle(fontSize: 18,letterSpacing: 1),),
          actions: [
            TextButton(onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                return contactpage();
              },));
            }, child: Text("YES",style: TextStyle(fontSize: 18,letterSpacing: 1),)),
            TextButton(onPressed: () {
              Navigator.pop(context);
            }, child: Text("NO",style: TextStyle(fontSize: 18,letterSpacing: 1)))
          ],
        );
      },
    );
    return Future.value(true);
  }

  Future<bool> showdialogue(String usernamee, String passwordd, String phoneno) {
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
                  dbhelper().updaterecord(
                      usernamee,
                      passwordd,
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

  @override
  Widget build(BuildContext context) {
    double fullhight = MediaQuery.of(context).size.height;
    double fullwidth = MediaQuery.of(context).size.width;

    return WillPopScope(
        onWillPop: backonupdatedialogue,
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          children: [
            SizedBox(
              height: fullhight * .09,
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(left: 20),
              child: Text(
                "Updating,",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: fullhight * .015),
            Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(left: 30),
                child: Row(
                  children: [
                    Text(
                      "Records of ",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.w400),
                    ),
                    Text(
                      "${widget.datalist[widget.index]["ID"]} - ${widget.datalist[widget.index]["USERNAME"]}",
                      style: TextStyle(
                          fontSize: 25,
                          color: Colors.pinkAccent,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                )),
            SizedBox(height: fullhight * .01),
            Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              child: TextField(
                controller: username,
                decoration: InputDecoration(
                  labelText: "Enter Your Username",
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
                obscureText: hidepassword,
                controller: password,
                autofocus: false,
                decoration: InputDecoration(
                  suffixIcon: IconButton(onPressed: () {
                    setState(() {
                      if(hidepassword==true){
                        hidepassword=false;
                      }else{
                        hidepassword=true;
                      }
                    });
                  }, icon: hidepassword==true?visiblepass:hidepass),
                  labelText: "Enter Password",
                  errorText: passwordtext ? passworderror : null,
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
              margin: EdgeInsets.only(left: fullhight * 0.02),
              alignment: Alignment.centerLeft,
              child: Text(
                "Gender : ",
                style: TextStyle(
                    fontSize: fullhight * 0.025, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: fullwidth * 0.03),
              child: Row(
                children: [
                  Radio(
                    activeColor: Colors.pinkAccent,
                    value: "Male",
                    groupValue: gender,
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
                    groupValue: gender,
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
                    style: TextStyle(
                        fontSize: fullhight * 0.025,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  width: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.shade200),
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
                style: TextStyle(
                    fontSize: fullhight * 0.025, fontWeight: FontWeight.bold),
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
              height: fullhight * .05,
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
                  backgroundColor:
                  MaterialStatePropertyAll(Colors.pinkAccent.shade200),
                  shape: MaterialStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                onPressed: () {
                  String usernamee = username.text;
                  String passwordd = password.text;
                  String phoneno = phone.text;

                  usernametext = false;
                  passwordtext = false;
                  phonetext = false;

                  RegExp nameRegExpusername = RegExp(r'^[A-Za-z][A-Za-z0-9_]{5,18}$');
                  RegExp nameRegExppassword = RegExp(
                      r'^(?=.{4,12})(?![_.])(?!.*[_.]{2})[a-zA-Z0-9._]+(?<![_.])$');
                  setState(() {
                    if(gender==""){gender = "${widget.datalist[widget.index]['GENDER']}";}
                    selectededucation == "Choose" ? selectededucation = "${widget.datalist[widget.index]['QUALIFICATION']}" : null;
                    if(usernamee.isEmpty && passwordd.isEmpty && phoneno.isEmpty){
                      usernametext = true;
                      usernameerror = "Enter Username";
                      passwordtext = true;
                      passworderror = "Enter Password";
                      phonetext = true;
                      phoneerror = "Enter Phone Number";
                    }
                    else if (usernamee.isEmpty) {
                      usernametext = true;
                      usernameerror = "Enter Username";
                    }else if (passwordd.isEmpty) {
                      passwordtext = true;
                      passworderror = "Enter Password";
                    } else if(phoneno.isEmpty){
                      phonetext = true;
                      phoneerror = "Enter Phone Number";
                    }
                    else if (!nameRegExpusername.hasMatch(usernamee)) {
                      usernametext = true;
                      usernameerror = "Enter Valid Username";
                    } else if (!nameRegExppassword.hasMatch(passwordd)) {
                      passwordtext = true;
                      passworderror = "Enter Valid Password";
                    }else if (usernamee==passwordd) {
                      passwordtext=true;
                      passworderror = "Name and Password can't be same";
                      password.text="";
                    }
                    else{
                      showdialogue(usernamee, passwordd,phoneno);
                    }

                  });
                },
                child: Text(
                  "Update",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    )
    );
  }
}
