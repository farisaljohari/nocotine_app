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
class PostsScreen extends StatefulWidget {
  const PostsScreen({ Key? key }) : super(key: key);

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  TextEditingController _BioController=new TextEditingController();
  var SaveBio="Bio";
  var _Name="";
  var _UserId;
  bool _visbleLike=false;
  var _userId;
  String dec="";
  final String assetName = 'assets/images/pack.svg';
  List _veiwPostListForOneUser=[];
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
                        child:Column(
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
                                                      Icon(Icons.visibility,color: Colors.grey,),
                                                  SizedBox(width: 15,),
                                                  Text("View",style: TextStyle(color: Colors.grey),),
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
                                                      deletePost(_veiwPostListForOneUser[index]['post_id']);
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
                              Icon(Icons.thumb_up,size: 17,color: AppColor.infoyColor,),
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
                        child:Column(
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
                                                      Icon(Icons.visibility,color: Colors.grey,),
                                                  SizedBox(width: 15,),
                                                  Text("View",style: TextStyle(color: Colors.grey),),
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
                                                      deletePost(_veiwPostListForOneUser[index]['post_id']);
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
                              Icon(Icons.thumb_up,size: 17,color: AppColor.infoyColor,),
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

                }
              
            ),
      )
                
            
        ],
      )    ,
    );
  }
  //get user data from shared prefrence
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
    SharedPreferences preferences = await SharedPreferences.getInstance();
    _UserId=preferences.getString(id);
    var url = Uri.parse(veiwOneUserPostsUrl+"?User_id=$_UserId");
    var res = await http.get(url);
    var responseBody = jsonDecode(res.body);
    setState(() {
      ShowProgress=true;
      _veiwPostListForOneUser=responseBody;
    });
    return _veiwPostListForOneUser;
  }
  //save post id to go anthor page
  _SavePostID(BuildContext context,String _postid) async{
    
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // Save response
    
    preferences.setString(post_id, _postid);
    // push to home screen
    Navigator.pushNamed(context, Screens.comments.value);
    
  }
  //send requst to delete  post
  deletePost(String PostID) async{

      var url=Uri.parse(deletePostUrl);
      var response = await http.post(url,body: {
        "post_id":PostID,
      });
      if(response.statusCode==200){
        print("Body: ${response.body}");
      }
    
      
      }
  
}
