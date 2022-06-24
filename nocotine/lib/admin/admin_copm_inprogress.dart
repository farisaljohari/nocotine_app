
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:nocotine/constants/cofig_api.dart';
import 'package:nocotine/constants/colors.dart';
class AdminCopmInProgress extends StatefulWidget {
  const AdminCopmInProgress({ Key? key }) : super(key: key);

  @override
  State<AdminCopmInProgress> createState() => _AdminCopmInProgressState();
}

class _AdminCopmInProgressState extends State<AdminCopmInProgress> {
  bool _contentVisable=true;
  List veiwCompetitionInprogressList=[];
  bool _visableExceptionUsers=false;
  @override
  void initState() {
    loadCopmetitonsInProgress();
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
                    itemCount: veiwCompetitionInprogressList.length,
                    itemBuilder: (BuildContext context,int index)=> Container(
                            color: AppColor.whiteColor,
                            child: FutureBuilder(
                              future: loadCopmetitonsInProgress(),
                              builder: (context,snapshot){
                                if(snapshot.hasData){
                                  
                                      if(veiwCompetitionInprogressList[index]['receiver_accept']=="0"){
                                          _visableExceptionUsers=true;
                                      }else{
                                          _visableExceptionUsers=false;
                                      }
                                    
                                    if(_visableExceptionUsers){
                                      return Card(
                        child: Container(
                                padding: EdgeInsets.all(15),
                                child: InputDecorator(
                                decoration: InputDecoration(
                                  label: Container(
                                    width: 190,
                                    child:  Row(
                          children: [
                            Text('Pending request ..'),
                            SizedBox(width: 10,),
                            Image.asset("assets/images/wait.gif",width: 35,)
                          ],
                        ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    
                                  ),
                                ),
                                child:

                Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          
                                          children: [
                                            CircleAvatar(
                                                    backgroundColor: AppColor.infoyColor,
                                                    radius: 17,
                                                    backgroundImage:NetworkImage("$ImageUrl${veiwCompetitionInprogressList[index]['image_sender']}"),
                                                  ),
                                            SizedBox(width: 10,),
                                            
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text("${veiwCompetitionInprogressList[index]['fname_sender']} ${veiwCompetitionInprogressList[index]['lname_sender']} ",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                                                Text("sender",style: TextStyle(fontSize: 14,color: AppColor.infoyColor),),     

                                              ],
                                            )
                                          ],
                                        ),
                                      Wrap(
                                        
                                      direction: Axis.vertical,
                                      crossAxisAlignment: WrapCrossAlignment.center,
                                      children: [
                                        
                                        Icon(Icons.smoking_rooms,size: 20,),
                                        Text("${veiwCompetitionInprogressList[index]['counter_sender']} ",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),), 
                                      ],
                                    ),
                                      

                                      ],
                                    ),
                                    SizedBox(height: 15,),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            CircleAvatar(
                                                    backgroundColor: AppColor.infoyColor,
                                                    radius: 17,
                                                    backgroundImage:NetworkImage("$ImageUrl${veiwCompetitionInprogressList[index]['image_receiver']}"),
                                                  ),
                                            SizedBox(width: 10,),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text("${veiwCompetitionInprogressList[index]['fname_receiver']} ${veiwCompetitionInprogressList[index]['lname_receiver']} ",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                                                Text("receiver",style: TextStyle(fontSize: 14,color: AppColor.infoyColor),),     
                                              ],
                                            )
                                          ],
                                        ),
                                      Wrap(
                                        
                                      direction: Axis.vertical,
                                      crossAxisAlignment: WrapCrossAlignment.center,
                                      children: [
                                        
                                        Icon(Icons.smoking_rooms,size: 21,),
                                        Text("${veiwCompetitionInprogressList[index]['counter_receiver']} ",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),), 
                                      ],
                                    ),
                                      

                                  

                                      
                                      ],
                                    ),
                                    ],
                                )
                              ,
                              ),

                                )
                  
          );
        
                                    }else{
                                      return  Card(
                        child: Container(
                                padding: EdgeInsets.all(15),
                                child: InputDecorator(
                                decoration: InputDecoration(
                                  label: Container(
                                    width: 200,
                                    child:  Row(
                          children: [
                            Text('End date: ${veiwCompetitionInprogressList[index]['end_time'].toString().substring(0,10)}'),
                            SizedBox(width: 10,),
                            Image.asset("assets/images/inprog.gif",width: 35,)
                          ],
                        ),
                                  ),
                                  
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    
                                  ),
                                ),
                                child:

                Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          
                                          children: [
                                            CircleAvatar(
                                                    backgroundColor: AppColor.infoyColor,
                                                    radius: 17,
                                                    backgroundImage:NetworkImage("$ImageUrl${veiwCompetitionInprogressList[index]['image_sender']}"),
                                                  ),
                                            SizedBox(width: 10,),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text("${veiwCompetitionInprogressList[index]['fname_sender']} ${veiwCompetitionInprogressList[index]['lname_sender']} ",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                                                Text("sender",style: TextStyle(fontSize: 14,color: AppColor.infoyColor),),     
                                              ],
                                            )
                                            
                                          ],
                                        ),
                                      Padding(padding: EdgeInsets.only(bottom: 5),
                                      child: Wrap(
                                        
                                      direction: Axis.vertical,
                                      crossAxisAlignment: WrapCrossAlignment.center,
                                      children: [
                                        
                                        Icon(Icons.smoking_rooms,size: 20,),
                                        Text("${veiwCompetitionInprogressList[index]['counter_sender']} ",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),), 
                                      ],
                                    ),
                                      )

                                      ],
                                    ),
                                    SizedBox(height: 15,),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            CircleAvatar(
                                                    backgroundColor: AppColor.infoyColor,
                                                    radius: 17,
                                                    backgroundImage:NetworkImage("$ImageUrl${veiwCompetitionInprogressList[index]['image_receiver']}"),
                                                  ),
                                            SizedBox(width: 10,),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text("${veiwCompetitionInprogressList[index]['fname_receiver']} ${veiwCompetitionInprogressList[index]['lname_receiver']} ",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                                                Text("receiver",style: TextStyle(fontSize: 14,color: AppColor.infoyColor),),     
                                              ],
                                            )
                                            
                                          ],
                                        ),
                                        Padding(padding: EdgeInsets.only(bottom: 5),
                                      child: Wrap(
                                        
                                      direction: Axis.vertical,
                                      crossAxisAlignment: WrapCrossAlignment.center,
                                      children: [
                                        
                                        Icon(Icons.smoking_rooms,size: 21,),
                                        Text("${veiwCompetitionInprogressList[index]['counter_receiver']} ",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),), 
                                      ],
                                    ),
                                      )

                                  

                                      
                                      ],
                                    ),
                                    ],
                                )
                              ,
                              ),

                                )
                  
          );
                                                }
                                  
                                }
                                else{
                                    return  Card(
                        child: Container(
                                padding: EdgeInsets.all(15),
                                child: InputDecorator(
                                decoration: InputDecoration(
                                  label: Container(
                                    width: 200,
                                    child:  Row(
                          children: [
                            Text('Loading..'),
                          ],
                        ),
                                  ),
                                  
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    
                                  ),
                                ),
                                child:

                Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          
                                          children: [
                                            CircleAvatar(
                                                    backgroundColor: AppColor.infoyColor,
                                                    radius: 17,
                                                    backgroundImage:NetworkImage("$ImageUrl${veiwCompetitionInprogressList[index]['image_sender']}"),
                                                  ),
                                            SizedBox(width: 10,),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text("${veiwCompetitionInprogressList[index]['fname_sender']} ${veiwCompetitionInprogressList[index]['lname_sender']} ",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                                                Text("sender",style: TextStyle(fontSize: 14,color: AppColor.infoyColor),),     
                                              ],
                                            )
                                            
                                          ],
                                        ),
                                      Padding(padding: EdgeInsets.only(bottom: 5),
                                      child: Wrap(
                                        
                                      direction: Axis.vertical,
                                      crossAxisAlignment: WrapCrossAlignment.center,
                                      children: [
                                        
                                        Icon(Icons.smoking_rooms,size: 20,),
                                        Text("${veiwCompetitionInprogressList[index]['counter_sender']} ",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),), 
                                      ],
                                    ),
                                      )

                                      ],
                                    ),
                                    SizedBox(height: 15,),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            CircleAvatar(
                                                    backgroundColor: AppColor.infoyColor,
                                                    radius: 17,
                                                    backgroundImage:NetworkImage("$ImageUrl${veiwCompetitionInprogressList[index]['image_receiver']}"),
                                                  ),
                                            SizedBox(width: 10,),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text("${veiwCompetitionInprogressList[index]['fname_receiver']} ${veiwCompetitionInprogressList[index]['lname_receiver']} ",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                                                Text("receiver",style: TextStyle(fontSize: 14,color: AppColor.infoyColor),),     
                                              ],
                                            )
                                            
                                          ],
                                        ),
                                        Padding(padding: EdgeInsets.only(bottom: 5),
                                      child: Wrap(
                                        
                                      direction: Axis.vertical,
                                      crossAxisAlignment: WrapCrossAlignment.center,
                                      children: [
                                        
                                        Icon(Icons.smoking_rooms,size: 21,),
                                        Text("${veiwCompetitionInprogressList[index]['counter_receiver']} ",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),), 
                                      ],
                                    ),
                                      )

                                  

                                      
                                      ],
                                    ),
                                    ],
                                )
                              ,
                              ),

                                )
                  
          );
                                  }
                              },
                            ),
      
                        )
        ),
          )
                
              )
        ],
      )
    );
  }
  //send requst to get Copmetitons InProgress data from db
  loadCopmetitonsInProgress()async{
    
  var url = Uri.parse(viewCompetitionInprogresstUrl);
  var res = await http.post(url); 
  var responseBody = jsonDecode(res.body);
  if(res.statusCode==200){
    if(mounted)setState(() {
      
    veiwCompetitionInprogressList=responseBody;
    _contentVisable=false;
  });
  }
  return veiwCompetitionInprogressList;
  }

}