
import 'package:flutter/material.dart';
import 'main.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sample/addItemForm.dart';
import 'package:sample/searchItemForm.dart';
import 'package:sample/listItemView.dart';

final _formKey = GlobalKey<FormState>();
class home_screen extends StatelessWidget {


  String qrResult;
  final UserDetails detailsUser;

  home_screen({Key key, @required this.detailsUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GoogleSignIn _gSignIn =  GoogleSignIn();

    return new DefaultTabController(
        length: 3,
        child:  Scaffold(


          drawer: Drawer(


              child: ListView(

                children: <Widget>[

                  DrawerHeader(


                    child:Container(

                      padding: EdgeInsets.all(50.0),

                      decoration:new BoxDecoration(
                        image:new DecorationImage(
                          fit: BoxFit.contain,
                          image:NetworkImage(detailsUser.photoUrl),
                        ),

                        //borderRadius: BorderRadius.circular(8.0),
                      ),

                    ),


                    decoration: BoxDecoration(
                        gradient: LinearGradient( colors: <Color>[
                          Color(0xFF2193b0),
                          Color(0xFF6dd5ed)
                        ],

                        )

                    ),
                  ),



                  SizedBox(height:10.0),
                  Text(

                    "Name : " + detailsUser.userName,
                    style:  TextStyle(fontWeight: FontWeight.bold, color: Colors.black,fontSize: 15.0,),
                  ),
                  SizedBox(height:10.0),
                  Text(

                    "Email : " + detailsUser.userEmail,
                    style:  TextStyle(fontWeight: FontWeight.bold, color: Colors.black,fontSize: 15.0),
                  ),
                  SizedBox(height:10.0),
                  Text(
                    "Provider : " + detailsUser.providerDetails,
                    style:  TextStyle(fontWeight: FontWeight.bold, color: Colors.black,fontSize: 15.0),
                  ),
                ],

              )
          ),
          appBar:  AppBar(

            leading: Builder(

              builder: (BuildContext context) {
                return IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () { Scaffold.of(context).openDrawer(); },
                  tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                );
              },
            ),

            title:  Text('sample'),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient( colors: <Color>[
                  Color(0xFF2193b0),
                  Color(0xFF6dd5ed)
                ],
                )
              ),
            ),
            automaticallyImplyLeading: false,
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  FontAwesomeIcons.signOutAlt,
                  size: 20.0,
                  color: Colors.white,
                ),
                onPressed: (){
                  _gSignIn.signOut();

                  print('Signed out');
                  Navigator.pop(context);
                },
              ),
            ],

            bottom: new TabBar(
                tabs: <Widget>[
                    Tab(icon : new Icon(Icons.add),text: 'Add Items',),
                    Tab(icon: new Icon(Icons.search),text: 'Search Items',),
                    Tab(icon: new Icon(Icons.list),text: 'Added Items',)
                ],
            ),
          ),
            body :new TabBarView(

                children: <Widget>[
                  addItemForm(),
                  searchItemForm(),
                  listItemView(),
                ]
            )
        )

    );
  }
}


