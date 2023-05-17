import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:registerlogin/signup.dart';
import 'package:registerlogin/splashscreen.dart';
import 'package:sqflite/sqflite.dart';
import 'package:registerlogin/contactpage.dart';
import 'dbhelper.dart';

void main() {
  runApp(
      MaterialApp(debugShowCheckedModeBanner: false,
      home: splashscreen(),
  ));
}

class loginpage extends StatefulWidget {

  @override
  State<loginpage> createState() => _loginpageState();
}
class _loginpageState extends State<loginpage> {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  bool usernametext = false;
  bool passwordtext = false;

  Icon visiblepass=const Icon(Icons.visibility_rounded,color: Colors.pinkAccent,);
  Icon hidepass=const Icon(Icons.visibility_off_rounded,color: Colors.pinkAccent,);
  bool hidepassword=true;

  String? usernameerror;
  String? passworderror;

  Database? db;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     myvalue();
  }

  myvalue()
  {
    dbhelper().getdatabase().then((value) {
     setState(() {
       db = value;
     });
    });
  }
  Future<bool> closetheapp() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Close App?",style: TextStyle(fontSize: 18,letterSpacing: 1),),
          actions: [
            TextButton(onPressed: () {
              exit(0);
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

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    double fullhight = MediaQuery.of(context).size.height;
    double fullwidth = MediaQuery.of(context).size.width;


    return WillPopScope(child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            children: [
              SizedBox(
                height: fullhight * .11,
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(left: 20),
                child: Text(
                  "Welcome,",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: fullhight * .01),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(left: 20),
                child: Text(
                  "Sign in to continue!",
                  style: TextStyle(
                      fontSize: 21,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w400),
                ),
              ),
              SizedBox(height: fullhight * .11),
              Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                child: TextField(
                  controller: username,
                  autofocus: false,
                  decoration: InputDecoration(
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)
                      ,borderSide: BorderSide(
                        color: Colors.red),
                    ),
                    labelText: "Username",
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
                height: fullhight * .02,
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
                    labelText: "Password",
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
              Container(
                alignment: Alignment.centerRight,
                margin: EdgeInsets.only(right: 15),
                child: TextButton(
                  onPressed: () {


                  },
                  child: Text(
                    "Forgot Passowrd?",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
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
                    backgroundColor: MaterialStatePropertyAll(
                        Colors.pinkAccent.shade200
                    ),
                    shape: MaterialStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  onPressed: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    String usernamee=username.text;
                    String passwordd=password.text;

                    usernametext = false;
                    passwordtext = false;

                    RegExp nameRegExpusername = RegExp(r'^[A-Za-z][A-Za-z0-9_]{5,18}$');
                    RegExp nameRegExppassword = RegExp(
                        r'^(?=.{4,12})(?![_.])(?!.*[_.]{2})[a-zA-Z0-9._]+(?<![_.])$');
                    setState(() {
                      if(usernamee.isEmpty && passwordd.isEmpty){
                        usernametext = true;
                        usernameerror = "Enter Username";
                        passwordtext = true;
                        passworderror = "Enter Password";
                      } else if (usernamee.isEmpty) {
                        usernametext = true;
                        usernameerror = "Enter Username";
                      } else if (!nameRegExpusername.hasMatch(usernamee)) {
                        usernametext = true;
                        usernameerror = "Enter Valid Username";
                      }else if (passwordd.isEmpty) {
                        passwordtext = true;
                        passworderror = "Enter Password";
                      } else if (!nameRegExppassword.hasMatch(passwordd)) {
                        passwordtext = true;
                        passworderror = "Enter Valid Password";
                      }
                      else{
                        dbhelper().logindata(usernamee, passwordd, db!).then((value) {
                          bool loginwhen=value.length==1;
                          print(loginwhen);
                          if(loginwhen){
                            splashscreen.prefs!.setBool('loginstatus', true);
                            splashscreen.prefs!.setInt('ID', value[0]['ID']);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.pinkAccent,
                              content: Text("Login Successfully",style: TextStyle(color: Colors.white,fontSize: 18),),
                            ));
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                              return contactpage();
                            },));
                          }
                          else{
                            passwordtext = true;
                            passworderror = "Enter Valid Password";
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.pinkAccent,
                              content: Text("Username or Password are Incorrect!",style: TextStyle(color: Colors.white,fontSize: 18),),
                            ));
                          }
                        });
                      }
                    });

                  },
                  child: Text(
                    "Login",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              SizedBox(
                height: fullhight * .01,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.blue.shade900,
                ),
                height: fullhight * 0.065,
                width: fullwidth,
                margin: EdgeInsets.only(left: 15, right: 15),
                child: InkWell(
                  borderRadius: BorderRadius.circular(15),
                  onTap: () {
                    //
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.facebook_rounded,
                          size: 35, color: Colors.white),
                      Text(
                        "  Connect with Facebook",
                        style: TextStyle(fontSize: 16,color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),SizedBox(height: fullhight*.20,),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "I'm a new user, ",
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                            return signuppage();
                          },));
                        },
                        child: Text(
                          "Sign Up",
                          style: TextStyle(color: Colors.pinkAccent, fontSize: 17),
                        ))
                  ],
                ),
              )
            ],
          ),
        )
    ), onWillPop: () {
      return closetheapp();
    },);
  }
}
