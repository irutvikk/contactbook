import 'dart:io';

import 'package:flutter/material.dart';
import 'package:registerlogin/addnewcontact.dart';
import 'package:registerlogin/contactupdatepage.dart';
import 'package:registerlogin/main.dart';
import 'package:registerlogin/splashscreen.dart';
import 'package:registerlogin/updatenewcontact.dart';
import 'package:sqflite/sqflite.dart';
import 'dbhelper.dart';

enum items {update,delete}

class contactpage extends StatefulWidget {
  const contactpage({Key? key}) : super(key: key);

  @override
  State<contactpage> createState() => _contactpageState();
}

class _contactpageState extends State<contactpage> {
  Database? db;
  List<Map> datalist = [];
  List<Map> searchlist = [];
  bool issearch=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdatabase();
  }

  getdatabase() {
    // dbhelper().getdatabase().then((value) {
    //   setState(() {
    //     db = value;
    //     dbhelper().viewdata(db!).then((value) {
    //       setState(() {
    //         datalist = value;
    //       });
    //     });
    //   });
    // });
    dbhelper().getdatabase().then((value) {
      setState(() {
        db = value;
        dbhelper().viewcontactdata(splashscreen.prefs!.getInt('ID') ?? 0,db!).then((value) {
          setState(() {
            datalist = value;
            searchlist=value;
          });
        });
      });
    });
  }

  Future<bool> backonloginpage() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Close App?",style: TextStyle(fontSize: 18,letterSpacing: 1),
          ),
          actions: [
            TextButton(onPressed: () {
              Navigator.pop(context);
              exit(0);
            }, child: Text("YES",style: TextStyle(fontSize: 18,letterSpacing: 1),
            ),
            ),
            TextButton(onPressed: () {
              Navigator.pop(context);
            }, child: Text("NO",style: TextStyle(fontSize: 18,letterSpacing: 1),
            ),
            ),
          ],
        );
      },
    );
    return Future.value(true);
  }

  void showdialog() {
    showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: Text("Logout?",style: TextStyle(fontSize: 20),),
        actions: [
          TextButton(onPressed: () {
            setState(() {
              splashscreen.prefs!.setBool('loginstatus', false);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.pinkAccent,
                content: Text("Logout Successfully",style: TextStyle(color: Colors.white,fontSize: 18),),
              ));
            });
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
              return loginpage();
            },));
          }, child: Text("YES",style: TextStyle(fontSize: 18),)),
          TextButton(onPressed: () {
            Navigator.pop(context);
          }, child: Text("NO",style: TextStyle(fontSize: 18),))
        ],
      );
    },);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add,size: 30),
        tooltip: "Add New Contact",
        clipBehavior: Clip.antiAlias,
        enableFeedback: false,
        backgroundColor: Colors.pinkAccent,
        onPressed: () {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
            return addnewcontact();
          },));
    },),
      appBar: issearch ? AppBar(
        backgroundColor: Colors.pinkAccent,
        title: Container(margin: EdgeInsets.only(left: 10,right: 10),
          child: TextField(
            onChanged: (value) {
              setState(() {
                if (value.isNotEmpty) {
                  searchlist = [];
                  for (int i = 0; i < datalist.length; i++) {
                    String name = datalist[i]['USERNAME'];
                    if (name.toLowerCase().contains(value.toLowerCase())) {
                      searchlist.add(datalist[i]);
                    }
                  }
                } else {
                  searchlist = datalist;
                }
              });
            },
            cursorColor: Colors.black,
            autofocus: true,
            decoration: InputDecoration(
              suffixIcon: IconButton(onPressed: () {

                setState(() {
                  issearch = false;
                  searchlist=datalist;
                });

              }, icon: Icon(Icons.close_rounded,color: Colors.black,)),
              filled: true,
              fillColor: Colors.white,
              hintText: 'Search',
              contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide(color: Colors.transparent),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(25),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
        ),
      ) :AppBar(
        title: Text("My Contacts"),actions: [
          IconButton(onPressed: () {
            setState(() {
              issearch = true;
            });
        }, icon: Icon(Icons.search_rounded)),
        IconButton(onPressed: () {
          showdialog();
        }, icon: Icon(Icons.logout_rounded))
      ],
        backgroundColor: Colors.pinkAccent,
      ),
      body: ListView.builder(
        itemCount: issearch ? searchlist.length : datalist.length,
        itemBuilder: (context, index) {
          Map newmap = issearch ? searchlist[index] : datalist[index];
          return Card(
            clipBehavior: Clip.antiAlias,
            elevation: 6,
            child: Container(
              height: 80,
              alignment: Alignment.center,
              child: ListTile(
                // leading: Container(
                //   margin: EdgeInsets.only(left: 5),
                //   width: 50,
                //   alignment: Alignment.centerLeft,
                //   child: Text(
                //     "${newmap['ID']}",style: TextStyle(fontSize: 18),
                //   ),
                // ),
                title: Text("${newmap['USERNAME']}",style: TextStyle(fontSize: 22),
                ),
                subtitle: Text("${newmap['PHONE']}",style: TextStyle(fontSize: 14),
                ),
                trailing: PopupMenuButton(
                  tooltip: "Operations",
                  onSelected: (value) {
                    setState(() {
                      if(value==items.update)
                      {
                        print("update");
                        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                        //   return contactupdatepage(index,datalist);
                        // },));

                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                          return updatenewcontact(index,datalist);
                        },));

                      }
                      else{
                        print("delete");
                        dbhelper().deletecontact(datalist[index]['ID'],db!);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Colors.pinkAccent,
                          content: Text("1 Record Deleted",style: TextStyle(color: Colors.white,fontSize: 18),),
                        ),
                        );
                        setState(() {
                          getdatabase();
                        });
                      }
                    });
                  },
                  itemBuilder: (context)=>[
                    const PopupMenuItem(
                      value: items.update,
                      child: Text("Update"),
                    ),
                    const PopupMenuItem(
                      value: items.delete,
                      child: Text("Delete"),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    ), onWillPop: () {
      return backonloginpage();
    },);
  }
}
