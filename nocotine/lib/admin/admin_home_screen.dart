import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:badges/badges.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:nocotine/constants/cofig_api.dart';
import 'package:nocotine/constants/colors.dart';
import 'package:nocotine/constants/screens.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({ Key? key }) : super(key: key);

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  List HomePageItems=[
    {
      "id":1,
      "Name":"View users",
      "Image":"assets/images/admin_users.png"
    },
    {
      "id":2,
      "Name":"View posts",
      "Image":"assets/images/Admin_posts.png"
    },
    { 
      "id":3,
      "Name":"View competitions",
      "Image":"assets/images/Admin_competition.png"
    },
    { 
      "id":4,
      "Name":"View feedback",
      "Image":"assets/images/Admin_feedback.png"
    },
    { 
      "id":5,
      "Name":"Edit books",
      "Image":"assets/images/Admin_books.png"
    },
  ];
  final GlobalKey<FormState> _formKeyPassword = GlobalKey<FormState>();
  TextEditingController _NewConfirmPasswordController=new TextEditingController();
  TextEditingController _NewPasswordController=new TextEditingController();
  String CheckPassword="";
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  var CountNotification="";
  bool ShowCountNotification=true;
  @override
  void initState() {
    setState(() {
      getCountNotification();
    });
    super.initState();
  updateToken();
    //if app is open
    FirebaseMessaging.onMessage.listen((event) {
      getCountNotification();
      print("=====================>onMessage<============");
      print(event.notification?.title);
      print(event.notification?.body);
      Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      isDismissible:false,
      duration: Duration(seconds: 2),
      message: "${event.notification?.body}",
      messageSize: 12,
      backgroundGradient: LinearGradient(colors: [AppColor.primaryColor,AppColor.lightprimaryColor,]),
      boxShadows: [BoxShadow(color: AppColor.primaryColor, offset: Offset(0.0, 2.0), blurRadius: 3.0,)],
      
    )..show(context);
        });
    //if app is in wait
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      getCountNotification();
      Navigator.pushReplacementNamed(context, Screens.notification.value);
    });
  }
  //هاي فنكشن عشان اعمل بيرمشن للايفون بس عشان اقدر اطلع النتفكيشن
  Future chekAppNotifcation()async{
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }
  //send requst to update my token
  updateToken() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
      
      var _userId=preferences.getString(id);
      var url=Uri.parse(updateTokenURL);
      _fcm.getToken().then((token) async{
        preferences.setString(myToken, token!);
      var response = await http.post(url,body: {
        "token":token,
        "user_id":_userId
      });
      if(response.statusCode==200){
      print(response.body);
      }
    });
      }
  
  @override
  Widget build(BuildContext context) {
  var size = MediaQuery.of(context).size;
  final double itemHeight = (size.height) / 3.53;
  final double itemWidth = size.width / 1;
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
      automaticallyImplyLeading: false,
      centerTitle: true,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.smoke_free),
          SizedBox(width: 8,),
          Text('NOcotine'),
        ],
      ),
      leading:PopupMenuButton(
                              
                                icon: Icon(Icons.settings,color: AppColor.whiteColor,),
                                shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10.0))
                            ),
                                      itemBuilder: (context) => [
                                        PopupMenuItem(
                                          child: Column(
                                            children: [
                                                ChangePassword(),
                                                Divider(thickness: 1.2,),
                                                InkWell(
                                                  child: Container(
                                                    margin: EdgeInsets.only(top: 8,bottom: 8),
                                                    child: Row(
                                                    children: [
                                                      Icon(Icons.logout,color: Colors.grey,),
                                                  SizedBox(width: 15,),
                                                  Text("Log out",style: TextStyle(color: Colors.grey),),
                                                    ],
                                                  ),),
                                                  onTap: (){
                                                    AwesomeDialog(
                                                      context: context,
                                                      dialogType: DialogType.NO_HEADER,
                                                      animType: AnimType.BOTTOMSLIDE,
                                                      btnCancelColor: AppColor.primaryColor,
                                                      btnOkColor: AppColor.darkColor,
                                                      title: 'Log Out',
                                                      desc: 'Are you sure you want to log out?',
                                                      btnCancelOnPress: () {},
                                                      btnOkOnPress: () async{
                                                        SharedPreferences preferences = await SharedPreferences.getInstance();
                                                        await preferences.clear();
                                                        Navigator.pushReplacementNamed(context, Screens.root.value);
                                                      },
                                                      )..show();
                                                  },
                                                ),
                                                  

                                            ],
                                          ),
                                          value: 1,
                                          
                                        ),
                                        
                                        
                                      ]
                                  ),
      actions: [
        FutureBuilder(
              future: getCountNotification(),
              builder: (context,snapshot){
                if(snapshot.hasData){
                  if(CountNotification=="0"){
                    ShowCountNotification=false;
                  }else{
                    ShowCountNotification=true;
                  }
                  return  Container(
                    margin: EdgeInsets.only(right: 5),
                    child: IconButton(onPressed: (){
                    resetCountNotification();
                    Navigator.pushNamed(context, Screens.AdminNotificationScreen.value);
                    
                  }, icon: Badge(
                      showBadge:ShowCountNotification,
                      toAnimate: true,
                      badgeContent: Text('$CountNotification'),
                      animationType: BadgeAnimationType.scale,
                      child: Icon(Icons.notifications),
                    )),
                  );
                }
                else{
                  return  Container(
                    margin: EdgeInsets.only(right: 5),
                    child: IconButton(onPressed: (){
                    resetCountNotification();
                    Navigator.pushNamed(context, Screens.AdminNotificationScreen.value);
                    
                  }, icon: Badge(
                      showBadge:false,
                      toAnimate: true,
                      badgeContent: Text(''),
                      animationType: BadgeAnimationType.scale,
                      child: Icon(Icons.notifications),
                    )),
                  );;
                }
              },
            ),
      ],
      backgroundColor: AppColor.darkColor,
    ),
    body: GridView.builder(
                itemCount: HomePageItems.length,
                padding: EdgeInsets.all(5),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 5,
                  childAspectRatio: (itemWidth / itemHeight),
                ),
                itemBuilder: (context,index){
                  return InkWell(
      onTap: (){
          if(HomePageItems[index]['id']==1){
          Navigator.pushNamed(context, Screens.AdminUsersScreen.value);
        }else if(HomePageItems[index]['id']==2){
          Navigator.pushNamed(context, Screens.AdminPostsScreen.value);
        }else if(HomePageItems[index]['id']==3){
          Navigator.pushNamed(context, Screens.AdminCompetitionScreen.value);
        }else if(HomePageItems[index]['id']==4){
          Navigator.pushNamed(context, Screens.AdminFeedbackScreen.value);
        }else if(HomePageItems[index]['id']==5){
          Navigator.pushNamed(context, Screens.AdminEditBooks.value);
        }
      },
      child: GridTile(
        
        child: Image.asset("${HomePageItems[index]['Image']}",fit: BoxFit.contain,),
        footer: Container(
          width: double.infinity,
          height: itemHeight,
          color: AppColor.blackTransparentColor,
          child: Align(
            alignment: Alignment.center,
            child: Text("${HomePageItems[index]['Name']}", style: TextStyle(
              color: Colors.white,
              fontFamily: 'Baloo 2',
              fontSize: 25,
              fontWeight: FontWeight.w700,
              shadows: [
                Shadow(color: AppColor.blackColor,blurRadius: 20)
              ]
            ),),
          ),
        )
        
      ),
    );
                }),
    );
  }
  //change admin password widget
  Widget ChangePassword(){
    return InkWell(
            child: Container(
                      margin: EdgeInsets.only(top: 8,bottom: 8),
                      child: Row(
                      children: [
                        Icon(Icons.vpn_key,color: Colors.grey,),
                    SizedBox(width: 15,),
                    Text("Change password",style: TextStyle(color: Colors.grey),),
                      ],
              ),),
              onTap: (){
              AwesomeDialog(
                  context: context,
                  dialogType: DialogType.NO_HEADER,
                  animType: AnimType.BOTTOMSLIDE,
                  btnCancelColor: AppColor.primaryColor,
                  btnOkColor: AppColor.darkColor,
                  showCloseIcon: false,
                  btnOkText: "Save",
                  body: Form(
                    key: _formKeyPassword,
                    child: Container(
                    padding: EdgeInsets.all(20),
                    child: Column(
                    
                      children: <Widget>[
                        TextFormField(
                          obscureText: true,
                          controller: _NewPasswordController,
                          validator: (value) {
                          var pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$';
                              RegExp regex = new RegExp(pattern);
                              
                              if (value!.isEmpty)
                                return 'Required';
                                
                              else if(!regex.hasMatch(value))
                                return 'Password must contain at least \n8 characters, one digit, one upper case \nand one lower case letter';
                              else
                                  setState(() {
                                    CheckPassword=value;
                                  });
                                return null;
                            
                          
                        },
                          decoration: InputDecoration(
                            labelText: "New Password",
                            
                            labelStyle: TextStyle(color: AppColor.infoyColor),
                            filled: true,
                            fillColor: AppColor.whiteColor,
                            enabledBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: AppColor.darkColor,width: 4)
                              ),
                            focusedBorder: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                width: 3,
                                color: AppColor.primaryColor,
                              ),
                    ),
                          ),
                        ),
                      
                        TextFormField(
                          controller: _NewConfirmPasswordController,
                          validator: (value) {
                              
                              if (value!.isEmpty)
                                return 'Required';
                                
                              else if(value!=CheckPassword)
                                return 'Password Not Match';
                              else
                                return null;
                            
                          
                        },
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: "Confirm Password",
                            labelStyle: TextStyle(color: AppColor.infoyColor),
                            filled: true,
                            fillColor: AppColor.whiteColor,
                            enabledBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: AppColor.darkColor,width: 4)
                              ),
                            focusedBorder: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                width: 3,
                                color: AppColor.primaryColor,
                              ),
                    ),
                          ),
                        ),
                      SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                        
                      InkWell(
                        child: Container(
                          padding: EdgeInsets.all(10),
                          width: 120,
                          child: Center(child: Text("Cancel",style: TextStyle(color: AppColor.whiteColor,fontWeight: FontWeight.bold),)),
                          decoration: BoxDecoration(
                              color: AppColor.primaryColor,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15),
                                    bottomLeft: Radius.circular(15),
                                    bottomRight: Radius.circular(15),
                                ),
                          
                          )),
                        onTap: (){
                          _NewPasswordController.text="";
                          _NewConfirmPasswordController.text="";
                          Navigator.of(context).pop();
                        }
                      ),
                        InkWell(
                        child: Container(
                          padding: EdgeInsets.all(10),
                          width: 120,
                          child: Center(child: Text("Save",style: TextStyle(color: AppColor.whiteColor,fontWeight: FontWeight.bold),)),
                          decoration: BoxDecoration(
                              color: AppColor.darkColor,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15),
                                    bottomLeft: Radius.circular(15),
                                    bottomRight: Radius.circular(15),
                                ),
                          
                          )),
                        onTap: (){
                            if (_formKeyPassword.currentState!.validate()) {
                              updatePassword();
                              Navigator.of(context).pop();
                        }}
                      ),
                    
                        ],
                      )
                      ],
                    ),
                  
                  
                  ),
                  
                  
                  
                  ),
                  )..show();
              
              },
            
                                                );
  }
  //send request to change admin password
  updatePassword() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
      
      var _userId=preferences.getString(id);
      var url=Uri.parse(updatePasswordURL);
      if(_NewPasswordController.text.isEmpty||_NewConfirmPasswordController.text.isEmpty){
        AwesomeDialog(
                      context: context,
                      dialogType: DialogType.WARNING,
                      animType: AnimType.BOTTOMSLIDE,
                      title: 'Empty feild', 
                      btnOkOnPress: () {},
                      showCloseIcon: false
                      
                      )..show();
        return;
      }
      var response = await http.post(url,body: {
        "password":_NewPasswordController.text,
        "conf_password":_NewConfirmPasswordController.text,
        "user_id":_userId
      });
      print(response.statusCode);
      if(response.statusCode==200){
      AwesomeDialog(
                      context: context,
                      dialogType: DialogType.SUCCES,
                      animType: AnimType.BOTTOMSLIDE,
                      title: 'Password changed', 
                      btnOkOnPress: () {},
                      showCloseIcon: false
                      
                      )..show();
      }
      
      
      
      
      }
  //send requst to get admin notification counter
  getCountNotification() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
      
      var _userId=preferences.getString(id);
      var url=Uri.parse(getCountNotificationUrl);
      var response = await http.post(url,body: {
        "user_id":_userId
      });
      var res=jsonDecode(response.body);
      if(response.statusCode==200){
      //print(res[0]['count_notification']);
      setState(() {
        CountNotification=res[0]['count_notification'];
      });
      } 
      return CountNotification.toString();
      }
  //send requst to reset admin notification counter if click notification icon
  resetCountNotification() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
      
      var _userId=preferences.getString(id);
      var url=Uri.parse(resetCountNotificationUrl);
      var response = await http.post(url,body: {
        "user_id":_userId,
      });
    
      if(response.statusCode==200){
        setState(() {
          print(response.body);

          
        });
        
      }
    
      
      }
  
}