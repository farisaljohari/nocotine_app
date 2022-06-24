import 'dart:convert';
import 'package:nocotine/screens/game_home_page.dart';
import 'package:nocotine/screens/other_profile_screen.dart';
import 'package:nocotine/screens/search_Myprofile_screen.dart';
import 'package:nocotine/screens/important_question_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nocotine/constants/cofig_api.dart';
import 'package:nocotine/constants/colors.dart';
import 'package:nocotine/constants/screens.dart';
import 'package:nocotine/screens/account_settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_helper.dart';
import 'package:another_flushbar/flushbar_route.dart';
import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
class HomeScreen extends StatefulWidget {
  
  const HomeScreen({ Key? key }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
  
}

class _HomeScreenState extends State<HomeScreen> {
  var CountNotification="";
  int cigaritNumber=0;
  double saveDoller=0;
  double saveHealth=0;
  bool _visbleLike=false;
  bool _visblePostMore=true;
  var _userId;
  String numberOfLikes="";
  String PostId="";
  List veiwPostList=[];
  List veiwPostList2=[];
  List visableLikes=[];
  List SmokingCounterList=[];
  var priceOfOneCigaritte;
  String _feeling="";
  bool ShowCountNotification=true;
  bool ShowProgress=false;
  String PostID="";
  String UserIdPost="";
  double SaveLife=0;
  TextEditingController _PostController=new TextEditingController();
  int AdminID=59;
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  var SaveHelthCounter="00:00:00";
  @override
  void initState() {
    setState(() {
      getUserID();
      _loadSmokingCounter();
      loadPosts();
      chekAppNotifcation();
      getCountNotification();
      loadAdminToken();
    });
    super.initState();
    updateToken();
    //if app is open
    FirebaseMessaging.onMessage.listen((event) {
      print("=====================>onMessage<============");
      print(event.notification?.title);
      print(event.notification?.body);
      
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
    bool _enabled = true;
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
      leading: IconButton(onPressed: (){
          Navigator.pushNamed(context, Screens.searchbar.value);
          
        }, icon: const Icon(Icons.search)),
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
                    Navigator.pushNamed(context, Screens.notification.value);
                    
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
                    Navigator.pushNamed(context, Screens.notification.value);
                    
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
      body: SingleChildScrollView(
        child: Container(
        child: Column(
          children: [
            SmokingCounter(),
            buttonsCounter(),
            PostBar(),
            Container(
            margin: EdgeInsets.only(top: 15),
            width: double.infinity,
            child: FutureBuilder(
              future: loadPosts(),
              builder: (context,snapshot){
                if(snapshot.hasData){
                  if(ShowProgress){
                    return ListView.builder(
                    
                    reverse: true,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    
                      itemCount: veiwPostList.length,
                      itemBuilder: (context, index) {
                        if(veiwPostList[index]['feeling'].toString().isNotEmpty){
                          
                            _feeling="is feeling";
                        }else{
                          _feeling="";
                        }
                        if(veiwPostList[index]['id']==_userId){
                                    _visblePostMore=true;
                        }else{
                                    _visblePostMore=false;
                        
                        }
                      return  InkWell(
                        child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 15,right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(children: [
                                  InkWell(
                                  
                                    child: Row(
                                      children: [
                                      CircleAvatar(
                                        backgroundColor: AppColor.infoyColor,
                                        radius: 15,
                                        backgroundImage:NetworkImage("$ImageUrl${veiwPostList[index]['image']}"),
                                      ),
                                      SizedBox(width: 10,),
                                      Text("${veiwPostList[index]['first_name']} ${veiwPostList[index]['last_name']} ",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),)
                                    ],),
                                    onTap: ()async{
                                      //TODO
                                      SharedPreferences preferences = await SharedPreferences.getInstance();
                                      if(veiwPostList[index]['id']==preferences.getString(id)){
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchProfileScreen()));
                                      }else{
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=>OtherProfileScreen(userId: veiwPostList[index]['id'])));
                                      }
                                    },
                                  ),
                                  Text("$_feeling"),
                            Text(" ${veiwPostList[index]['feeling']}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                          
                            ],),
                            if(_visblePostMore) Flexible(child:PopupMenuButton(
                              
                                icon: Icon(Icons.more_vert,color: AppColor.infoyColor,),
                                shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10.0))
                            ),
                                      itemBuilder: (context) => [
                                        PopupMenuItem(
                                          child: Column(
                                            children: [
                                            InkWell(
                                                  child: Container(
                                                    margin: EdgeInsets.only(top: 8,bottom: 8),
                                                    child: Row(
                                                    children: [
                                                      Icon(Icons.visibility,color: Colors.grey,),
                                                  SizedBox(width: 15,),
                                                  Text("View",style: TextStyle(color: Colors.grey),),
                                                    ],
                                                  ),),
                                                  onTap: (){
                                                    SavePostID(context, veiwPostList[index]['post_id'],veiwPostList[index]['id']);
                                                  },
                                                ),
                                                Divider(thickness: 1.2,),
                                                InkWell(
                                                  child: Container(
                                                    margin: EdgeInsets.only(top: 8,bottom: 8),
                                                    child: Row(
                                                    children: [
                                                      Icon(Icons.delete,color: Colors.grey,),
                                                  SizedBox(width: 15,),
                                                  Text("Delete",style: TextStyle(color: Colors.grey),),
                                                    ],
                                                  ),),
                                                  onTap: (){
                                                    AwesomeDialog(
                                                    context: context,
                                                    dialogType: DialogType.NO_HEADER,
                                                    animType: AnimType.BOTTOMSLIDE,
                                                    btnCancelColor: AppColor.primaryColor,
                                                    btnOkColor: AppColor.darkColor,
                                                    title: 'Delete post',
                                                    desc: 'Are you sure you want to delete this post?',
                                                    btnCancelOnPress: () {},
                                                    btnOkOnPress: () async{
                                                      deletePost(veiwPostList[index]['post_id']);
                                                      Navigator.pop(context);
                                                    },
                                                    )..show();
                                                  },
                                                ),
                                                  

                                            ],
                                          ),
                                          value: 1,
                                          
                                        ),
                                        
                                        
                                      ]
                                  )
                                
                                                  
                                                  )else Flexible(child: PopupMenuButton(
                                    icon: Icon(Icons.more_vert,color: AppColor.infoyColor,),
                                    shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10.0))
                            ),
                                      itemBuilder: (context) => [
                                        PopupMenuItem(
                                          child: Column(
                                            children: [
                                          InkWell(
                                                  child: Container(
                                                    margin: EdgeInsets.only(top: 8,bottom: 8),
                                                    child: Row(
                                                    children: [
                                                      Icon(Icons.visibility,color: AppColor.infoyColor,),
                                                  SizedBox(width: 15,),
                                                  Text("View",style: TextStyle(color: AppColor.infoyColor),),
                                                    ],
                                                  ),),
                                                  onTap: (){
                                                    SavePostID(context, veiwPostList[index]['post_id'],veiwPostList[index]['id']);
                                                  },
                                                ),
                                                Divider(thickness: 1.2,),
                                                InkWell(
                                                  child: Container(
                                                    margin: EdgeInsets.only(top: 8,bottom: 8),
                                                    child: Row(
                                                    children: [
                                                      Icon(Icons.report_problem,color: AppColor.infoyColor,),
                                                  SizedBox(width: 15,),
                                                  Text("Report",style: TextStyle(color: AppColor.infoyColor),),
                                                    ],
                                                  ),),
                                                  onTap: (){
                                                    AwesomeDialog(
                                                    context: context,
                                                    dialogType: DialogType.NO_HEADER,
                                                    animType: AnimType.BOTTOMSLIDE,
                                                    btnCancelColor: AppColor.primaryColor,
                                                    btnOkColor: AppColor.darkColor,
                                                    title: 'Report post',
                                                    desc: 'Are you sure you want to report this post?',
                                                    btnCancelOnPress: () {},
                                                    btnOkOnPress: () async{
                                                      _loadTotalPostReports(veiwPostList[index]['post_id']);
                                                      SharedPreferences preferences = await SharedPreferences.getInstance();
                                                      Navigator.pop(context);
                                                    },
                                                    )..show();
                                                  },
                                                ),
                                                  

                      ],
                    ),
                    value: 2,
                  ),
                  
                  
                ]
            )
          
                            
                            )
                              ],
                            )
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                            height: 40,
                            padding: EdgeInsets.only(left: 25,right: 30),
                            margin: EdgeInsets.only(top: 15),
                            child: RichText(
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  strutStyle: StrutStyle(fontSize: 17.0),
                                  text: TextSpan(
                                          style: TextStyle(color: Colors.black,height:1.2),
                                          text: '${veiwPostList[index]['post_text']}'
                                          
                                        ),
                                    ),
                
                          ),
                          ),
                          
                            (veiwPostList[index]['image_post'] != "") ? 
                            StatefulBuilder(
                              builder: (BuildContext context, StateSetter setState) => Container(
                              margin: EdgeInsets.only(left: 5,right: 5,top: 10,bottom: 10),
                              height: 200,
                              child:CachedNetworkImage(
                                imageUrl: "$ImageUrl${veiwPostList[index]['image_post']}",
                                progressIndicatorBuilder: (context, url, downloadProgress) => 
                                        Image(image: AssetImage('assets/images/loading_login.gif'),width: 50,),
                                errorWidget: (context, url, error) => Icon(Icons.error),
                              )))
                            
                            : Text(""),
                          Container(
                            margin: EdgeInsets.only(left: 20,bottom: 10),
                            child: Row(children: [
                              Text("${veiwPostList[index]['Total_likes']} ",style: TextStyle(color: AppColor.infoyColor),),
                              Icon(Icons.favorite,size: 17,color: AppColor.infoyColor,),
                              Text("  ${veiwPostList[index]['total_comments']} ",style: TextStyle(color: AppColor.infoyColor),),
                              Icon(Icons.mode_comment,size: 17,color: AppColor.infoyColor,),
                              ],),
                          ),
                          Divider(thickness: 1.2,),
                          SizedBox(height: 10,)
                        ],
                      ),
                      onTap: (){
                        SavePostID(context, veiwPostList[index]['post_id'],veiwPostList[index]['id']);
                      },
                      );}
                    
                    );
                
                  }else{
                    return  Container(
                    color: Colors.white,
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                      itemCount: 3,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.only(
                          top: 8.0, bottom: 8.0, left: 20.0, right: 10.0),
                            child: Container(
                                width: MediaQuery.of(context).size.width,
                                child: Shimmer.fromColors(
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          CircleAvatar(
                                        backgroundColor: AppColor.infoyColor,
                                        radius: 15,
                                        
                                      ),
                                      SizedBox(width: 20,),
                                      Container(
                                        decoration:
                                        BoxDecoration(
                                        color: AppColor.whiteColor,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(15.0), 
                                          ),
                                        ),
                                        width: 150,height: 10,),
                                    
                                        ],
                                      ),
                                      //SizedBox(width: 20,),
                                      Container( decoration: 
                                      BoxDecoration(
                                        color: AppColor.whiteColor,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(15.0), 
                                          ),
                                        ),
                                        margin: EdgeInsets.only(top: 5),
                                        width: 300,
                                        height: 75,)
                                            
                                          ],
                                        ),
                                          baseColor: Colors.black12,
                                          highlightColor: Colors.black38)),
                    
                                  
                            );}));
                    
                  }
                }
                else{
                  if(ShowProgress){
                    return ListView.builder(
                    
                    reverse: true,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    
                      itemCount: veiwPostList.length,
                      itemBuilder: (context, index) {
                        if(veiwPostList[index]['feeling'].toString().isNotEmpty){
                          
                            _feeling="is feeling";
                        }else{
                          _feeling="";
                        }
                        if(veiwPostList[index]['id']==_userId){
                                    _visblePostMore=true;
                        }else{
                                    _visblePostMore=false;
                        
                        }
                      return  InkWell(
                        child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 15,right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(children: [
                                  InkWell(
                                  
                                    child: Row(
                                      children: [
                                      CircleAvatar(
                                        backgroundColor: AppColor.infoyColor,
                                        radius: 15,
                                        backgroundImage:NetworkImage("$ImageUrl${veiwPostList[index]['image']}"),
                                      ),
                                      SizedBox(width: 10,),
                                      Text("${veiwPostList[index]['first_name']} ${veiwPostList[index]['last_name']} ",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),)
                                    ],),
                                    onTap: ()async{
                                      //TODO
                                      SharedPreferences preferences = await SharedPreferences.getInstance();
                                      if(veiwPostList[index]['id']==preferences.getString(id)){
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchProfileScreen()));
                                      }else{
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=>OtherProfileScreen(userId: veiwPostList[index]['id'])));
                                      }
                                    },
                                  ),
                                  Text("$_feeling"),
                            Text(" ${veiwPostList[index]['feeling']}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                          
                            ],),
                            if(_visblePostMore) Flexible(child:PopupMenuButton(
                              
                                icon: Icon(Icons.more_vert,color: AppColor.infoyColor,),
                                shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10.0))
                            ),
                                      itemBuilder: (context) => [
                                        PopupMenuItem(
                                          child: Column(
                                            children: [
                                            InkWell(
                                                  child: Container(
                                                    margin: EdgeInsets.only(top: 8,bottom: 8),
                                                    child: Row(
                                                    children: [
                                                      Icon(Icons.visibility,color: Colors.grey,),
                                                  SizedBox(width: 15,),
                                                  Text("View",style: TextStyle(color: Colors.grey),),
                                                    ],
                                                  ),),
                                                  onTap: (){
                                                    SavePostID(context, veiwPostList[index]['post_id'],veiwPostList[index]['id']);
                                                  },
                                                ),
                                                Divider(thickness: 1.2,),
                                                InkWell(
                                                  child: Container(
                                                    margin: EdgeInsets.only(top: 8,bottom: 8),
                                                    child: Row(
                                                    children: [
                                                      Icon(Icons.delete,color: Colors.grey,),
                                                  SizedBox(width: 15,),
                                                  Text("Delete",style: TextStyle(color: Colors.grey),),
                                                    ],
                                                  ),),
                                                  onTap: (){
                                                    AwesomeDialog(
                                                    context: context,
                                                    dialogType: DialogType.NO_HEADER,
                                                    animType: AnimType.BOTTOMSLIDE,
                                                    btnCancelColor: AppColor.primaryColor,
                                                    btnOkColor: AppColor.darkColor,
                                                    title: 'Delete post',
                                                    desc: 'Are you sure you want to delete this post?',
                                                    btnCancelOnPress: () {},
                                                    btnOkOnPress: () async{
                                                      deletePost(veiwPostList[index]['post_id']);
                                                      Navigator.pop(context);
                                                    },
                                                    )..show();
                                                  },
                                                ),
                                                  

                                            ],
                                          ),
                                          value: 1,
                                          
                                        ),
                                        
                                        
                                      ]
                                  )
                                
                                                  
                                                  )else Flexible(child: PopupMenuButton(
                                    icon: Icon(Icons.more_vert,color: AppColor.infoyColor,),
                                    shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10.0))
                            ),
                                      itemBuilder: (context) => [
                                        PopupMenuItem(
                                          child: Column(
                                            children: [
                                          InkWell(
                                                  child: Container(
                                                    margin: EdgeInsets.only(top: 8,bottom: 8),
                                                    child: Row(
                                                    children: [
                                                      Icon(Icons.visibility,color: AppColor.infoyColor,),
                                                  SizedBox(width: 15,),
                                                  Text("View",style: TextStyle(color: AppColor.infoyColor),),
                                                    ],
                                                  ),),
                                                  onTap: (){
                                                    SavePostID(context, veiwPostList[index]['post_id'],veiwPostList[index]['id']);
                                                  },
                                                ),
                                                Divider(thickness: 1.2,),
                                                InkWell(
                                                  child: Container(
                                                    margin: EdgeInsets.only(top: 8,bottom: 8),
                                                    child: Row(
                                                    children: [
                                                      Icon(Icons.report_problem,color: AppColor.infoyColor,),
                                                  SizedBox(width: 15,),
                                                  Text("Report",style: TextStyle(color: AppColor.infoyColor),),
                                                    ],
                                                  ),),
                                                  onTap: (){
                                                    AwesomeDialog(
                                                    context: context,
                                                    dialogType: DialogType.NO_HEADER,
                                                    animType: AnimType.BOTTOMSLIDE,
                                                    btnCancelColor: AppColor.primaryColor,
                                                    btnOkColor: AppColor.darkColor,
                                                    title: 'Report post',
                                                    desc: 'Are you sure you want to report this post?',
                                                    btnCancelOnPress: () {},
                                                    btnOkOnPress: () async{
                                                      _loadTotalPostReports(veiwPostList[index]['post_id']);
                                                      SharedPreferences preferences = await SharedPreferences.getInstance();
                                                      Navigator.pop(context);
                                                    },
                                                    )..show();
                                                  },
                                                ),
                                                  

                      ],
                    ),
                    value: 2,
                  ),
                  
                  
                ]
            )
          
                            
                            )
                              ],
                            )
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                            height: 40,
                            padding: EdgeInsets.only(left: 25,right: 30),
                            margin: EdgeInsets.only(top: 15),
                            child: RichText(
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  strutStyle: StrutStyle(fontSize: 17.0),
                                  text: TextSpan(
                                          style: TextStyle(color: Colors.black,height:1.2),
                                          text: '${veiwPostList[index]['post_text']}'
                                          
                                        ),
                                    ),
                
                          ),
                          ),
                          
                            (veiwPostList[index]['image_post'] != "") ? 
                            StatefulBuilder(
                              builder: (BuildContext context, StateSetter setState) => Container(
                              margin: EdgeInsets.only(left: 5,right: 5,top: 10,bottom: 10),
                              height: 200,
                              child:CachedNetworkImage(
                                imageUrl: "$ImageUrl${veiwPostList[index]['image_post']}",
                                progressIndicatorBuilder: (context, url, downloadProgress) => 
                                        Image(image: AssetImage('assets/images/loading_login.gif'),width: 50,),
                                errorWidget: (context, url, error) => Icon(Icons.error),
                              )))
                            
                            : Text(""),
                          Container(
                            margin: EdgeInsets.only(left: 20,bottom: 10),
                            child: Row(children: [
                              Text("${veiwPostList[index]['Total_likes']} ",style: TextStyle(color: AppColor.infoyColor),),
                              Icon(Icons.favorite,size: 17,color: AppColor.infoyColor,),
                              Text("  ${veiwPostList[index]['total_comments']} ",style: TextStyle(color: AppColor.infoyColor),),
                              Icon(Icons.mode_comment,size: 17,color: AppColor.infoyColor,),
                              ],),
                          ),
                          Divider(thickness: 1.2,),
                          SizedBox(height: 10,)
                        ],
                      ),
                      onTap: (){
                        SavePostID(context, veiwPostList[index]['post_id'],veiwPostList[index]['id']);
                      },
                      );}
                    
                    );
                
                  }else{
                    return  Container(
                    color: Colors.white,
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                      itemCount: 3,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.only(
                          top: 8.0, bottom: 8.0, left: 20.0, right: 10.0),
                            child: Container(
                                width: MediaQuery.of(context).size.width,
                                child: Shimmer.fromColors(
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          CircleAvatar(
                                        backgroundColor: AppColor.infoyColor,
                                        radius: 15,
                                        
                                      ),
                                      SizedBox(width: 20,),
                                      Container(
                                        decoration:
                                        BoxDecoration(
                                        color: AppColor.whiteColor,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(15.0), 
                                          ),
                                        ),
                                        width: 150,height: 10,),
                                    
                                        ],
                                      ),
                                      //SizedBox(width: 20,),
                                      Container( decoration: 
                                      BoxDecoration(
                                        color: AppColor.whiteColor,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(15.0), 
                                          ),
                                        ),
                                        margin: EdgeInsets.only(top: 5),
                                        width: 300,
                                        height: 75,)
                                            
                                          ],
                                        ),
                                          baseColor: Colors.black12,
                                          highlightColor: Colors.black38)),
                    
                                  
                            );}));
                    }
                    }}
            ),
      
      )
                      ],
        )
      ),
      
      
      ),
      
      
    );
  }
  //Smoking counter widget
  Widget SmokingCounter(){
    return Container(
      margin: EdgeInsets.only(top: 20,left: 10,right: 10),
      height: 150,
      decoration:  BoxDecoration(
              color: AppColor.primaryColor,
              border:Border.all(
                  color: AppColor.primaryColor,
                  width: 5.0,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(22.0), 
                
        ),
            ),
      child:  Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            width: 95,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
            children: [
              new Flexible(
                child: Icon(
                          
                          Icons.smoking_rooms_outlined,
                          color: AppColor.whiteColor,
                          size: 35.0,
                        ),
              ),
              SizedBox(height: 10,),
              new Flexible(
                child: Container(
                  width: 95,
                  height: 50,
                  decoration:   BoxDecoration(
                    color: AppColor.whiteColor,
                    border:Border.all(
                        color: AppColor.whiteColor,
                        width: 5.0,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(12.0), 
                      
              ),
                  ),
                  child: Center(child: Text("$cigaritNumber"),),
                )
            ),
              
            ],
          ),),
          Container(
            width: 90,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                new Flexible(
                child: Icon(
                          
                          Icons.local_atm_sharp,
                          color: AppColor.whiteColor,
                          size: 35.0,
                        ),
              ),
              SizedBox(height: 10,),
              new Flexible(
                child:  Container(
                  width: 95,
                  height: 50,
                  decoration:   BoxDecoration(
                    color: AppColor.whiteColor,
                    border:Border.all(
                        color: AppColor.whiteColor,
                        width: 5.0,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(12.0), 
                      
              ),
                  ),
                  child: Center(child: Text("- ${saveDoller.toStringAsFixed(2)} \$"),),
                )
            
                ),
              ],
            ),
          ),
          Container(
            width: 90,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
            children: [
              new Flexible(
                child: Icon(
                          
                          Icons.health_and_safety_outlined,
                          color: AppColor.whiteColor,
                          size: 35.0,
                        ),
              ),
              SizedBox(height: 10,),
              new Flexible(
                child: Container(
                  width: 95,
                  height: 50,
                  decoration:   BoxDecoration(
                    color: AppColor.whiteColor,
                    border:Border.all(
                        color: AppColor.whiteColor,
                        width: 5.0,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(12.0), 
                      
              ),
                  ),
                  child: Center(child: Text("- ${SaveLife.toStringAsFixed(3)} D"))
                )
            
            ),
            ],
          ),),
        ],
      )
    );
      
  }
  //i need smok and plus buttons widget
  Widget buttonsCounter(){
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(left: 10,right: 10,top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(onPressed: (){
              
              Navigator.pushNamed(context, Screens.IneedAsmookOptions.value);
            },
            style: ElevatedButton.styleFrom(
            shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(22.0),
                ),
            primary: AppColor.darkColor,),  
            child: Text("I NEED A SMOKE")),
                          )
          ),
          SizedBox(width: 30,),
          Flexible(
          child: SizedBox(
          width: double.infinity, 
          child: ElevatedButton(onPressed: ()async{
            SharedPreferences preferences = await SharedPreferences.getInstance();
              setState(() {
                priceOfOneCigaritte=preferences.getDouble(price_one_cigratte);
                cigaritNumber++;
                print("-----------------------------------${preferences.getDouble(price_one_cigratte)}");
                saveDoller=saveDoller+priceOfOneCigaritte;
                SaveLife=SaveLife+0.00763889;
                updateSmokingCounter(cigaritNumber, saveDoller, SaveLife.toStringAsFixed(3));
              });
            },
            
            style: ElevatedButton.styleFrom(
            shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(22.0),
                ),
            primary: AppColor.darkColor,), 
            child: Icon(
            Icons.add_circle_sharp,
          ),),
                          )
          ),
        
      ],
    ),
    );
  }
  //crete new posts widget
  Widget PostBar(){
      return Container(
        margin: EdgeInsets.only(top: 20,left: 10,right: 10),
        child: TextFormField(
          
          readOnly: true,
          decoration: InputDecoration(
            hintText: "Create Post..",
            
            filled: true,
            fillColor: AppColor.whiteColor,

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              
              borderSide: BorderSide(
                color: AppColor.infoyColor,width: 2)
            ),
          
      
      
        
          focusedBorder: OutlineInputBorder(
            
            borderRadius: BorderRadius.circular(10),
            
            borderSide: BorderSide(color: AppColor.infoyColor,width: 2),
              
        ),
        
        ),
      onTap: (){
        Navigator.pushNamed(context,Screens.craetePost.value);
      },
    ));
  
  }
  //send requst to get all posts
  loadPosts()async{
    
  var url = Uri.parse(veiwAllPostsUrl);
  var res = await http.get(url); 
  var responseBody = jsonDecode(res.body);
  if (mounted) setState(() {
    ShowProgress=true;
    veiwPostList=responseBody;
  });

  return veiwPostList;
  }
  //save post id to go anthor page
  SavePostID(BuildContext context,String _postid,String _userIdPost) async{
    
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // Save response
    
    preferences.setString(post_id, _postid);
    preferences.setString(user_id_post, _userIdPost);
    // push to home screen
    Navigator.pushNamed(context, Screens.comments.value);
    
  }
  //send requst to update counter smoking if click plus button
  updateSmokingCounter( numCigartte, costCigartte, saveHelth) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
      var _userId=preferences.getString(id);
      var url=Uri.parse(updateSmokingCounterURL);
      var response = await http.post(url,body: {
        
        "number_of_cigarette":numCigartte.toString(),
        "cost_of_cigarette":costCigartte.toString(),
        "save_health":saveHelth,
        "user_id":_userId,
      });
      print("Status Code1: ${response.statusCode}  Body: ${response.body}");
      if(response.statusCode==200){
        
      }
    
      
      }
  //send requst to get smoking counter from db
  _loadSmokingCounter()async{
    
          
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var _UserId=preferences.getString(id);
    var url=Uri.parse(viewSmokingCounterURL);
      var response = await http.post(url,body: {
        "user_id":_UserId,
      });
    var responseBody = jsonDecode(response.body);
    
      SmokingCounterList=responseBody;
      if(mounted)setState(() {
        int intcigaritNumber=int.parse(SmokingCounterList[0]['number_of_cigarette'].toString());
        cigaritNumber=intcigaritNumber;
        double intsaveDoller=double.parse(SmokingCounterList[0]['cost_of_cigarette'].toString());
        saveDoller=intsaveDoller;
        double intsaveLife=double.parse(SmokingCounterList[0]['save_health'].toString());
        SaveLife=intsaveLife;
        
      });
  
  }
  //send requst to get notification counter
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
      if(mounted)setState(() {
        CountNotification=res[0]['count_notification'];
      });
      } 
      return CountNotification.toString();
      }
  //send requst to reset notification counter if click notification icon
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
  //function get user data from shared prefrence
  getUserID()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    _userId=preferences.getString(id);
  }
  //send requst to delete post
  deletePost(String PostID) async{
      ScaffoldMessenger.of(context)
      
    .showSnackBar(SnackBar(
      content: Text("Delete Post..",textAlign: TextAlign.center,style: TextStyle(fontSize: 16),),
    backgroundColor: AppColor.blackTransparentColor,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(left: 100,right: 100,bottom: 50),
      duration: Duration(seconds: 2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
    )
    );
      var url=Uri.parse(deletePostUrl);
      var response = await http.post(url,body: {
        "post_id":PostID,
      });
      if(response.statusCode==200){
        print("Body: ${response.body}");
          
      }
    
      
      }
  //send requst to report post
  reportPost(String PostID) async{
      SharedPreferences preferences = await SharedPreferences.getInstance();
      var _userId=preferences.getString(id);
      var url=Uri.parse(reportPostUrl);
      var response = await http.post(url,body: {
        "User_report_id":_userId,
        "post_id":PostID,
      });
      if(response.statusCode==200){
        print("Body: ${response.body}");
        _loadTotalPostReports(PostID);
      }else{
        AwesomeDialog(
              context: context,
              dialogType: DialogType.WARNING,
              animType: AnimType.BOTTOMSLIDE,
              btnCancelColor: AppColor.primaryColor,
              btnOkColor: AppColor.darkColor,
              desc: 'You have already reported this post!',
              btnCancelOnPress: () {},
              btnOkOnPress: () {
                
              },
              )..show();
      }
    
      
      }
  //send requst to count total reports in one post
  _loadTotalPostReports(String PostID)async{
      
      var url = Uri.parse(countPostReportsUrl);
      var response = await http.post(url,body: {
          "post_id":PostID,
        });
      var responseBody = jsonDecode(response.body);
      //print(responseBody.runtimeType);
      int countReports=int.parse(responseBody);
      if(countReports>=20){
        await  addNewPostReportNotificatin(PostID, "A post has reached 20 reports");
      }else{
        await reportPost(PostID);
        print("<20");
      }
      
    }
   //send requst to send notification to admin if post>=20 report
  addNewPostReportNotificatin(String _postID,String _body) async{
      
      var url=Uri.parse(createAdminNotificationUrl);
      var response = await http.post(url,body: {
        "post_id":_postID,
        "comment_id":"0",
        "body":_body,
        "type":"post",
      });
      print("Status Code: ${response.statusCode} \n Body: ${response.body}");
      if(response.statusCode==200){
      
      updateAdminCountNotification();
      loadAdminToken();
      SharedPreferences preferences = await SharedPreferences.getInstance();
      var AdminToken=preferences.getString(adminToken);
      sendPushMessage(AdminToken!, "A post has reached 20 reports", "");
        
      
  
      }else{
          reportPost(PostID);
      }
      
}
  //function send notification with token
  void sendPushMessage(String token, String body, String title) async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=AAAAvQtFDC8:APA91bG2N8PRk80gSPYqHwYv_BuAzN-aK9R4EQisXE2DUX9bvvdm_waVj_Sni85qoJiflEqXB_912droERbzBZH1JvHhJAEjECec3yHG-859xlucB3-xWFK21YD5vmnCX4WM4joqAwm5',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': body,
              'title': title
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done'
            },
            "to": token,
          },
        ),
      );
    } catch (e) {
      print("error push notification");
    }
  }
  //send requst to get admin token
  loadAdminToken()async{
    var url = Uri.parse(oneUserURl+"?id=$AdminID");
    var res = await http.get(url);
    var responseBody = jsonDecode(res.body);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(adminToken, responseBody[0]['Token']);
  }
  //send requst update count notification number in the admin
  updateAdminCountNotification() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
      
      var _userId=preferences.getString(id);
      var url=Uri.parse(updateCountNotificationUrl);
      
      var response = await http.post(url,body: {
        "user_id":"$AdminID"
      });
      if(response.statusCode==200){
        print(response.body);
      }
      
      
      
      
      }


}


