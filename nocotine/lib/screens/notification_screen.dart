import 'dart:convert';
import 'dart:ffi';

import 'package:nocotine/constants/cofig_api.dart';
import 'package:nocotine/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:nocotine/constants/screens.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:awesome_dialog/awesome_dialog.dart';
class NotificationScreen extends StatefulWidget {
  const NotificationScreen({ Key? key }) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List _veiwNotificationListForOneUser=[{"TextPost":"hello1","feeling":"Happy 😄"},
            {"TextPost":"hello2","feeling":"Sad"},
            {"TextPost":"hello3","feeling":"sd3"},
            {"TextPost":"hello4","feeling":"sd3"}];
  var _UserId;
  String _feeling="";
  double Iconsize=0.0;
  var competitiorToken="";
  var favoriteIcon=Icons.favorite;
  var deleteIcon=Icons.delete_forever;
  var CommentIcon=Icons.mode_comment;
  var CompetitionIcon=Icons.emoji_events;
  var IconNotification=Icons.autorenew;
  var titleName="loading";
  var notiImage="loadingImage.gif";
  var myName="loading";
  var myImage="loadingImage.gif";
  bool _contentVisable=true;
  @override
  void initState() {
    setState(() {
      _loadNotificationOfOneUser();
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
      centerTitle: true,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.notifications),
          SizedBox(width: 8,),
          Text('Notification'),
        ],
      ),
      backgroundColor: AppColor.darkColor,
      leading: IconButton(onPressed: (){
        Navigator.pop(context);
      }, icon: Icon(Icons.arrow_back_ios)),
    ),
    body:SingleChildScrollView(
      child: Column(
        children: [
          if(_contentVisable) Container(margin: EdgeInsets.only(top: 50), child: Center(child: Image(image: AssetImage('assets/images/loading_login.gif'),width: 50,),),) else FutureBuilder(
                  future: _loadNotificationOfOneUser(),
                  builder: (context,snapshot){
                    if(snapshot.hasData){
                      
                      return ListView.builder(
                        reverse: true,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        
                          itemCount: _veiwNotificationListForOneUser.length,
                          itemBuilder: (context, index) {
                            if(_veiwNotificationListForOneUser[index]['icon']=="favorite"){
                              IconNotification=favoriteIcon;
                              Iconsize=25;
                              titleName="${_veiwNotificationListForOneUser[index]['first_name']} ${_veiwNotificationListForOneUser[index]['last_name']}";
                              notiImage=_veiwNotificationListForOneUser[index]['image'];
                            }else if(_veiwNotificationListForOneUser[index]['icon']=="mode_comment"){
                              IconNotification=CommentIcon;
                              Iconsize=25;
                              titleName="${_veiwNotificationListForOneUser[index]['first_name']} ${_veiwNotificationListForOneUser[index]['last_name']}";
                              notiImage=_veiwNotificationListForOneUser[index]['image'];
                            }
                            else if(_veiwNotificationListForOneUser[index]['icon']=="competition"||
                            _veiwNotificationListForOneUser[index]['icon']=="com_lost"||
                            _veiwNotificationListForOneUser[index]['icon']=="com_won"||
                            _veiwNotificationListForOneUser[index]['icon']=="com_reject"
                            ){
                              IconNotification=CompetitionIcon;
                              Iconsize=28;
                              competitiorToken=_veiwNotificationListForOneUser[index]['Token'];
                            
                              titleName="${_veiwNotificationListForOneUser[index]['first_name']} ${_veiwNotificationListForOneUser[index]['last_name']}";
                              notiImage=_veiwNotificationListForOneUser[index]['image'];
                              
                            }else if(_veiwNotificationListForOneUser[index]['icon']=="com_accept"){
                              //acceptnotification();
                              IconNotification=CompetitionIcon;
                              Iconsize=28;
                              competitiorToken=_veiwNotificationListForOneUser[index]['Token'];
                              titleName="NOcotine";
                              notiImage="logo.png";
                              
                              
                            }else if(_veiwNotificationListForOneUser[index]['icon']=="delete_post"
                            ||_veiwNotificationListForOneUser[index]['icon']=="delete_comment"
                            ){
                              IconNotification=deleteIcon;
                              Iconsize=25;
                              titleName="NOcotine";
                              notiImage="logo.png";
                              
                              
                            }else{
                              titleName="loading";
                              notiImage="loadingImage.gif";
                            }
                          return   Column(
                            children: [
                              Card(
                                child: ListTile(
                                  leading:  CircleAvatar(
                                          backgroundImage: NetworkImage("${ImageUrl}$notiImage"),
                                          backgroundColor: AppColor.whiteColor,
                                          radius: 20,
                                        ),
                                  title: RichText(
                                    text:  TextSpan(children: [
                                      TextSpan(
                                          text: "$titleName ",
                                          style: TextStyle(
                                              fontSize: 15,fontWeight: FontWeight.bold, color: Colors.black)),
                                      TextSpan(
                                          text: "${_veiwNotificationListForOneUser[index]['body']}",
                                          style: TextStyle(
                                              fontSize: 15, color: Colors.black)),
                                      
                                    ]),
                                  ),
                                      
                                      
                                  
                                  subtitle: Text("${_veiwNotificationListForOneUser[index]['date']}"),
                                  trailing: Icon(IconNotification,color: AppColor.lightyColor,size:Iconsize ,),
                                  onTap: ()async{
                                    if(_veiwNotificationListForOneUser[index]['icon']=="competition"){
                                      AwesomeDialog(
                                        context: context,
                                        dialogType: DialogType.NO_HEADER,
                                        animType: AnimType.BOTTOMSLIDE,
                                        title: 'Invitation request', 
                                        desc: 'Would you like to accept the invitation',
                                        btnOkOnPress: () {
                                          setState(() {
                                            acceptInvite(_veiwNotificationListForOneUser[index]['id'],_veiwNotificationListForOneUser[index]['first_name']+_veiwNotificationListForOneUser[index]['last_name']);
                                          });
                                        },
                                        btnCancelOnPress: () {
                                          setState(() {
                                            rejectInvite(_veiwNotificationListForOneUser[index]['id']);
                                          });
                                        },
                                        btnCancelIcon: Icons.close,
                                        btnCancelText: "",
                                        btnOkIcon: Icons.done,
                                        btnOkText: ""
                                        
                                        )..show();
                                    }else if(_veiwNotificationListForOneUser[index]['icon']=="com_lost"||
                                              _veiwNotificationListForOneUser[index]['icon']=="com_won"||
                                              _veiwNotificationListForOneUser[index]['icon']=="com_draw"||
                                              _veiwNotificationListForOneUser[index]['icon']=="com_reject"){
                                      
                                    }else if(_veiwNotificationListForOneUser[index]['icon']=="com_accept"){
                                      SharedPreferences preferences = await SharedPreferences.getInstance();
                                      if (mounted) setState(() {
                                        preferences.setInt(routeIndex, 1);
                                      print(preferences.getInt(routeIndex));
                                      Navigator.pushNamed(context, Screens.mainScreen.value);
                                      });
                                    }else if(_veiwNotificationListForOneUser[index]['icon']=="delete_post"){
                                      
                                    }else{
                                      SavePostID(context, _veiwNotificationListForOneUser[index]['post_id']);
                                    }
                                    
                                  },
                                ),
                                
                              )
                            ],
                          ); });
                    
                    }
                    else{
                      return Container(margin: EdgeInsets.only(top: 50), child: Center(child: Image(image: AssetImage('assets/images/loading_login.gif'),width: 50,),),);
                    }
                  },
                ),
        ],
      ),
      
    )
    );
  }
  //send requst to get notification data
  _loadNotificationOfOneUser()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    _UserId=preferences.getString(id);
    var url = Uri.parse(viewNotificationUrl+"?User_id=$_UserId");
    var res = await http.get(url);
    var responseBody = jsonDecode(res.body);
    if(res.statusCode==200){
      _contentVisable=false;
      setState(() {
      _veiwNotificationListForOneUser=responseBody;
    });
    }
    
    return _veiwNotificationListForOneUser;
  }
  //dave post id to go another page
  SavePostID(BuildContext context,String _postid) async{
    
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // Save response
    
    preferences.setString(post_id, _postid);
    // push to home screen
    Navigator.pushNamed(context, Screens.comments.value);
    
  }
  //send requst to accept invite
  acceptInvite(String senderID,String senderName) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
      String dateDay = DateTime.now().day.toString();
      String dateMonth = DateTime.now().month.toString();
      String dateYear = DateTime.now().year.toString();
      var fUserName=preferences.getString(firstName);
      var lUserName=preferences.getString(lastName);
      var _my_token=preferences.getString(myToken);
      preferences.setString(Competitor_name, senderName);
      preferences.setString(Competitor_id, senderID);
      var _userId=preferences.getString(id);
      var url=Uri.parse(acceptInviteUrl);
      var response = await http.post(url,body: {
        "User_id_sender":senderID,
        "User_id_receiver":_userId,
      });
      if(response.statusCode==200){
        checkCompetition();
        sendPushMessage(competitiorToken, "your competition has started", "$fUserName $lUserName");
        addNewResultRequestNotificatin(senderID, "your competition has started", "$dateDay/$dateMonth/$dateYear", "com_accept");
        sendPushMessage(_my_token!, "your competition has started", "$senderName");
        addNewResultRequestNotificatin(_userId!, "your competition has started", "$dateDay/$dateMonth/$dateYear", "com_accept");
        print(response.body); 
      }
      
      
      
      
      }
  //send requst to reject invite
  rejectInvite(String senderID) async{
    String dateDay = DateTime.now().day.toString();
    String dateMonth = DateTime.now().month.toString();
    String dateYear = DateTime.now().year.toString();
    SharedPreferences preferences = await SharedPreferences.getInstance();
      var fUserName=preferences.getString(firstName);
      var lUserName=preferences.getString(lastName);
      var _userId=preferences.getString(id);
      var url=Uri.parse(rejectInviteUrl);
      var response = await http.post(url,body: {
        "User_id_sender":senderID,
        "User_id_receiver":_userId,
      });
      if(response.statusCode==200){
        sendPushMessage(competitiorToken, "has rejected your competition", "$fUserName $lUserName");
        addNewResultRequestNotificatin(senderID, "has rejected your competition", "$dateDay/$dateMonth/$dateYear", "com_reject");
        
        print(response.body);
      }
      
      
      
      
      }
  //check if there is competition or not
  checkCompetition()async{
    
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var compeititor1_id=preferences.getString(id);
    var url = Uri.parse(viewTimerCompetitionUrl);
    var res = await http.post(url,body: {
          
          "compeititor1_id":compeititor1_id,
        });
    List responseBody = jsonDecode(res.body);
    if(res.statusCode==200){
        if(responseBody==null||responseBody==[]||responseBody.length==0||responseBody.isEmpty){
          print("${res.body}");
          return;
        }else{
          if(responseBody[0]['receiver_accept']=="1"){
            if(compeititor1_id==responseBody[0]['sender_id']){
              preferences.setString(Competitor2_id_receiver, responseBody[0]['receiver_id']);
              preferences.setString(End_time_competition, responseBody[0]['end_time']);
              preferences.setString(Visable_timer, "true");
              //print("//////////////////////////${preferences.getString(Visable_timer)}");
          }else if(compeititor1_id==responseBody[0]['receiver_id']){
              preferences.setString(Competitor2_id_sender, responseBody[0]['sender_id']);
              preferences.setString(End_time_competition, responseBody[0]['end_time']);
              preferences.setString(Visable_timer, "true");
              //print("//////////////////////////${preferences.getString(Visable_timer)}");
          }
        print("Data Saved");
        }
        }
      }else{
        print("Not Found Competition");
        return;
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
  //send requst to add new competition result notification to notification table db
  addNewResultRequestNotificatin(String _CompetitorId,String _body,String _Date,String _icon) async{
      SharedPreferences preferences = await SharedPreferences.getInstance();
      var _UserId=preferences.getString(id);
        var url=Uri.parse(createNotificationUrl);
      var response = await http.post(url,body: {
        "post_id":"0",
        "user_id_sender":_UserId,
        "user_id_reciever":_CompetitorId,
        "body":_body,
        "icon":_icon,
        "date":_Date,
      });
      print("Status Code: ${response.statusCode} \n Body: ${response.body}");
      if(response.statusCode==200){
        print("${response.body}");
  
        updateCountNotification(_CompetitorId);
        
        
      }else{
        print("##########################${response.statusCode}${response.body}");
      }
  
      
      
}
  //send requst update count notification number in the user
  updateCountNotification(String _competitorID) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
      
      var _userId=preferences.getString(id);
      var url=Uri.parse(updateCountNotificationUrl);
      
      var response = await http.post(url,body: {
        "user_id":_competitorID
      });
      if(response.statusCode==200){
        print(response.body);
      }
      
      
      
      
      }
  acceptnotification()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      myName="${preferences.getString(firstName)} ${preferences.getString(lastName)}";
    myImage=preferences.getString(image)!;
    });
    
  }
}