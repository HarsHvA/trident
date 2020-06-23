import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:trident/top_bar.dart';

class UserPage extends StatefulWidget{
  @override
  _UserPageState createState() => _UserPageState();
}
class _UserPageState extends State<UserPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
  extendBody: true,
  backgroundColor: Colors.white,
  body:   
  Wrap(
      children:<Widget>[ 
  Column(
    children: <Widget>[
      Wrap(
      children:<Widget> [
      Stack(children:<Widget>[ TopBar(),
        Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(2, 55, 2, 1),
            // TODO: Change username and image asset source to firestore
            child: Column(
              children: <Widget>[
                CircleAvatar(radius: 50,backgroundColor: Colors.white,child: CircleAvatar(radius:46,child: ClipOval(child: Image.asset("assets/default_avatar.jpg")))),
                Text("Username",style: TextStyle(fontSize: 25,color: Colors.white))
              ],
            ),
          ),
        )]),
      ]),
      Container(
          child: SafeArea(
              bottom: true, 
              top: false, 
              left: false, 
              right: false, 
              child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.only(bottom:10),
              children:  <Widget>[
                _buildListItems('Create Tournament', 0),
                _buildListItems('My Wallet', 1),
                _buildListItems('Account details', 2),
                _buildListItems('Tournament History', 3),
                _buildListItems('Help', 4),
                _buildListItems('feedback', 5),
              ],
            ),
          )),
    ],
    ),
          ]),
  );
  }

_buildListItems(label,index){
  return Container(
    child:GestureDetector(child: Card(child: ListTile(title: Text(label),)),
    onTap: (){
      Toast.show(label,context);
      // switch(index)
      // {
      //   case 0:
      //       Toast.show(label,context);
      //       break;
      //   case 1:
      //       Toast.show(label,context);
      //       break;

      //   case 2:
      //       Toast.show(label,context);
      //       break;

      //   case 3:
      //       Toast.show(label,context);
      //       break;

      //   case 4:
      //       Toast.show(label,context);
      //       break;
      //   case 5:
      //       Toast.show(label,context);
      //       break;
      //   default:
      //       Toast.show('Oops! Something went wrong',context);
      //       break;
      // }
    },)
  );
}
}