import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:nocotine/constants/cofig_api.dart';
import 'package:nocotine/constants/colors.dart';
class AdminCopmCopmleted extends StatefulWidget {
  const AdminCopmCopmleted({ Key? key }) : super(key: key);

  @override
  State<AdminCopmCopmleted> createState() => _AdminCopmCopmletedState();
}

class _AdminCopmCopmletedState extends State<AdminCopmCopmleted> {
  bool _contentVisable=true;
  List veiwCompetitionResultList=[];
  @override
  void initState() {
    loadCopmetitonsResult();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body:Column(
        children: [
          if(_contentVisable) Container(margin: EdgeInsets.only(top: 50), child: Center(child: Image(image: AssetImage('assets/images/loading_login.gif'),width: 50,),),) else
          Expanded(child: SingleChildScrollView(
            child: ListView.builder(
                    reverse: true,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: veiwCompetitionResultList.length,
                    itemBuilder: (BuildContext context,int index){
                      return Card(
                        child: Container(
                                padding: EdgeInsets.all(15),
                                child: InputDecorator(
                                decoration: InputDecoration(
                                  labelText: 'End date: ${veiwCompetitionResultList[index]['date']}',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    
                                  ),
                                ),
                                child:

                Column(
                                  
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            CircleAvatar(
                                                    backgroundColor: AppColor.infoyColor,
                                                    radius: 17,
                                                    backgroundImage:NetworkImage("$ImageUrl${veiwCompetitionResultList[index]['image_win']}"),
                                                  ),
                                            SizedBox(width: 10,),
                                            Text("${veiwCompetitionResultList[index]['fname_win']} ${veiwCompetitionResultList[index]['lname_win']} ",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                                          ],
                                        ),
                                        Text("Winner",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: AppColor.greenColor),),     
                                      ],
                                    ),
                                    SizedBox(height: 15,),
                                    Row(
                                      
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            CircleAvatar(
                                                    backgroundColor: AppColor.infoyColor,
                                                    radius: 17,
                                                    backgroundImage:NetworkImage("$ImageUrl${veiwCompetitionResultList[index]['image_lose']}"),
                                                  ),
                                            SizedBox(width: 10,),
                                            Text("${veiwCompetitionResultList[index]['fname_lose']} ${veiwCompetitionResultList[index]['lname_lose']} ",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                                          ],
                                        ),
                                        Text("Loser ",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: AppColor.ErrorColor),),       
                                      ],
                                    ),
                                    ],
                                )
                              ,
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
  //send requst to get Copmetitons Result data from db
  loadCopmetitonsResult()async{
    
  var url = Uri.parse(viewCompetitionResultUrl);
  var res = await http.post(url); 
  var responseBody = jsonDecode(res.body);
  if(res.statusCode==200){
    if(mounted)setState(() {
    veiwCompetitionResultList=responseBody;
    _contentVisable=false;
  });
  }
  
  return veiwCompetitionResultList;
  }
  
}