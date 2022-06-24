import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:nocotine/admin/admin_view_profile.dart';
import 'package:nocotine/constants/cofig_api.dart';
import 'package:nocotine/constants/colors.dart';
import 'package:http/http.dart' as http;
import 'package:nocotine/constants/screens.dart';
import 'package:nocotine/screens/other_profile_screen.dart';
import 'package:nocotine/screens/search_Myprofile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
class AdminUsers extends StatefulWidget {
  const AdminUsers({ Key? key }) : super(key: key);

  @override
  State<AdminUsers> createState() => _AdminUsersState();
}

class _AdminUsersState extends State<AdminUsers> {
  TextEditingController _SearchBarController=new TextEditingController();
  // This holds a list of fiction users
  // You can use data fetched from a database or a server as well
  List<Map<String, dynamic>> _allUsers = [
    
  ];

  // This list holds the data for the list view
  List<Map<String, dynamic>> _foundUsers = [];
  bool _contentVisable=true;
  @override
  initState() {
    
    
    super.initState();
    setState(() {
      
      _SearchBarController.text="";
      _runFilterInit(_SearchBarController.text);
      
    });
  }

  void _runFilterInit(String enteredKeyword) async{
    await  loadUsers();
    List<Map<String, dynamic>> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      setState(() {
        results = _allUsers;
      });
    } else {
      results = _allUsers
          .where((user) =>
              user["Name"].toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      _foundUsers = results;
    });
    _contentVisable=false;
  }
  void _runFilter(String enteredKeyword) {

  List<Map<String, dynamic>> results = [];
      if (enteredKeyword.isEmpty) {
        // if the search field is empty or only contains white-space, we'll display all users
        setState(() {
          results = _allUsers;
        });
      } else {
        results = _allUsers
            .where((user) =>
                user["Name"].toLowerCase().contains(enteredKeyword.toLowerCase()))
            .toList();
        // we use the toLowerCase() method to make it case-insensitive
      }

      // Refresh the UI
      setState(() {
        _foundUsers = results;
      });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: SafeArea(
        child: Column(
          children: [
            if(_contentVisable) Container(margin: EdgeInsets.only(top: 50), child: Center(child: Image(image: AssetImage('assets/images/loading_login.gif'),width: 50,),),) else
            Expanded(child: Column(
          children: [
            const SizedBox(
              height: 8,
            ),
            TextField(
              cursorColor: AppColor.infoyColor,
              controller: _SearchBarController,
              onChanged: (value) => _runFilter(value),
              decoration:  InputDecoration(
                prefixIcon:  IconButton(onPressed: (){
              Navigator.pushReplacementNamed(context, Screens.AdminHomeScreen.value);
            }, icon: Icon(Icons.arrow_back_ios,color: AppColor.infoyColor)),
            suffixIcon:  IconButton(onPressed: (){
              setState(() {
                _SearchBarController.text="";
                _runFilter(_SearchBarController.text);
              });
            }, icon: Icon(Icons.clear,color: AppColor.infoyColor)),
                  hintText: 'Search',
                  enabledBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          
          borderSide: BorderSide(
            color: AppColor.whiteColor,width: 4)

        ),
                  focusedBorder: UnderlineInputBorder(
          
          borderRadius: BorderRadius.circular(10),
          
          borderSide: BorderSide(
            width: 3,
            color: AppColor.whiteColor,
            
            ),
            
      )
                  ),
                  
            ),
            const SizedBox(
              height: 6,
            ),
            Divider(height: 1,thickness: 1.5,),
            Expanded(
              child:ListView.builder(
                      itemCount: _foundUsers.length,
                      itemBuilder: (context, index) => Card(
                        color: AppColor.whiteColor,
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: ListTile(
                          leading:  CircleAvatar(
                            backgroundColor: AppColor.infoyColor,
                            radius: 15,
                            backgroundImage:NetworkImage("$ImageUrl${_foundUsers[index]['image']}"),
                          ),
                          trailing: InkWell(
                            onTap: (){
                              AwesomeDialog(
                                                      context: context,
                                                      dialogType: DialogType.NO_HEADER,
                                                      animType: AnimType.BOTTOMSLIDE,
                                                      btnCancelColor: AppColor.primaryColor,
                                                      btnOkColor: AppColor.darkColor,
                                                      title: 'Delete user',
                                                      desc: 'Are you sure you want to delete this user?',
                                                      btnCancelOnPress: () {},
                                                      btnOkOnPress: () async{
                                                          removeUser(_foundUsers[index]['id'],_foundUsers[index]['email']);
                                                      },
                                                      )..show();
                              
                            },
                            child:  CircleAvatar(
                            backgroundColor: AppColor.infoyColor,
                            radius: 15,
                            backgroundImage:AssetImage("assets/images/admin_remove_user.gif"),
                          ),
                          ),
                          title: Text(_foundUsers[index]['Name'],style: TextStyle(fontWeight: FontWeight.bold),),
                          subtitle: Text(
                              '${_foundUsers[index]["email"].toString()}'),
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>AdminViewProfileScreen(userId: _foundUsers[index]['id'])));
                          },
                        ),
                      ),
                    )
                  
            )
            ],
        ),

    )
          ],
        )));
  }
  //send requst to get users data from db
  loadUsers()async{
                
  var url = Uri.parse(allUsersURl);
  var res = await http.get(url); 
    
    var responseBody=(jsonDecode(res.body) as List).map((e) => e as Map<String, dynamic>).toList();
    setState(() {
      _allUsers=responseBody;
    });

  }
  //send requst to ramove user from db
  removeUser(String UserID,String Email) async{

      var url=Uri.parse(removeUserUrl);
      var response = await http.post(url,body: {
        "user_id":UserID,
      });
      if(response.statusCode==200){
        print("Body: ${response.body}");
        sendEmailToUser(Email);
          Navigator.pushNamed(context, Screens.AdminUsersScreen.value);
          AwesomeDialog(
                  context: context,
                  dialogType: DialogType.SUCCES,
                  animType: AnimType.BOTTOMSLIDE,
                  title: 'User deleted successfully', 
                  btnOkOnPress: () {
                    
                  },
                  showCloseIcon: false,
                  
                  )..show();
      }
    
      
      }
  //send requst to send email for user deleted account
  sendEmailToUser(String Email) async{

      var url=Uri.parse(sendEmailToUserUrl);
      var response = await http.post(url,body: {
        "email":Email,
      });
      if(response.statusCode==200){
        print("Body: ${response.body}");
      
      }
    
      
      }
  


}