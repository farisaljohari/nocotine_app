import 'dart:convert';
import 'dart:ffi';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:nocotine/constants/cofig_api.dart';
import 'package:nocotine/constants/colors.dart';
import 'package:nocotine/constants/screens.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter_svg/avd.dart';
import 'package:flutter_svg/flutter_svg.dart';
class SearchProfileScreen extends StatefulWidget {
    SearchProfileScreen({ Key? key }) : super(key: key);

  @override
  _SearchProfileScreenState createState() => _SearchProfileScreenState();
}

class _SearchProfileScreenState extends State<SearchProfileScreen> {
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
  final String assetName = 'assets/images/pack.svg';
  @override
  void initState() {
    
      getUserData();
    setState(() {
      _loadTotalPosts();
      _loadTotalwins();
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body:SafeArea(child:  SingleChildScrollView(
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                    SizedBox(width: 15,),
                    InkWell(
                      child:Icon(Icons.arrow_back_ios,color: AppColor.whiteColor,),
                      onTap: (){
                        Navigator.pop(context);
                      },
                    ),
                    InkWell(
                      child:Icon(Icons.settings_outlined,color: AppColor.whiteColor,),
                      onTap: (){
                          Navigator.pushNamed(context, Screens.AccountSettings.value);
                      },
                    )
                    ],
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
                        title: 'Log out',
                        desc: 'Are you sure you want to log out?',
                        btnCancelOnPress: () {},
                        btnOkOnPress: () {
                          Navigator.pushReplacementNamed(context, Screens.root.value);
                        },
                        )..show();
                    }, icon: Icon(Icons.logout,color: AppColor.whiteColor,)),
                    ),
                  ],
                ),
                SizedBox(height: 20,),
                FutureBuilder(
                  future: getUserData(),
                    
                    builder: (context,snapshot){
                        return Column(
                          children: [
                            
                            Container(
                              child: getProfileImage(),
                            ),
                            
                            SizedBox(height: 20,),
                            Text("$_Name",style: TextStyle(fontSize: 25,fontFamily: 'Baloo 2',fontWeight: FontWeight.w500,color: AppColor.whiteColor),),
                            Container(
                              margin: EdgeInsets.only(left: 30,right: 30),
                              child: Text("$Bio",style: TextStyle(fontSize: 15,fontFamily: 'Baloo 2',color: AppColor.whiteColor),),
                            ),
                            SizedBox(height: 20,),
                            Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      child: Column(
                  children: [
                    Text("$TotalPosts",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: AppColor.whiteColor),),
                    Text("Posts",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: AppColor.whiteColor),),
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
                        );
              }
                ),

                
                
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
  

  //get user from shared prefrence
  getUserData() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      var _firstName;
      var _lastName;
      var _image;
      var _age;
      var _gender;
      var _NoOfCigarette;
      var _bio;
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
    });
  }
  //my profile picture widget
  Widget getProfileImage() {
    return CircleAvatar(
                    backgroundImage: NetworkImage("$ImageUrl$dec"),
                    backgroundColor: AppColor.whiteColor,
                    radius: 60,
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
    setState(() {
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
    var _userID=preferences.getString(id);
    var url = Uri.parse(countWinUrl);
    var response = await http.post(url,body: {
        "win_id":_userID,
      });
    var responseBody = jsonDecode(response.body);
    setState(() {
      TotalWins=responseBody;
    });
  }
}