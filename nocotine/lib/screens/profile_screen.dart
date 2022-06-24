import 'dart:convert';
import 'dart:ffi';
import 'package:another_flushbar/flushbar.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:nocotine/constants/cofig_api.dart';
import 'package:nocotine/constants/colors.dart';
import 'package:nocotine/constants/screens.dart';
import 'package:flutter/material.dart';
import 'package:nocotine/screens/edit_profile_picture.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter_svg/avd.dart';
import 'package:flutter_svg/flutter_svg.dart';
class ProfileScreen extends StatefulWidget {
    ProfileScreen({ Key? key }) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var _Name="";
  var _UserId;
  bool _visbleLike=false;
  bool _visableGender=true;
  var _userId;
  String dec="loadingImage.gif";
  String Age="";
  String Gender="Male";
  double NumOfCigarette=0.0;
  String Bio="";
  var TotalPosts="0";
  var TotalWins="0";
  String SaveBio="Bio";
  String FirstName="";
  String LastName="";
  final String assetName = 'assets/images/pack.svg';
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  TextEditingController _BioController=new TextEditingController();
  TextEditingController _NewFirstNameController=new TextEditingController();
  TextEditingController _NewLastNameController=new TextEditingController();
  final GlobalKey<FormState> _formKeyName = GlobalKey<FormState>();
  @override
  void initState() {
    
      getUserData();
    setState(() {
      getLastData();
      _loadTotalPosts();
      _loadTotalwins();
      chekAppNotifcation();
    });
    super.initState();
    updateToken();
    //if app is open
    FirebaseMessaging.onMessage.listen((event) {
      print("=====================>onMessage<============");
      print(event.notification?.title);
      print(event.notification?.body);
      // AwesomeDialog(
      //   context: context,
      //   dialogType: DialogType.INFO,
      //   animType: AnimType.BOTTOMSLIDE,
      //   title: event.notification?.title,
      //   desc: event.notification?.body,
      //   btnCancelOnPress: () {},
      //   btnOkOnPress: () {},
      // )..show();
      Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      isDismissible:false,
      duration: Duration(seconds: 2),
      title: "${event.notification?.title}",
      message: "${event.notification?.body}",
      backgroundGradient: LinearGradient(colors: [AppColor.primaryColor,AppColor.lightprimaryColor,]),
      boxShadows: [BoxShadow(color: AppColor.primaryColor, offset: Offset(0.0, 2.0), blurRadius: 3.0,)],
      
    )..show(context);
        });
    //if app is in wait
    FirebaseMessaging.onMessageOpenedApp.listen((event) {

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
    
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: SafeArea(child: SingleChildScrollView(
        child: Column(
          children: [
            Align(
              alignment: Alignment.center,
              child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColor.primaryColor,
              AppColor.lightprimaryColor,
            ],
          )),
              child:
              Column(
                children:[
                  SizedBox(height: 9,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 10),
                      child: IconButton(onPressed: (){
                      Navigator.pushNamed(context, Screens.AccountSettings.value);
                    }, icon: Icon(Icons.settings_outlined,color: AppColor.whiteColor,)),
                    ),
                  Container(
                      padding: EdgeInsets.only(right: 10),
                      child: IconButton(onPressed: (){
                      
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
                    }, icon: Icon(Icons.logout,color: AppColor.whiteColor,)),
                    ),
                  ],
                ),
                SizedBox(height: 10,),
                Column(
                          children: [
                            InkWell(
                              child: Stack(
                                      children: [
                                        CircleAvatar(
                                          radius: 75,
                                          backgroundColor:AppColor.whiteColor,
                                          child: getProfileImage()
                                        ),
                                        Positioned(
                                          right: 2,
                                          bottom: 5,
                                          child: CircleAvatar(
                                            backgroundColor: AppColor.whiteColor,
                                            radius: 21,
                                            child: CircleAvatar(
                                              radius: 20,
                                            backgroundColor: Color.fromARGB(255, 208, 208, 208),
                                            child: const Icon(
                                              Icons.camera_enhance,
                                              color:AppColor.blackColor,
                                              size: 20,
                                            ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                              onTap: (){
                                Navigator.pushNamed(context, Screens.EditProfilePicture.value);
                              },
                            ),
      
                            
                            SizedBox(height: 20,),
                            ChangeName(),
                            pobubBio(),
                            SizedBox(height: 20,),
                            Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      child: Column(
                  children: [
                    Text("$TotalPosts",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: AppColor.whiteColor),),
                    Text("Posts",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: AppColor.whiteColor),),
                    //Icon(Icons.mode_comment,color: AppColor.whiteColor,size: 20,)
                  ],
                ),
                      onTap: (){
                        Navigator.pushNamed(context, Screens.Posts.value);
                      },
                    ),
                    SizedBox(),
                    Column(
                  children: [
                    Text("$TotalWins",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: AppColor.whiteColor),),
                    Text("Achievements",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: AppColor.whiteColor),),
                    
                  ],
                )
                  
                  ],
                ),
                            SizedBox(height: 20,),
                            Container(
                              color: AppColor.whiteColor,
                              child: Column(
                                children: [
                                  Container(
                  height: 55,
                  child: Card(
                  
                  child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(Icons.date_range,size: 22,color: AppColor.infoyColor,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("derrrr",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: AppColor.transpartntColor),),
                        Text("Age",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: AppColor.infoyColor),),
                        Text("derrrr",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: AppColor.transpartntColor),),
                      ],
                    ),
                    Text("$Age",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: AppColor.infoyColor),),
                  ],
                ),
                ),
                ),
                                  Container(
                  height: 55,
                  child: Card(
                  
                  child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    

                  if(_visableGender) Container(child: Icon(Icons.male,size: 26,color: AppColor.infoyColor,),)
                  else
                    Container(child: Icon(Icons.female,size: 26,color: AppColor.infoyColor,),),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("derr",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: AppColor.transpartntColor),),
                        Text("Gender",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: AppColor.infoyColor),),
                        Text("derrr",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: AppColor.transpartntColor),),
                      ],
                    ),
                    Text("${Gender[0]}",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: AppColor.infoyColor),),
                  ],
                ),
                ),
                ),
                                  Container(
                  height: 55,
                  child: Card(
                  
                  child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                  Container(
                      child: SvgPicture.asset(

                          assetName,
                          width: 25,
                          height: 25,
                          color: AppColor.infoyColor,
                        )
                    ),
                    Row(
                      children: [
                        Text("No of cigarettes",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: AppColor.infoyColor),),
                        
                      ],
                    ),
                    Text("${NumOfCigarette.toInt()}",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: AppColor.infoyColor),),
                  ],
                ),
                ),
                ),
              
                                ],
                              ),
                            )
                          ],
                        )
              
                

                
                
                  ]
                ),
              ),
            
              
              ],
                ),
          
          
          
          ),
        
          ],
        ),
      ),
    
    )
    
    
    );
  }
  
  //change name widget
  Widget ChangeName(){
    
                            
    return InkWell(
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                              elevation: 4,
                              color: Colors.white,
                              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                              child: Container(
                                width: double.infinity,
                                child: ListTile(
                                trailing: Icon(
                                  Icons.edit,
                                  color: AppColor.primaryColor,
                                ),
                                
                                title: Center(child: Text("$_Name",style: TextStyle(fontSize: 20,fontFamily: 'Baloo 2',fontWeight: FontWeight.w500,color: AppColor.primaryColor),textAlign: TextAlign.center,),),
                              )
                                )
                                ),
                              onTap: (){
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.NO_HEADER,
                  animType: AnimType.BOTTOMSLIDE,
                  btnCancelColor: AppColor.primaryColor,
                  btnOkColor: AppColor.darkColor,
                  btnOkText: "Save",
                  body: Form(
                    key: _formKeyName,
                    child: Container(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          controller: _NewFirstNameController,
                          validator: (value) {
                          var pattern = r'[A-Za-z]{2,}$';
                              RegExp regex = new RegExp(pattern);
                              
                              if (value!.isEmpty)
                                return 'Required';
                                
                              else if(!regex.hasMatch(value))
                                return 'Enter Valid First Name';
                              else
                                return null;
                            
                          
                        },
                        
                          decoration: InputDecoration(
                            labelText: "New First Name",
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
                          controller: _NewLastNameController,
                          validator: (value) {
                          var pattern = r'[A-Za-z]{2,}$';
                              RegExp regex = new RegExp(pattern);
                              
                              if (value!.isEmpty)
                                return 'Required';
                                
                              else if(!regex.hasMatch(value))
                                return 'Enter Valid Last Name';
                              else
                                return null;
                            
                          
                        },
                          decoration: InputDecoration(
                            labelText: "New Last Name",
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
                            setState(() {
                          getLastData();
                          Navigator.of(context).pop();
                        });
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
                            if (_formKeyName.currentState!.validate()) {
                              updateName();
                              Navigator.of(context).pop();
                        }}
                      ),
                    
                        ],
                      )
                      ],),
                  
                  ),
                  
                  
                  ),
                  )..show();
              },
            
                            );
  }
  //send request to change name
  updateName() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
      
      var _userId=preferences.getString(id);
      var url=Uri.parse(updateNameURL);
      if(_NewFirstNameController.text.isEmpty||_NewLastNameController.text.isEmpty){
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
        "first_name":_NewFirstNameController.text,
        "last_name":_NewLastNameController.text,
        "user_id":_userId
      });
      if(response.statusCode==200){
        setState(() {
          _Name="${_NewFirstNameController.text} ${_NewLastNameController.text}";
        });
        SharedPreferences preferences = await SharedPreferences.getInstance();
      // Save response
      preferences.setString(firstName, _NewFirstNameController.text);
      preferences.setString(lastName, _NewLastNameController.text);
      AwesomeDialog(
                      context: context,
                      dialogType: DialogType.SUCCES,
                      animType: AnimType.BOTTOMSLIDE,
                      title: 'Name changed', 
                      btnOkOnPress: () {},
                      showCloseIcon: false
                      
                      )..show();
      }
      
      
      
      
      }
  //get my data from shared prefrence
  getLastData() async{
        SharedPreferences preferences = await SharedPreferences.getInstance();
      var _fname;
      var _lname;
      var _lastBirthDate;
      var _numPackets;
      var _pricePackets;
      setState(() {
        _fname=preferences.getString(firstName);
        FirstName=_fname;
        _lname=preferences.getString(lastName);
        LastName=_lname;
        _NewFirstNameController..text = FirstName;
        _NewLastNameController..text = LastName;
        _numPackets=preferences.getDouble(num_packets);
        
        
      });
  }
  //get user from shared prefrence
  getUserData() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt(routeIndex, 0);
    setState(() {
      var _firstName;
      var _lastName;
      var _image;
      var _age;
      var _gender;
      var _NoOfCigarette;
      var _bio;
        _NewFirstNameController..text = FirstName;
        _NewLastNameController..text = LastName;
      _firstName=preferences.getString(firstName);
      _lastName=preferences.getString(lastName);
      _Name="$_firstName $_lastName";
      _UserId=preferences.getString(id);
      _image=preferences.getString(image);
        dec=_image;
      _bio=preferences.getString(bio);
      _age=preferences.getString(age);
      _gender=preferences.getString(gender);
      _NoOfCigarette=preferences.getDouble(num_packets);
      Age=_age;
      Gender=_gender;
      if(Gender[0]=="M"){
        _visableGender=true;
      }else{
        _visableGender=false;
      }
      NumOfCigarette=_NoOfCigarette*20;
      Bio=_bio;
      if(Bio!=null&&Bio.isNotEmpty){
        SaveBio=Bio;
      }else if(Bio==""){
        setState(() {
          SaveBio="Edit Bio..";
        });
      }
      
    });
  }
  //my profile picture view and edit widget
  Widget getProfileImage() {
    return CircleAvatar(
                    
                    backgroundImage: NetworkImage("$ImageUrl$dec"),
                    backgroundColor: AppColor.whiteColor,
                    radius: 70,
                  );
  }
  //send requst to get total number posts  for this user 
  _loadTotalPosts()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var _userID=preferences.getString(id);
    var url = Uri.parse(totalPostsURL);
    var response = await http.post(url,body: {
        "user_id":_userID,
      });
    var responseBody = jsonDecode(response.body);
    if(mounted)setState(() {
      TotalPosts=responseBody;
    });
  }
  //save post id to go anthor page
  _SavePostID(BuildContext context,String _postid) async{
    
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // Save response
    
    preferences.setString(post_id, _postid);
    // push to home screen
    Navigator.pushNamed(context, Screens.comments.value);
    
  }
  //send requst to get total winner for this user 
  _loadTotalwins()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    _userId=preferences.getString(id);
    var url = Uri.parse(countWinUrl);
    var response = await http.post(url,body: {
        "win_id":_userId,
      });
    var responseBody = jsonDecode(response.body);
    if(mounted)setState(() {
      TotalWins=responseBody;
    });
  }
  //change Bio widget
  Widget pobubBio(){
    return InkWell(
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                              elevation: 4,
                              color: Colors.white,
                              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                              child: Container(
                                width: double.infinity,
                                child: ListTile(
                                trailing: Icon(
                                  Icons.edit,
                                  color: AppColor.primaryColor,
                                ),
                                
                                title: Center(child: new Text("$SaveBio",style: TextStyle(color: AppColor.primaryColor), )),
                              )
                                )
                                ),
                                onTap: (){
                                  Alert(
                    context: context,
                    content: Column(
                      children: <Widget>[
                        TextField(
                          controller: _BioController,
                          decoration: InputDecoration(
                            
                            labelText: 'Enter Your Bio..',
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
                          maxLength: 40,
                        ),
                      ],
                    ),
                    buttons: [
                      DialogButton(
                        color: AppColor.primaryColor,
                        onPressed: () {
                          setState((){
                            saveBio();
                          });
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Save",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      )
                        ]).show();
                                },
                            );
  }
  //save new bio
  saveBio()async{
    SaveBio=_BioController.text;
                            await updateBio();
                            if(SaveBio.isEmpty){
                                setState(() {
                                  SaveBio="Edit Bio..";
                                });
                            }

  }
  //send request to change Bio
  updateBio() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
      
      var _userId=preferences.getString(id);
      var url=Uri.parse(updateBioURL);
      var response = await http.post(url,body: {
        "bio":SaveBio,
        "user_id":_userId
      });
      
      if(response.statusCode==200){
        SharedPreferences preferences = await SharedPreferences.getInstance();
      // Save response
      preferences.setString(bio, _BioController.text);
      AwesomeDialog(
                      context: context,
                      dialogType: DialogType.SUCCES,
                      animType: AnimType.BOTTOMSLIDE,
                      title: 'Bio changed', 
                      btnOkOnPress: () {},
                      showCloseIcon: false
                      
                      )..show();
      }
      
      
      
      
      }

}