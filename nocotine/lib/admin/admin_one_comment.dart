import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:ffi';
import 'package:animated_icon_button/animated_icon_button.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:nocotine/constants/cofig_api.dart';
import 'package:nocotine/constants/colors.dart';
import 'package:comment_box/comment/comment.dart';
import 'package:flutter/material.dart';
import 'package:nocotine/constants/screens.dart';
import 'package:nocotine/screens/other_profile_screen.dart';
import 'package:nocotine/screens/search_Myprofile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_1.dart';
import 'package:full_screen_image_null_safe/full_screen_image_null_safe.dart';

class AdminOneComment extends StatefulWidget {
  const AdminOneComment({ Key? key }) : super(key: key);

  @override
  State<AdminOneComment> createState() => _AdminOneCommentState();
}

class _AdminOneCommentState extends State<AdminOneComment> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _commentController = TextEditingController();
  String _commentText="";
  var _UserId;
  List CommentsContent = [];
  List CommentContent = [{
        "id": "115",
        "first_name": "loading",
        "last_name": "..",
        "image": "loadingImage.gif",
        "email": "",
        "comment_text": "loading..",
    }];
  var commentImage="loadingImage.gif";
  var TotalLikes="0";
  var TotalComments="0";
  var _PostID;
  var _UserIdPost;
  bool _likeVisable=false;
  bool _positionVisable=false;
  bool _deletVisable=false;
  String _feeling="";
  double sideLength = 50;
  double opacityLevel = 0.0;
  var animaitonDuration=500;
  var _userId;
  bool _contentVisable=true;
  @override
  void initState() {
    setState(() {
      _loadComment();
      
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Comment"),
        backgroundColor: AppColor.darkColor,
        leading: IconButton(onPressed: (){
        Navigator.pop(context);
      }, icon: Icon(Icons.arrow_back_ios)),
      ),
      body: Container(
        child:commentChild(CommentsContent)),
    );
  }
  //create comment textfeild widget
  Widget commentChild(data) {
    return  SingleChildScrollView(
      child: Column(
        children: [
          
          if(_contentVisable) Container(margin: EdgeInsets.only(top: 50), child: Center(child: Image(image: AssetImage('assets/images/loading_login.gif'),width: 50,),),) else
          Container(
            margin: EdgeInsets.all(10),
            child:  ConstrainedBox(
            constraints: new BoxConstraints(
              minHeight: 200,
            ),
            child: Card(
              color: AppColor.commentsColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
            child: Column(
            children: [
                Container(
                  padding: EdgeInsets.only(left: 15,right: 10,top: 10),
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
                              backgroundImage:NetworkImage("$ImageUrl${CommentContent[0]['image']}"),
                            ),
                            SizedBox(width: 10,),
                            Text("${CommentContent[0]['first_name']} ${CommentContent[0]['last_name']} ",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),)
                          ],),
                          onTap: ()async{
                            //TODO
                          
                          },
                        ),
                
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
                                        Text("View Post",style: TextStyle(color: Colors.grey),),
                                          ],
                                        ),),
                                        onTap: (){
                                          SavePostID(context, CommentContent[0]['post_id']);
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
                                          title: 'Delete Post',
                                          desc: 'Are You Sure You Want to Delete This Post?',
                                          btnCancelOnPress: () {},
                                          btnOkOnPress: () async{
                                            deleteComment(CommentContent[0]['comment_id'], CommentContent[0]['post_id'], CommentContent[0]['id'], CommentContent[0]['Token']);
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
                    padding: EdgeInsets.only(left: 20,right: 20,top: 10),
                    child: RichText(
                        
                          strutStyle: StrutStyle(fontSize: 17.0),
                          text: TextSpan(
                                  style: TextStyle(color: Colors.black,height:1.2),
                                  text: '${CommentContent[0]['comment_text']}'
                                  
                                ),
                            ),

      ),
      ),
              
              ],
          ),
          )
        
            ),
        
          )
          ]));
  
  }
  //send requst to get comments data
  _loadComment()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var _CommentID=preferences.getString(post_id);
    print(_CommentID);
    var url = Uri.parse(veiwOneCommentUrl);
    var response = await http.post(url,body: {
        "comment_id":_CommentID,
      });
    var responseBody = jsonDecode(response.body);
    setState(() {
      CommentContent=responseBody;
      _contentVisable=false;
    });
    
  }
  //send requst to delete  comment
  deleteComment(String CommentID,String postID,String CommentUserId,String UserToken) async{
      String dateDay = DateTime.now().day.toString();
      String dateMonth = DateTime.now().month.toString();
      String dateYear = DateTime.now().year.toString();
      var url=Uri.parse(deleteCommentUrl);
      var response = await http.post(url,body: {
        "post_id":postID,
        "comment_id":CommentID,
      });
      if(response.statusCode==200){
        addNewDeleteCommentNotificatin(postID, "Your Comment Has Been Deleted", "delete_comment",  "$dateDay/$dateMonth/$dateYear", CommentUserId, UserToken);
        
        print("Body: ${response.body}");
        ScaffoldMessenger.of(context)
        
        .showSnackBar(SnackBar(
          content: Text("Delete comment..",textAlign: TextAlign.center,style: TextStyle(fontSize: 16),),
        backgroundColor: AppColor.blackTransparentColor,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(left: 100,right: 100,bottom: 50),
          duration: Duration(seconds: 2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        ));
        Navigator.pushReplacementNamed(context, Screens.AdminHomeScreen.value);
      }
    
      
      }
  //send requst to report  comment
  reportComment(String PostID,String CommentID) async{
      SharedPreferences preferences = await SharedPreferences.getInstance();
      var _userId=preferences.getString(id);
      var url=Uri.parse(reportCommentUrl);
      var response = await http.post(url,body: {
        "post_id":PostID,
        "comment_id":CommentID,
        "User_report_id":_userId,
      });
      if(response.statusCode==200){
        print("Body: ${response.body}");
      }else{
        AwesomeDialog(
              context: context,
              dialogType: DialogType.WARNING,
              animType: AnimType.BOTTOMSLIDE,
              btnCancelColor: AppColor.primaryColor,
              btnOkColor: AppColor.darkColor,
              desc: 'You Have Already Reported This Post!',
              btnCancelOnPress: () {},
              btnOkOnPress: () {
                
              },
              )..show();
      }
    
      
      }
  //save post id to go anthor page
  SavePostID(BuildContext context,String _postid) async{
    
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // Save response
    
    preferences.setString(post_id, _postid);
    // push to home screen
    Navigator.pushNamed(context, Screens.AdminOnePost.value);
    
  }
  //send requst to add new notification to user deleted comment
  addNewDeleteCommentNotificatin(String _postId,String _body,String _Icon,String _Date,String CommentUserId,String UserToken) async{
      SharedPreferences preferences = await SharedPreferences.getInstance();

      _UserId=preferences.getString(id);
      
        var url=Uri.parse(createNotificationUrl);
      var response = await http.post(url,body: {
        "post_id":_postId,
        "user_id_sender":_UserId,
        "user_id_reciever":CommentUserId,
        "body":_body,
        "icon":_Icon,
        "date":_Date,
      });
      print("Status Code: ${response.statusCode} \n Body: ${response.body}");
      if(response.statusCode==200){
        updateCountNotificationComment(CommentUserId);
        sendPushMessage(UserToken, "your comment has been deleted", "NOcotine");
        
      
  
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
  updateCountNotificationComment(String CommentUserId) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
      
      var _userId=preferences.getString(id);
      var url=Uri.parse(updateCountNotificationUrl);
      
      var response = await http.post(url,body: {
        "user_id":CommentUserId
      });
      if(response.statusCode==200){
        print(response.body);
      }
      
      
      
      
      }

  


}