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

class AdminOnePost extends StatefulWidget {
  const AdminOnePost({ Key? key }) : super(key: key);

  @override
  State<AdminOnePost> createState() => _AdminOnePostState();
}

class _AdminOnePostState extends State<AdminOnePost> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _commentController = TextEditingController();
  String _commentText="";
  var _UserId;
  List CommentsContent = [];
  List PostContent = [{
        "id": "38",
        "first_name": "loading",
        "last_name": "..",
        "image": "loadingImage.gif",
        "email": "",
        "post_text": "loading..",
        "post_id": "59",
        "feeling": "",
        "image_post": "loadingImage.gif",
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
      getUserID();
      getPostId();
      _loadPost();
      _loadCommentsOfOnePost();
      
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Comments"),
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
          if(_contentVisable) Container(margin: EdgeInsets.only(top: 50), child: Center(child: Image(image: AssetImage('assets/images/loading_login.gif'),width: 50,),),) else Column(
      children: [
        Column(
          children: [
            Container(
                            margin: EdgeInsets.only(left: 20,bottom: 10,top: 15,right: 10),
                            child:Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                              Row(children: [
                                InkWell(
                                    child: Row(
                                      children: [
                                      CircleAvatar(
                                        backgroundColor: AppColor.infoyColor,
                                        radius: 15,
                                        backgroundImage:
                                        NetworkImage("$ImageUrl${PostContent[0]['image']}"),
                                      ),
                                      SizedBox(width: 10,),
                                      Text("${PostContent[0]['first_name']} ${PostContent[0]['last_name']} ",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),)
                                    ],),
                                    onTap: ()async{
                                      //TODO
                                    
                                    },
                                  ),
                                Text("$_feeling"),
                            Text(" ${PostContent[0]['feeling']}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),)
                            ],),
                            Flexible(child:IconButton(onPressed: (){
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
                                                      deletePost(PostContent[0]['post_id']);
                                                      Navigator.pop(context);
                                                    },
                                                    )..show();
                            }, icon: Icon(Icons.delete,color: AppColor.infoyColor,size: 20,)))
                            ],)
                          ),
            Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                  padding: EdgeInsets.only(left: 20,right: 20),
                  margin: EdgeInsets.only(bottom: 15),
                  child: RichText(
                      
                        strutStyle: StrutStyle(fontSize: 17.0),
                        text: TextSpan(
                                style: TextStyle(color: Colors.black,height:1.2),
                                text: '${PostContent[0]['post_text']}'
                                
                              ),
                          ),
      
                ),
                ),
            
              (PostContent[0]['image_post'] != "") ? 
                            Container(
                              margin: EdgeInsets.only(bottom: 10),
                              height: 200,
                              child:  FullScreenWidget(
                              child: Center(
                                child: Hero(
                                  tag: "customBackground",
                                  child: ClipRRect(
                                    child: CachedNetworkImage(
                                                  imageUrl: "${baseUrl}images/${PostContent[0]['image_post']}",
                                                  progressIndicatorBuilder: (context, url, downloadProgress) => 
                                                          Image(image: AssetImage('assets/images/loading_login.gif'),width: 50,),
                                                  errorWidget: (context, url, error) => Icon(Icons.error),
                                                )
                                  ),
                                ),
                              ),
                            ),
                            )
                            : Text(""),
            Container(
          margin: EdgeInsets.only(left: 20,bottom: 10),
          child: Row(children: [
            FutureBuilder(
      
              future: _loadTotalComments(),
              builder: (context,snapshot){
                
                if(snapshot.hasData){
                  return Text("$TotalLikes ",style: TextStyle(color: AppColor.infoyColor),);
                }
                else{
                  return Container(
                    child: Text("$TotalLikes ",style: TextStyle(color: AppColor.infoyColor),),
                  );
                }
              },
            ),
            
            Icon(Icons.favorite,size: 17,color: AppColor.infoyColor,),
            
            FutureBuilder(
      
              future: _loadTotalLikes(),
              builder: (context,snapshot){
                
                if(snapshot.hasData){
                  return Text("  $TotalComments ",style: TextStyle(color: AppColor.infoyColor),);
                }
                else{
                  return Container(
                    child: Text(" $TotalComments ",style: TextStyle(color: AppColor.infoyColor),),
                  );
                }
              },
            ),
            
            Icon(Icons.mode_comment,size: 17,color: AppColor.infoyColor,),
            ],),
        ),

            Divider(thickness: 1.2,),
            SizedBox(height: 10,),
            Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              
            ],
          ))

          ],
        ),
        FutureBuilder(
              future: _loadCommentsOfOnePost(),
              builder: (context,snapshot){
                if(snapshot.hasData){
                  return  ListView.builder(
                    reverse: true,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                      itemCount: CommentsContent.length,
                      itemBuilder: (context, index) {
                      
                      return  Container(
                        margin: EdgeInsets.only(left: 10,bottom: 15),
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: Column(
                              children: [
                                ChatBubble(
                                clipper: ChatBubbleClipper1(type: BubbleType.receiverBubble),
                                backGroundColor: AppColor.commentsColor,
                                child: Container(
                                  constraints: BoxConstraints(
                                    maxWidth: MediaQuery.of(context).size.width * 0.8,
                                  ),
                                  child:Column(
                                    children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        InkWell(
                                      child: Container(
                                        margin: EdgeInsets.only(left: 10),
                                        child: Row(children: [
                                    CircleAvatar(
                                      backgroundColor: AppColor.whiteColor,
                                      backgroundImage: NetworkImage("$ImageUrl${CommentsContent[index]['image']}"),
                                      radius: 13,
                                    ),
                                    SizedBox(width: 5,),
                                    Text(" ${CommentsContent[index]['first_name']} ${CommentsContent[index]['last_name']}",style: TextStyle(fontWeight: FontWeight.bold),),
                                    
                                    ],),
                                      ),
                                      onTap: ()async{
                                        //TODO
                                      },
                                    ),
                                    IconButton(onPressed: (){
                                        AwesomeDialog(
                                                    context: context,
                                                    dialogType: DialogType.NO_HEADER,
                                                    animType: AnimType.BOTTOMSLIDE,
                                                    btnCancelColor: AppColor.primaryColor,
                                                    btnOkColor: AppColor.darkColor,
                                                    title: 'Delete Comment',
                                                    desc: 'Are You Sure You Want to Delete This Comment?',
                                                    btnCancelOnPress: () {},
                                                    btnOkOnPress: () async{
                                                      deleteComment(CommentsContent[index]['comment_id'],CommentsContent[index]['post_id'],CommentsContent[index]['id']);
                                                    },
                                                    )..show();
                                    }, icon: Icon(Icons.delete,color: AppColor.infoyColor,size: 20,))
                                    
                                      ],
                                    ),

                                    SizedBox(height: 10,),
                                    Container(
                                      margin: EdgeInsets.only(left: 15),
                                      child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Text("${CommentsContent[index]['comment_text']}",style: TextStyle(height: 1.2,fontSize: 13),),
                                    ),
                                    )
                                    ],
                                  )
                                ),
                              )
                              ],
                            
                          
                          
                        
                      ),
                      ),
                      )
                          ;}
                    );
        
                }
                else{
                  return Container(margin: EdgeInsets.only(top: 50), child: Center(child: Image(image: AssetImage('assets/images/loading_login.gif'),width: 50,),),);
                }
              },
            ),
          
                
                
              
            
  
      ],
    )
  
  
        ],
      )
    );
  
  }
  //get post id from home page or posts page
  void getPostId() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      var _postId;
      _postId=preferences.getString(post_id);
      _PostID=_postId;
      var _user_Id_Post;
      _user_Id_Post=preferences.getString(user_id_post);
      _UserIdPost=_user_Id_Post;
    });
  }
  //send requst to get comments for the post
  Future _loadCommentsOfOnePost()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    _PostID=preferences.getString(post_id);
    var url = Uri.parse(viewCommentsURL+"?post_id=$_PostID");
    var res = await http.get(url);
    var responseBody = jsonDecode(res.body);
    if(res.statusCode==200){
      if(mounted)setState(() {
      CommentsContent=responseBody;
    });
    _contentVisable=false;
    }
    
    return CommentsContent;
  }
  //send requst to get post data
  _loadPost()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    _PostID=preferences.getString(post_id);
    var url = Uri.parse(veiwOnePostUrl);
    var response = await http.post(url,body: {
        "post_id":_PostID,
      });
    var responseBody = jsonDecode(response.body);
    setState(() {
      PostContent=responseBody;
    });
    if(PostContent[0]['feeling'].toString().isNotEmpty){
        _feeling="is feeling";
      }else{
        _feeling="";
      }
  }
  //function get total likes number in post
  _loadTotalLikes()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    _PostID=preferences.getString(post_id);
    var url = Uri.parse(totalLikesURL);
    var response = await http.post(url,body: {
        "post_id":_PostID,
      });
    var responseBody = jsonDecode(response.body);
    setState(() {
      TotalLikes=responseBody;
    });
  }
  //function get total comments number in post
  _loadTotalComments()async{
      SharedPreferences preferences = await SharedPreferences.getInstance();
      _PostID=preferences.getString(post_id);
      var url = Uri.parse(totalCommentsURL);
      var response = await http.post(url,body: {
          "post_id":_PostID,
        });
      var responseBody = jsonDecode(response.body);
      setState(() {
        TotalComments=responseBody;
      });
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
   //send requst to add new like notification to notification table db
  addNewLikedNotificatin(String _postId,String _body,String _Icon,String _Date) async{
      SharedPreferences preferences = await SharedPreferences.getInstance();

      _UserId=preferences.getString(id);
      
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
        updateCountNotification();
        sendPushMessage(PostContent[0]['Token'], "your post has been deleted", "NOcotine");
        
      
  
      }
      
}
  //send requst update count notification number in the user
  updateCountNotification() async{
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
  //get user id shared prefrence
  getUserID()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    _userId=preferences.getString(id);
  }
  //send requst to delete  comment
  deleteComment(String CommentID,String _postId,String CommentUserId) async{
      String dateDay = DateTime.now().day.toString();
      String dateMonth = DateTime.now().month.toString();
      String dateYear = DateTime.now().year.toString();
      var url=Uri.parse(deleteCommentUrl);
      var response = await http.post(url,body: {
        "post_id":_postId,
        "comment_id":CommentID,
      });
      if(response.statusCode==200){
        addNewDeleteCommentNotificatin(_postId, "Your Comment Has Been Deleted", "delete_comment", "$dateDay/$dateMonth/$dateYear",CommentUserId);
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
  //send requst to delete  post
  deletePost(String PostID) async{
      String dateDay = DateTime.now().day.toString();
      String dateMonth = DateTime.now().month.toString();
      String dateYear = DateTime.now().year.toString();
      var url=Uri.parse(deletePostUrl);
      var response = await http.post(url,body: {
        "post_id":PostID,
      });
      if(response.statusCode==200){
        print("Body: ${response.body}");
        addNewDeletePostNotificatin(PostID, "Your Post Has Been Deleted", "delete_post", "$dateDay/$dateMonth/$dateYear");
      }
    Navigator.popAndPushNamed(context, Screens.AdminNotificationScreen.value);
      
      }
  //send requst to add new notification to user deleted post
  addNewDeletePostNotificatin(String _postId,String _body,String _Icon,String _Date) async{
      SharedPreferences preferences = await SharedPreferences.getInstance();

      _UserId=preferences.getString(id);
      
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
        updateCountNotification();
        sendPushMessage(PostContent[0]['Token'], "your post has been deleted", "NOcotine");
        
      
  
      }
      
}
  //send requst to add new notification to user deleted comment
  addNewDeleteCommentNotificatin(String _postId,String _body,String _Icon,String _Date,String CommentUserId) async{
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
        sendPushMessage(PostContent[0]['Token'], "your comment has been deleted", "NOcotine");
        
      
  
      }
      
}
  


}