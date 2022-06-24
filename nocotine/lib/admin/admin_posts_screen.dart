import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nocotine/constants/cofig_api.dart';
import 'package:nocotine/constants/colors.dart';
import 'package:nocotine/constants/screens.dart';
import 'package:nocotine/screens/other_profile_screen.dart';
import 'package:nocotine/screens/search_Myprofile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';
class AdminPosts extends StatefulWidget {
  const AdminPosts({ Key? key }) : super(key: key);

  @override
  State<AdminPosts> createState() => _AdminPostsState();
}

class _AdminPostsState extends State<AdminPosts> {
  var CountNotification="";
  int cigaritNumber=0;
  double saveDoller=0;
  String saveDoller2="0";
  double saveHealth=0;
  String saveHealth2="0";
  bool _visbleLike=false;
  bool _visblePostMore=true;
  var _userId;
  String numberOfLikes="";
  String PostId="";
  List veiwPostList=[];
  List veiwPostList2=[];
  List visableLikes=[];
  List SmokingCounterList=[{
        "user_id": "0",
        "number_of_cigarette": 0,
        "cost_of_cigarette": 0.0,
        "save_health": 0.0
    }];
  var priceOfOneCigaritte;
  String _feeling="";
  bool ShowCountNotification=true;
  bool ShowProgress=false;
  String PostID="";
  String UserIdPost="";
  TextEditingController _PostController=new TextEditingController();
  @override
  void initState() {
    setState(() {
      loadPosts();
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text("View Posts"),
        backgroundColor: AppColor.darkColor,
        leading: IconButton(onPressed: (){
        Navigator.pushReplacementNamed(context, Screens.AdminHomeScreen.value);
      }, icon: Icon(Icons.arrow_back_ios)),
      ),
      body: SingleChildScrollView(
        child:  Container(
            margin: EdgeInsets.only(top: 20),
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
                                    
                                    },
                                  ),
                                  Text("$_feeling"),
                            Text(" ${veiwPostList[index]['feeling']}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                          
                            ],),
                            Flexible(child:PopupMenuButton(
                              
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
                                                      deletePost(veiwPostList[index]['post_id'], veiwPostList[index]['id'], veiwPostList[index]['Token']);
                                                      
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
                    
                      itemCount: veiwPostList.length,
                      itemBuilder: (context, index) {
                        if(veiwPostList[index]['feeling'].toString().isNotEmpty){
                          
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
                                        backgroundImage:NetworkImage("$ImageUrl${veiwPostList[index]['image']}"),
                                      ),
                                      SizedBox(width: 10,),
                                      Text("${veiwPostList[index]['first_name']} ${veiwPostList[index]['last_name']} ",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),)
                                    ],),
                                    onTap: ()async{
                                      //TODO
                                    
                                    },
                                  ),
                                  Text("$_feeling"),
                            Text(" ${veiwPostList[index]['feeling']}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                          
                            ],),
                            Flexible(child:PopupMenuButton(
                              
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
                                                      deletePost(veiwPostList[index]['post_id'], veiwPostList[index]['id'], veiwPostList[index]['Token']);
                                                      
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
                
          
      ));
  }
  //save post id to go anthor page
  SavePostID(BuildContext context,String _postid,String _userIdPost) async{
    
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // Save response
    
    preferences.setString(post_id, _postid);
    preferences.setString(user_id_post, _userIdPost);
    // push to home screen
    Navigator.pushNamed(context, Screens.AdminOnePost.value);
    
  }
  //send requst to get post data
  loadPosts()async{
    
  Future.delayed(Duration(seconds: 3), () async{
  var url = Uri.parse(veiwAllPostsUrl);
  var res = await http.get(url); 
  var responseBody = jsonDecode(res.body);
  if (mounted) setState(() {
    ShowProgress=true;
    veiwPostList=responseBody;
  });
});
  return veiwPostList;
  }
  //send requst to delete  post
  deletePost(String PostID,String _UserIdPost,String UserToken) async{
      String dateDay = DateTime.now().day.toString();
      String dateMonth = DateTime.now().month.toString();
      String dateYear = DateTime.now().year.toString();
      var url=Uri.parse(deletePostUrl);
      var response = await http.post(url,body: {
        "post_id":PostID,
      });
      if(response.statusCode==200){
        print("Body: ${response.body}");
        addNewDeletePostNotificatin(PostID, "Your Post Has Been Deleted", "delete_post", "$dateDay/$dateMonth/$dateYear", _UserIdPost, UserToken);
      }
    
      
      }
  //send requst to add new notification to user deleted post
  addNewDeletePostNotificatin(String _postId,String _body,String _Icon,String _Date,String _UserIdPost,String UserToken) async{
      SharedPreferences preferences = await SharedPreferences.getInstance();

      var _UserId=preferences.getString(id);
      
        var url=Uri.parse(createNotificationUrl);
      var response = await http.post(url,body: {
        "post_id":_postId,
        "user_id_sender":_UserId,
        "user_id_reciever":_UserIdPost,
        "body":_body,
        "icon":_Icon,
        "date":_Date,
      });
      print("Status Code: ${response.statusCode} \n Body: ${response.body}");
      if(response.statusCode==200){
        updateCountNotification(_UserIdPost);
        sendPushMessage(UserToken, "your post has been deleted", "NOcotine");
        
      
  
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
  //send requst update count notification number in the user
  updateCountNotification(String _UserIdPost) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
      
      var _userId=preferences.getString(id);
      var url=Uri.parse(updateCountNotificationUrl);
      
      var response = await http.post(url,body: {
        "user_id":_UserIdPost
      });
      if(response.statusCode==200){
        print(response.body);
      }
      
      
      
      
      }

}