import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:nocotine/constants/cofig_api.dart';
import 'package:nocotine/constants/colors.dart';
import 'package:nocotine/constants/screens.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';
class OthePostsScreen extends StatefulWidget {
  const OthePostsScreen({ Key? key ,required this.userId}) : super(key: key);
  final String userId;
  @override
  State<OthePostsScreen> createState() => _OthePostsScreenState();
}

class _OthePostsScreenState extends State<OthePostsScreen> {
  TextEditingController _BioController=new TextEditingController();
  var SaveBio="Bio";
  var _Name="";
  var _UserId;
  bool _visbleLike=false;
  var _userId;
  String dec="";
  final String assetName = 'assets/images/pack.svg';
  List _veiwPostListForOneUser=[];
  int AdminID=59;
  String _feeling="";
  bool ShowProgress=false;
  void initState() {
    
      getUserData();
    setState(() {
      _loadPostsOfOneUser();
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Posts"),
        backgroundColor: AppColor.darkColor,
        leading: IconButton(onPressed: (){
        Navigator.pop(context);
      }, icon: Icon(Icons.arrow_back_ios)),
      ),
      body: ListView(
        children: [
          Container(
            margin: EdgeInsets.only(top: 20),
            width: double.infinity,
            child: FutureBuilder(
              future: _loadPostsOfOneUser(),
              builder: (context,snapshot){
                if(snapshot.hasData){
                  if(ShowProgress){
                    return  ListView.builder(
                    reverse: true,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    
                      itemCount: _veiwPostListForOneUser.length,
                      itemBuilder: (context, index) {
                        if(_veiwPostListForOneUser[index]['feeling'].toString().isNotEmpty){
                          
                            _feeling="is feeling";
                        }else{
                          _feeling="";
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
                                        backgroundImage:NetworkImage("$ImageUrl${_veiwPostListForOneUser[index]['image']}"),
                                      ),
                                      SizedBox(width: 10,),
                                      Text("${_veiwPostListForOneUser[index]['first_name']} ${_veiwPostListForOneUser[index]['last_name']} ",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),)
                                    ],),
                                    onTap: (){
                                      //TODO
                                    },
                                  ),
                                  Text("$_feeling"),
                            Text(" ${_veiwPostListForOneUser[index]['feeling']}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                          
                            ],),
                            PopupMenuButton(
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
                                                      _SavePostID(context, _veiwPostListForOneUser[index]['post_id']);
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
                                                      _loadTotalPostReports(_veiwPostListForOneUser[index]['post_id']);
                                                      
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
                                          text: '${_veiwPostListForOneUser[index]['post_text']}'
                                          
                                        ),
                                    ),
                
                          ),
                          ),
                          (_veiwPostListForOneUser[index]['image_post'] != "") ? 
                            Container(
                              margin: EdgeInsets.only(left: 5,right: 5,top: 10,bottom: 10),
                              height: 200,
                              child: FadeInImage.assetNetwork(
                                placeholder: 'assets/images/loadingImage.gif',
                                image: '${baseUrl}images/${_veiwPostListForOneUser[index]['image_post']}',
                      ) ,)
                            : Text(""),
                          Container(
                            margin: EdgeInsets.only(left: 20,bottom: 10),
                            child: Row(children: [
                              Text("${_veiwPostListForOneUser[index]['Total_likes']} ",style: TextStyle(color: AppColor.infoyColor),),
                              Icon(Icons.favorite,size: 17,color: AppColor.infoyColor,),
                              Text("  ${_veiwPostListForOneUser[index]['total_comments']} ",style: TextStyle(color: AppColor.infoyColor),),
                              Icon(Icons.mode_comment,size: 17,color: AppColor.infoyColor,),
                              ],),
                          ),
                          
                          Divider()
                        ],
                      ),
                      onTap: (){
                        _SavePostID(context, _veiwPostListForOneUser[index]['post_id']);
                      },
                      );}
                    );
                
                  }else{
                    return  Container(
                    color: Colors.white,
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                      itemCount: 5,
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
                    
                      itemCount: _veiwPostListForOneUser.length,
                      itemBuilder: (context, index) {
                        if(_veiwPostListForOneUser[index]['feeling'].toString().isNotEmpty){
                          
                            _feeling="is feeling";
                        }else{
                          _feeling="";
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
                                        backgroundImage:NetworkImage("$ImageUrl${_veiwPostListForOneUser[index]['image']}"),
                                      ),
                                      SizedBox(width: 10,),
                                      Text("${_veiwPostListForOneUser[index]['first_name']} ${_veiwPostListForOneUser[index]['last_name']} ",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),)
                                    ],),
                                    onTap: (){
                                      //TODO
                                    },
                                  ),
                                  Text("$_feeling"),
                            Text(" ${_veiwPostListForOneUser[index]['feeling']}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                          
                            ],),
                            PopupMenuButton(
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
                                                      _SavePostID(context, _veiwPostListForOneUser[index]['post_id']);
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
                                                      _loadTotalPostReports(_veiwPostListForOneUser[index]['post_id']);
                                                      
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
                                          text: '${_veiwPostListForOneUser[index]['post_text']}'
                                          
                                        ),
                                    ),
                
                          ),
                          ),
                          (_veiwPostListForOneUser[index]['image_post'] != "") ? 
                            Container(
                              margin: EdgeInsets.only(left: 5,right: 5,top: 10,bottom: 10),
                              height: 200,
                              child: FadeInImage.assetNetwork(
                                placeholder: 'assets/images/loadingImage.gif',
                                image: '${baseUrl}images/${_veiwPostListForOneUser[index]['image_post']}',
                      ) ,)
                            : Text(""),
                          Container(
                            margin: EdgeInsets.only(left: 20,bottom: 10),
                            child: Row(children: [
                              Text("${_veiwPostListForOneUser[index]['Total_likes']} ",style: TextStyle(color: AppColor.infoyColor),),
                              Icon(Icons.favorite,size: 17,color: AppColor.infoyColor,),
                              Text("  ${_veiwPostListForOneUser[index]['total_comments']} ",style: TextStyle(color: AppColor.infoyColor),),
                              Icon(Icons.mode_comment,size: 17,color: AppColor.infoyColor,),
                              ],),
                          ),
                          
                          Divider()
                        ],
                      ),
                      onTap: (){
                        _SavePostID(context, _veiwPostListForOneUser[index]['post_id']);
                      },
                      );}
                    );
                
                  }else{
                    return  Container(
                    color: Colors.white,
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                      itemCount: 5,
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
                    }}
              },
            ),
      )
                
            
        ],
      )    ,
    );
  }
  //get user data shared prefrence 
  void getUserData() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      var _firstName;
      var _lastName;
      var _image;
      _Name="$_firstName $_lastName";
      _UserId=preferences.getString(id);
      
    });
  }
  //send requst to get posts data for this user 
  _loadPostsOfOneUser()async{
    
    var url = Uri.parse(veiwOneUserPostsUrl+"?User_id=${widget.userId}");
    var res = await http.get(url);
    var responseBody = jsonDecode(res.body);
    setState(() {
      ShowProgress=true;
      _veiwPostListForOneUser=responseBody;
    });
    return _veiwPostListForOneUser;
  }
  //send requst to add new like
  _addLike(String postID) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
      
      String _postId= postID;
      _userId=preferences.getString(id);
      var url=Uri.parse(createLikesUrl);
      var response = await http.post(url,body: {
        "post_id":_postId,
        "user_id":_userId,
      });
      print("Status Code: ${response.statusCode} \n Body: ${response.body}");
      if(response.statusCode==200){
        setState(() {
          _visbleLike=true;
        });
        
      }}
  //save post id to go anthor page
  _SavePostID(BuildContext context,String _postid) async{
    
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // Save response
    
    preferences.setString(post_id, _postid);
    // push to home screen
    Navigator.pushNamed(context, Screens.comments.value);
    
  }
  //send requst to report  post
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
      if(response.statusCode==200){
        int countReports=int.parse(responseBody);
        if(countReports>=20){
          await  addNewPostReportNotificatin(PostID, "A post has reached 20 reports");
        }else{
          await reportPost(PostID);
          print("<20");
        }
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
        reportPost(_postID);
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
