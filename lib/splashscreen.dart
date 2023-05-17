import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:registerlogin/contactpage.dart';
import 'package:registerlogin/main.dart';
import 'package:shared_preferences/shared_preferences.dart';


class splashscreen extends StatefulWidget {
  static SharedPreferences? prefs;
   splashscreen({Key? key}) : super(key: key);

  @override
  State<splashscreen> createState() => _splashscreenState();
}

class _splashscreenState extends State<splashscreen> {
  bool loginstatus=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    forsharepref();
  }

  Future<void> forsharepref() async {
    splashscreen.prefs = await SharedPreferences.getInstance();
    setState(() {
      loginstatus=splashscreen.prefs!.getBool('loginstatus')??false;
     });
    Future.delayed(Duration(seconds: 1)).then((value) {
      if(loginstatus){
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return contactpage();
          },
        ));
      }
      else{
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return loginpage();
          },
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.asset("RawAnimations/loadinglottieanimation.json"),
      ),
    );
  }
}
