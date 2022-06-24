import 'dart:convert';
import 'dart:ffi';
import 'package:animated_icon_button/animated_icon_button.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:nocotine/constants/cofig_api.dart';
import 'package:nocotine/constants/colors.dart';
import 'package:comment_box/comment/comment.dart';
import 'package:flutter/material.dart';
import 'package:nocotine/screens/other_profile_screen.dart';
import 'package:nocotine/screens/search_Myprofile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_1.dart';
import 'package:full_screen_image_null_safe/full_screen_image_null_safe.dart';
import 'package:shimmer/shimmer.dart';

class CommentsScreen extends StatefulWidget {
  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
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
  bool _contentVisable=true;
  String _feeling="";
  double sideLength = 50;
  double opacityLevel = 0.0;
  var animaitonDuration=500;
  var _userId;
  int AdminID=59;
  @override
  void initState() {
    setState(() {
      getUserID();
      getUserImage();
      getPostId();
      _loadPost();
      _loadCommentsOfOnePost();
      _testLikes();
      
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
      body: Column(
        children: [
          if(_contentVisable)Expanded(child:Center(child: Image(image: AssetImage('assets/images/loading_login.gif'),width: 50,),),
              )
          else Expanded(child:   CommentBox(
          userImage:
              "$ImageUrl$commentImage",
          child: commentChild(CommentsContent),
          labelText: 'Write a comment...',
          withBorder: false,
          errorText: 'Comment cannot be blank',
          sendButtonMethod: () {
            if (formKey.currentState!.validate()) {
              setState(() {
                addNewComment(_PostID);
                print(_PostID);
                _commentText=_commentController.text;
              });
              _commentController.clear();
              FocusScope.of(context).unfocus();
            } else {
              print("Not validated");
            }
          },
          formKey: formKey,
          commentController: _commentController,
          backgroundColor: AppColor.whiteColor,
          textColor: AppColor.infoyColor,
          sendWidget: Icon(Icons.send_sharp, size: 30, color: AppColor.infoyColor),
        ),
        
        )
        ],
      )
    );
  }
  //create comment textfeild widget
  Widget commentChild(data) {
    return  SingleChildScrollView(
      child: Column(
      children: [
        Column(
          children: [
            Container(
                            margin: EdgeInsets.only(left: 15,bottom: 10,top: 10,right: 10),
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
                                      SharedPreferences preferences = await SharedPreferences.getInstance();
                                      if(PostContent[0]['id']==preferences.getString(id)){
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchProfileScreen()));
                                      }else{
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=>OtherProfileScreen(userId: PostContent[0]['id'])));
                                      }
                                    },
                                  ),
                                Text("$_feeling"),
                            Text(" ${PostContent[0]['feeling']}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),)
                            ],),
                            
                            Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                          
                                              if (_likeVisable) Container(
                                                  width: 50,
                                                  height: 50,
                                                  child: Stack(
                                                  children: [
                                                    Center(child:  Bounceable(
                                                        onTap: (){
                                                          setState(() {
                                                            deleteLike();
                                                          });
                                                        },
                                                        child: Icon(Icons.favorite,size: 30,color: AppColor.primaryColor,),
                                                        curve: Curves.easeOutCirc,
                                                        scaleFactor: 0.2,
                                                      ),),
                                                    Positioned(
                                                      bottom: 35,
                                                      left: 20,
                                                      right: 0,
                                                      child: AnimatedOpacity(
                                                      opacity: opacityLevel,
                                                      duration: Duration(milliseconds: animaitonDuration),
                                                      child:  Icon(Icons.favorite, color: AppColor.light2primaryColor,size: 12,),
                                                        ),) ,
                                                    Positioned(
                                                        bottom: 35,
                                                          left: 0,
                                                          right: 20,
                                                          child: AnimatedOpacity(
                                                      opacity: opacityLevel,
                                                      duration: Duration(milliseconds: animaitonDuration),
                                                      child:  Icon(Icons.favorite, color: AppColor.light2primaryColor,size: 12,),
                                                        ),
                                                          ),
                                                    Positioned(
                                                      top: 35,
                                                          left: 0,
                                                          right: 20,
                                                          child:AnimatedOpacity(
                                                      opacity: opacityLevel,
                                                      duration: Duration(milliseconds: animaitonDuration),
                                                      child:  Icon(Icons.favorite, color: AppColor.light2primaryColor,size: 12,),
                                                        ),),
                                                    Positioned(
                                                      top: 35,
                                                      left: 20,
                                                      right: 0,
                                                      child:  AnimatedOpacity(
                                                      opacity: opacityLevel,
                                                      duration: Duration(milliseconds: animaitonDuration),
                                                      child:  Icon(Icons.favorite, color: AppColor.light2primaryColor,size: 12,),
                                                        ),),
                                                    
                                                    ],
                                                ),
                                                
                                              )
                                              else Container(
                                                  width: 50,
                                                  height: 50,
                                                  child: Stack(
                                                  children: [
                                                    Center(child:  Bounceable(
                                                        onTap: (){
                                                          setState(() {
                                                            addLike();
                                                          });
                                                        },
                                                        child: Icon(Icons.favorite_border_outlined,size: 30,color: AppColor.infoyColor,),
                                                        curve: Curves.easeOutCirc,
                                                        scaleFactor: 0.2,
                                                      ),),Positioned(
                                                      bottom: 35,
                                                      left: 20,
                                                      right: 0,
                                                      child: AnimatedOpacity(
                                                      opacity: opacityLevel,
                                                      duration: Duration(milliseconds: animaitonDuration),
                                                      child:  Icon(Icons.favorite, color: AppColor.light2primaryColor,size: 12,),
                                                        ),) ,
                                                    Positioned(
                                                        bottom: 35,
                                                          left: 0,
                                                          right: 20,
                                                          child: AnimatedOpacity(
                                                      opacity: opacityLevel,
                                                      duration: Duration(milliseconds: animaitonDuration),
                                                      child:  Icon(Icons.favorite, color: AppColor.light2primaryColor,size: 12,),
                                                        ),
                                                          ),
                                                    Positioned(
                                                      top: 35,
                                                          left: 0,
                                                          right: 20,
                                                          child:AnimatedOpacity(
                                                      opacity: opacityLevel,
                                                      duration: Duration(milliseconds: animaitonDuration),
                                                      child:  Icon(Icons.favorite, color: AppColor.light2primaryColor,size: 12,),
                                                        ),),
                                                    Positioned(
                                                      top: 35,
                                                      left: 20,
                                                      right: 0,
                                                      child:  AnimatedOpacity(
                                                      opacity: opacityLevel,
                                                      duration: Duration(milliseconds: animaitonDuration),
                                                      child:  Icon(Icons.favorite, color: AppColor.light2primaryColor,size: 12,),
                                                        ),),
                                                    ],
                                                ),
                                                
                                                
                                              )
                                
                                
                            ],
                          ),
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
        ListView.builder(
                    reverse: true,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                      itemCount: CommentsContent.length,
                      itemBuilder: (context, index) {
                        if(CommentsContent[index]['id']==_userId){
                          _deletVisable=true;
                        }else{
                          _deletVisable=false;
                        }
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
                                      SharedPreferences preferences = await SharedPreferences.getInstance();
                                      if(CommentsContent[index]['id']==preferences.getString(id)){
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchProfileScreen()));
                                      }else{
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=>OtherProfileScreen(userId: CommentsContent[index]['id'])));
                                      }
                                      },
                                    ),
                                    if(_deletVisable) IconButton(onPressed: (){
                                        AwesomeDialog(
                                                    context: context,
                                                    dialogType: DialogType.NO_HEADER,
                                                    animType: AnimType.BOTTOMSLIDE,
                                                    btnCancelColor: AppColor.primaryColor,
                                                    btnOkColor: AppColor.darkColor,
                                                    title: 'Delete comment',
                                                    desc: 'Are you sure you want to delete this comment?',
                                                    btnCancelOnPress: () {},
                                                    btnOkOnPress: () async{
                                                      deleteComment(CommentsContent[index]['post_id'],CommentsContent[index]['comment_id']);
                                                      
                                                    },
                                                    )..show();
                                    }, icon: Icon(Icons.delete,color: AppColor.infoyColor,size: 20,))
                                    else IconButton(onPressed: (){
                                      AwesomeDialog(
                                                    context: context,
                                                    dialogType: DialogType.NO_HEADER,
                                                    animType: AnimType.BOTTOMSLIDE,
                                                    btnCancelColor: AppColor.primaryColor,
                                                    btnOkColor: AppColor.darkColor,
                                                    title: 'Report comment',
                                                    desc: 'Are you sure you want to report this comment?',
                                                    btnCancelOnPress: () {},
                                                    btnOkOnPress: () async{
                                                      _loadTotalCommentReports(CommentsContent[index]['post_id'], CommentsContent[index]['comment_id']);
                                                    },
                                                    )..show();
                                    }, icon: Icon(Icons.report_problem,color: AppColor.infoyColor,size: 20,))
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
                    )
                
              
            
  ,              
      ],
    )
  
  ,
    ); 
  
  }
  //send requst to add new comment
  addNewComment(String _postId) async{
      SharedPreferences preferences = await SharedPreferences.getInstance();

      _UserId=preferences.getString(id);
      print("****************************************************************");
      print("User id +++++++++++$_UserId");
      print("Comment Text +++++++++++$_commentText");
      print("Post Id $_postId");
      String UserId= _UserId;
      String CommentText= _commentText;
      String PostID= _postId;
      // if(CommentText.isEmpty || UserId.isEmpty || PostID.isEmpty){
        
      //   print("NO DATA"); 
      //   return;
      // }
      var url=Uri.parse(createCommentURL);
      var response = await http.post(url,body: {
        "post_id":PostID,
        "user_id":UserId,
        "comment_text":CommentText,
      });
      print("Status Code: ${response.statusCode} \n Body: ${response.body}");
      if(response.statusCode==200){
        print("Comment created");
          String dateDay = DateTime.now().day.toString();
          String dateMonth = DateTime.now().month.toString();
          String dateYear = DateTime.now().year.toString();
          addNewCommentNotificatin(_postId, "Commented on Your Post", "mode_comment", "$dateDay/$dateMonth/$dateYear");
          if(mounted)setState(() {
            _loadCommentsOfOnePost();
          });
      }
      
      
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
  _loadCommentsOfOnePost()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    _PostID=preferences.getString(post_id);
    var url = Uri.parse(viewCommentsURL+"?post_id=$_PostID");
    var res = await http.get(url);
    var responseBody = jsonDecode(res.body);
    if(mounted)setState(() {
      CommentsContent=responseBody;
    });
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
    if(mounted)setState(() {
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
    if(mounted)setState(() {
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
      if(mounted)setState(() {
        TotalComments=responseBody;
      });
    }
  //function test if this post liked
  _testLikes()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    _PostID=preferences.getString(post_id);
    var _UserID=preferences.getString(id);
    var url = Uri.parse(likeTestURL);
    var response = await http.post(url,body: {
        "user_id":_UserID,
        "post_id":_PostID,
      });
    var responseBody = jsonDecode(response.body);
    if(response.statusCode==200){
      if(mounted)setState(() {
      bool res = responseBody.toLowerCase() == 'true';
      _likeVisable=res;
    });
    _contentVisable=false;
    }
    
    return _likeVisable;
  }
  //send requst to add new like
  addLike() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
      
      _PostID=preferences.getString(post_id);
      var _userId=preferences.getString(id);
      var url=Uri.parse(createLikesUrl);
      var response = await http.post(url,body: {
        "post_id":_PostID,
        "user_id":_userId,
      });
      print("Status Code: ${response.statusCode} \n Body: ${response.body}");
      if(response.statusCode==200){
        if(mounted)setState(() {
          _likeVisable=true;
          String dateDay = DateTime.now().day.toString();
          String dateMonth = DateTime.now().month.toString();
          String dateYear = DateTime.now().year.toString();
          //print("$dateDay/$dateMonth/$dateYear");
          addNewLikedNotificatin(_PostID, "Liked Your Post", "favorite", "$dateDay/$dateMonth/$dateYear");
          makeAnimation();
          
        });
        
      }
    
      
      }
  //send requst to delete  like
  deleteLike() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
      
      _PostID=preferences.getString(post_id);
      var _userId=preferences.getString(id);
      var url=Uri.parse(deleteLikeURL);
      var response = await http.post(url,body: {
        "post_id":_PostID,
        "user_id":_userId,
      });
      print("Status Code: ${response.statusCode} \n Body: ${response.body}");
      if(response.statusCode==200){
        if(mounted) setState(() {
          _likeVisable=false;
          makeAnimation();
        });
      }
    
      
      }
  //get my image from shared prefrence
  getUserImage()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    commentImage=preferences.getString(image)!;
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
      if(_UserId==_UserIdPost){
        return;
      }else{
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
        print("${response.body}");
        var _firstName=preferences.getString(firstName);
        var _lastName=preferences.getString(lastName);
        updateCountNotification();
        sendPushMessage(PostContent[0]['Token'], "liked your post", "$_firstName $_lastName");
        
      }
  
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
  //send requst to add new comment notification to notification table db
  addNewCommentNotificatin(String _postId,String _body,String _Icon,String _Date) async{
      SharedPreferences preferences = await SharedPreferences.getInstance();

      _UserId=preferences.getString(id);
      if(_UserId==_UserIdPost){
        return;
      }else{
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
        print("${response.body}");
        var _firstName=preferences.getString(firstName);
        var _lastName=preferences.getString(lastName);
        updateCountNotification();
        sendPushMessage(PostContent[0]['Token'], "commented on your post", "$_firstName $_lastName");
      }
  
      }
      
}
  //function create animation to likes button
  makeAnimation(){
    setState(() {
        opacityLevel =  1.0 ;
      });
        Future.delayed(Duration(milliseconds: animaitonDuration), () { // <-- Delay here
        setState(() {
          opacityLevel =  0.0 ; // <-- Code run after delay
        });
        });
  }
  //get user id shared prefrence
  getUserID()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    _userId=preferences.getString(id);
  }
  //send requst to delete  comment
  deleteComment(String PostId,String CommentID) async{

      var url=Uri.parse(deleteCommentUrl);
      var response = await http.post(url,body: {
        "post_id":PostId,
        "comment_id":CommentID,
      });
      if(response.statusCode==200){
        print("Body: ${response.body}");
        if(mounted)setState(() {
            _loadCommentsOfOnePost();
          });
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
        _loadTotalCommentReports(PostID,CommentID);
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
  //send requst to count total reports in one comment
  _loadTotalCommentReports(String PostID,String CommentID)async{
      
      var url = Uri.parse(countCommentReportsUrl);
      var response = await http.post(url,body: {
          "comment_id":CommentID,
        });
      var responseBody = jsonDecode(response.body);
      //print(responseBody.runtimeType);
      if(response.statusCode==200){
        int countReports=int.parse(responseBody);
        
      if(countReports>=20){
        await addNewCommentReportNotificatin(PostID,CommentID, "A comment has reached 20 reports");
      }else{
        await reportComment(PostID, CommentID);
        print("<20");
      }
      }
      
    }
  //send requst to send notification to admin if comment>=20 report
  addNewCommentReportNotificatin(String PostID,String _commentID,String _body) async{
      
      var url=Uri.parse(createAdminNotificationUrl);
      var response = await http.post(url,body: {
        "post_id":PostID,
        "comment_id":_commentID,
        "body":_body,
        "type":"comment",
      });
      print("Status Code: ${response.statusCode} \n Body: ${response.body}");
      if(response.statusCode==200){
        
        updateAdminCountNotification();
        loadAdminToken();
        SharedPreferences preferences = await SharedPreferences.getInstance();
        var AdminToken=preferences.getString(adminToken);
        sendPushMessage(AdminToken!, "A comment has reached 20 reports", "");
          
      
  
      }else{
        reportComment(PostID, _commentID);
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