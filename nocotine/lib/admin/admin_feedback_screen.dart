import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:nocotine/constants/cofig_api.dart';
import 'package:nocotine/constants/colors.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';
class AdminFeedback extends StatefulWidget {
  const AdminFeedback({ Key? key }) : super(key: key);

  @override
  State<AdminFeedback> createState() => _AdminFeedbackState();
}

class _AdminFeedbackState extends State<AdminFeedback> {
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
  List veiwFeedbackList=[];
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
  String PostID="";
  String UserIdPost="";
  TextEditingController _PostController=new TextEditingController();
  bool _contentVisable=true;
  @override
  void initState() {
    loadFeedback();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Feedback"),
        backgroundColor: AppColor.darkColor,
        leading: IconButton(onPressed: (){
        Navigator.pop(context);
      }, icon: Icon(Icons.arrow_back_ios)),
      ),
      body:  Column(
        children: [
          if(_contentVisable)  Expanded(
            child: Container(
                      color: Colors.white,
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                        itemCount: 5,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.all(5),
                              child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Shimmer.fromColors(
                                    child: Column(
                                      children: [
                                        Container( decoration: 
                                        BoxDecoration(
                                          color: AppColor.whiteColor,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(5.0), 
                                            ),
                                          ),
                                          margin: EdgeInsets.only(top: 5),
                                          width: double.infinity,
                                          height: 100,)
                                              
                                            ],
                                          ),
                                            baseColor: Colors.black12,
                                            highlightColor: Colors.black38)),
                      
                                    
                              );})),
          )else
          Expanded(child: SingleChildScrollView(
            child: ListView.builder(
                    reverse: true,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: veiwFeedbackList.length,
                    itemBuilder: (BuildContext context,int index){
                      return Card(
                        child: Container(
                                padding: EdgeInsets.all(15),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        InkWell(
                                                child: Row(
                                                  children: [
                                                  CircleAvatar(
                                                    backgroundColor: AppColor.infoyColor,
                                                    radius: 17,
                                                    backgroundImage:NetworkImage("$ImageUrl${veiwFeedbackList[index]['image']}"),
                                                  ),
                                                  SizedBox(width: 10,),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text("${veiwFeedbackList[index]['first_name']} ${veiwFeedbackList[index]['last_name']} ",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                                                      Text("${veiwFeedbackList[index]['date']}",style: TextStyle(color: AppColor.infoyColor),),
                                                      
                                                    ],
                                                  )
                                                ],),
                                                onTap: ()async{
                                                  //TODO
                                                
                                                },
                                              ),
                                              RatingBar.builder(
                                                
                                                itemSize: 20,
                                                ignoreGestures: true,
                                                    initialRating: double.parse(veiwFeedbackList[index]['rate']),
                                                    direction: Axis.horizontal,
                                                    allowHalfRating: true,
                                                    itemCount: 5,
                                                    itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                                                    itemBuilder: (context, _) => Icon(
                                                      Icons.star,
                                                      color: Colors.amber,
                                                    ),
                                                    onRatingUpdate: (rating) {
                                                      print(rating);
                                                    },
                                                  ),
                                              
                                      ],
                                    ),
                                    SizedBox(height: 20,),
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Text("${veiwFeedbackList[index]['feedback_comment']}",style: TextStyle(fontSize: 17,fontWeight: FontWeight.w400),),
                                    )
                                  ],
                                ),
                              )
                  
          );
        }
        ),
          )
                
              )
        ],
      )
            
      
    );
  }
  //send requst to get Feedback data from db
  loadFeedback()async{
    
  var url = Uri.parse(viewFeedbackUrl);
  var res = await http.post(url); 
  var responseBody = jsonDecode(res.body);
  if(res.statusCode==200){
    if(mounted)setState(() {
    veiwFeedbackList=responseBody;
    _contentVisable=false;
  });
  }
  
  
  return veiwFeedbackList;
  }
  
}