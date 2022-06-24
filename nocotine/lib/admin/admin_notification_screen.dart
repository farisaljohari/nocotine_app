import 'package:flutter/material.dart';
import 'package:nocotine/constants/colors.dart';
import 'package:nocotine/constants/screens.dart';
import 'dart:convert';
import 'dart:ffi';
import 'package:nocotine/constants/cofig_api.dart';
import 'package:nocotine/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:nocotine/constants/screens.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:awesome_dialog/awesome_dialog.dart';
class AdminNotification extends StatefulWidget {
  const AdminNotification({ Key? key }) : super(key: key);

  @override
  State<AdminNotification> createState() => _AdminNotificationState();
}

class _AdminNotificationState extends State<AdminNotification> {
  List _veiwNotification=[];
  var _UserId;
  String _feeling="";
  double Iconsize=0.0;
  var competitiorToken="";
  var postIcon=Icons.report;
  var CommentIcon=Icons.report;
  var IconNotification=Icons.autorenew;
  bool _contentVisable=true;
  @override
  void initState() {
    setState(() {
      _loadNotificationAdmin();
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
        Navigator.pushReplacementNamed(context, Screens.AdminHomeScreen.value);
      }, icon: Icon(Icons.arrow_back_ios))
      ),
      body:Column(
        children: [
          if(_contentVisable) Container(margin: EdgeInsets.only(top: 50), child: Center(child: Image(image: AssetImage('assets/images/loading_login.gif'),width: 50,),),) else
          FutureBuilder(
              future: _loadNotificationAdmin(),
              builder: (context,snapshot){
                if(snapshot.hasData){
                  return SingleChildScrollView(
            child: ListView.builder(
                    reverse: true,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    
                      itemCount: _veiwNotification.length,
                      itemBuilder: (context, index) {
                        if(_veiwNotification[index]['type']=="post"){
                          IconNotification=postIcon;
                          Iconsize=25;
                        }else if(_veiwNotification[index]['type']=="comment"){
                          IconNotification=CommentIcon;
                          Iconsize=25;
                        }
                      return   Column(
                        children: [
                          Card(
                                
                            child:Container(
                              padding: EdgeInsets.only(top: 10,bottom: 10),
                              child:  ListTile(
                              leading:  CircleAvatar(
                                      backgroundImage: AssetImage("assets/images/admin_notif.gif"),
                                      backgroundColor: AppColor.whiteColor,
                                      radius: 20,
                                    ),
                              title: RichText(
                                text:  TextSpan(children: [
                                  TextSpan(
                                      text: "${_veiwNotification[index]['body']}",
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.black)),
                                  
                                ]),
                              ),
                                  
                                  
                              
                              trailing: Icon(IconNotification,color: AppColor.lightyColor,size:Iconsize ,),
                              onTap: ()async{
                                if(_veiwNotification[index]['type']=="post"){
                                  SavePostID(context, _veiwNotification[index]['post_id']);
                                }else if(_veiwNotification[index]['type']=="comment"){
                                  print("${_veiwNotification[index]['comment_or_post_id']}");
                                  SaveCommentID(context, _veiwNotification[index]['comment_id']);
                                }
                                
                              },
                            ),
                            
                            )
                          )
                        
                          
                          ],
                      ); })
                
    );
    
                }
                else{
                  return Container(margin: EdgeInsets.only(top: 50), child: Center(child: Image(image: AssetImage('assets/images/loading_login.gif'),width: 50,),),);
                }
              },
            ),
      
        ],
      ));
  }
  //send requst to get Notification Admin data from db
  _loadNotificationAdmin()async{
    
    SharedPreferences preferences = await SharedPreferences.getInstance();
    _UserId=preferences.getString(id);
    var url = Uri.parse(viewAdminNotificationUrl);
    var res = await http.post(url);
    var responseBody = jsonDecode(res.body);
    
    if(res.statusCode==200){
      _contentVisable=false;
      setState(() {
      _veiwNotification=responseBody;
    });
    }
    return _veiwNotification;
  }
  //save post id to go anthor page
  SavePostID(BuildContext context,String _postid) async{
    
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // Save response
    
    preferences.setString(post_id, _postid);
    // push to home screen
    Navigator.pushNamed(context, Screens.AdminOnePost.value);
    
  }
  //save comment id to go anthor page
  SaveCommentID(BuildContext context,String _commentid) async{
    
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // Save response
    
    preferences.setString(post_id, _commentid);
    // push to home screen
    Navigator.pushNamed(context, Screens.AdminOneComment.value);
    
  }
  
  }