// main.dart
import 'package:intl/intl.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:nocotine/constants/cofig_api.dart';
import 'package:nocotine/constants/colors.dart';
import 'package:nocotine/constants/screens.dart';
import 'package:nocotine/screens/competition_screen.dart';
import 'package:nocotine/screens/other_profile_screen.dart';
import 'package:nocotine/screens/search_Myprofile_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
class CompetitionSearch extends StatefulWidget {
  const CompetitionSearch({Key? key}) : super(key: key);

  @override
  _CompetitionSearchState createState() => _CompetitionSearchState();
}

class _CompetitionSearchState extends State<CompetitionSearch> {
  TextEditingController _SearchBarController=new TextEditingController();
  // This holds a list of fiction users
  // You can use data fetched from a database or a server as well
  List<Map<String, dynamic>> _allUsers = [
    
  ];
   List _exceptionUsers = [
    
  ];
  // This list holds the data for the list view
  List<Map<String, dynamic>> _foundUsers = [];
  TextEditingController CompetitorControllor=new TextEditingController();
  var DurationCounter=1;
  var selectCompetitorImage="loadingImage.gif";
  var selectCompetitorName="";
  var selectCompetitorToken="";
  bool visableCompetitorCard=false;
  var selectCompetitorID="";
  Color? cardColor;
  var emptyCompUsername="";
  bool texterrorCompUsername = false;
  bool sendInviteVisable = true;
  bool _visableExceptionUsers=false;
  bool visableContent=true;
  @override
  initState() {
    setState(() {
      loadUsers();
      CompetitionExceptionUsers();
    });
    // at the beginning, all users are shown
    _foundUsers = _allUsers;
    super.initState();
  }

  // This function is called whenever the text field changes
  void _runFilter(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      //results = _allUsers;
    } else {
      results = _allUsers
          .where((user) =>
              user["Name"].toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      _foundUsers = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
      centerTitle: true,
      automaticallyImplyLeading: false,
      title:
          Text('Competition Invite'),
      backgroundColor: AppColor.darkColor,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: ()async{
        SharedPreferences preferences = await SharedPreferences.getInstance();
        if (mounted) setState(() {
          preferences.setInt(routeIndex, 1);
        print(preferences.getInt(routeIndex));
        Navigator.pushNamed(context, Screens.mainScreen.value);
        });
        },
      ),
    ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if(visableContent)Column(
              children: [
                    SizedBox(height: 50,),
                    if (visableCompetitorCard)Container(
                      height: 70,
                      width: double.infinity,
                      margin: EdgeInsets.only(left: 30,right:30 ),
                      child: Card(
                      elevation: 2,
                      child:  ListTile(
                      leading: CircleAvatar(
                                backgroundColor: AppColor.infoyColor,
                                radius: 15,
                                backgroundImage:NetworkImage("$ImageUrl$selectCompetitorImage"),
                              ),
                      title: Center(child: Text("$selectCompetitorName"),),
                      trailing: InkWell(
                        onTap: (){
                          setState(() {
                            
                            visableCompetitorCard=false;
                            selectCompetitorID="";
                            selectCompetitorImage="";
                            selectCompetitorName="";
                            selectCompetitorToken="";
                          });
                        },
                        child:  CircleAvatar(
                                backgroundColor: AppColor.infoyColor,
                                radius: 15,
                                backgroundImage:AssetImage("assets/images/remove_user.gif"),
                              ),
                      )
                    ),
                  ),)
                    else Container(height: 70,), 
                    SizedBox(height: 70,),
                    Container(
                      padding: EdgeInsets.only(left: 20,right: 20),
                      child:   TextFormField(
                                    cursorColor: AppColor.infoyColor,
                                    
                                    controller: _SearchBarController,
                                    
                                    onChanged: (value) {
                                      _runFilter(value);
                                      _foundUsers.remove(value);
                                    },
                                    decoration:  InputDecoration(
                                      prefixIcon:  Icon(Icons.person,color: AppColor.infoyColor,),
                                  suffixIcon:  IconButton(onPressed: (){
                                    setState(() {
                                      _SearchBarController.text="";
                                      _runFilter(_SearchBarController.text);
                                    });
                                  }, icon: Icon(Icons.clear,color: AppColor.infoyColor)),
                                        hintText: "Competitor's Username",
                                        errorText: texterrorCompUsername?"$emptyCompUsername":null,
                                        enabledBorder: UnderlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                
                                borderSide: BorderSide(
                                  color: AppColor.darkColor,width: 4)

                              ),
                                        focusedBorder: UnderlineInputBorder(
                                
                                borderRadius: BorderRadius.circular(10),
                                
                                borderSide: BorderSide(
                                  width: 3,
                                  color: AppColor.darkColor,
                                  
                                  ),
                                  
                            )
                                        ),
                                        
                                  ),
                        
                    )
              , 
              
                Container(
                  margin: EdgeInsets.only(top: 25),
                  padding: EdgeInsets.only(left: 20,right: 20),
                  child:   Stack(children: [
                      ListView(
                        shrinkWrap: true,
                        children: [
                          
                          Center(child: Text("Duration per Days",style: TextStyle(color: AppColor.infoyColor,fontSize: 16),),),
                          
                            Container(
                              child: SpinBox(
                              min: 1,
                              max: 14,
                              value: 1,
                              step: 01,
                              iconColor: MaterialStateProperty.resolveWith((states) {
                                        if (states.contains(MaterialState.disabled)) {
                                          return Colors.grey;
                                        }
                                        if (states.contains(MaterialState.error)) {
                                          return Colors.red;
                                        }
                                        if (states.contains(MaterialState.focused)) {
                                          return AppColor.primaryColor;

                                        }
                                        return AppColor.primaryColor;
                                      }),
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: AppColor.whiteColor,
                                  enabledBorder: UnderlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: AppColor.darkColor,width: 4)
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      width: 4,
                                      color: AppColor.darkColor,
                                      ),
                                ),
                          ),
                              onChanged: (value) {
                                setState(() {
                                  DurationCounter=value.toInt();
                                
                                print(DurationCounter);
                                });
                              }
                                            ),
                                  ),
                            
                            
                                      
                              
                          
                        ],
                      ),
                      Scrollbar(child: Container(
                        color: AppColor.whiteColor,
                        constraints: BoxConstraints(
                          maxHeight: 300
                          ),
                        child:ListView.builder(
                            shrinkWrap: true,
                              itemCount: _foundUsers.length,
                              itemBuilder: (context, index) => Container(
                                color: AppColor.whiteColor,
                                child: FutureBuilder(
                                  future: CompetitionExceptionUsers(),
                                  builder: (context,snapshot){
                                    if(snapshot.hasData){
                                      for(var i=0;i<_exceptionUsers.length;i++){
                                          if(_foundUsers[index]["id"]==_exceptionUsers[i]['sender_id']
                                          ||_foundUsers[index]["id"]==_exceptionUsers[i]['receiver_id']
                                          ){
                                              _visableExceptionUsers=true;
                                          }else{
                                              _visableExceptionUsers=false;
                                          }
                                        }
                                        if(_visableExceptionUsers){
                                          return Card(
                                                elevation: 2,
                                                child: ListTile(
                                                leading:  Icon(Icons.hourglass_bottom),
                                                title: Text(_foundUsers[index]['Name'],style: TextStyle(fontWeight: FontWeight.bold,color: AppColor.infoyColor,decoration: TextDecoration.lineThrough,decorationThickness: 2),),
                                                subtitle: Text(
                                                    '${_foundUsers[index]["email"].toString()}'),
                                                onTap: (){
                                                  Dialogs.materialDialog(
                                                    color: Colors.white,
                                                    msg: "${_foundUsers[index]['Name']} in another competition.",
                                                    title: 'Please Wiat',
                                                    lottieBuilder: Lottie.asset(
                                                      'assets/images/wait.json',
                                                      fit: BoxFit.contain,
                                                    ),
                                                    context: context,
                                                    actions: [
                                                      InkWell(
                                                                    child: Container(
                                                                      padding: EdgeInsets.all(10),
                                                                      width: 120,
                                                                      child: Center(child: Text("OK",style: TextStyle(color: AppColor.whiteColor,fontWeight: FontWeight.bold),)),
                                                                      decoration: BoxDecoration(
                                                                          color: AppColor.primaryColor,
                                                                            borderRadius: BorderRadius.only(
                                                                                topLeft: Radius.circular(15),
                                                                                topRight: Radius.circular(15),
                                                                                bottomLeft: Radius.circular(15),
                                                                                bottomRight: Radius.circular(15),
                                                                            ),
                                                                      
                                                                      )),
                                                                    onTap: (){
                                                                      Navigator.pop(context);
                                                                    }
                                                                  ),
                                                    ],
                                                  
                                                
                                                );
      
                                                },
                                              ),
                                              );
                                        }else{
                                          return  Card(
                                              elevation: 2,
                                            //margin: const EdgeInsets.symmetric(vertical: 5),
                                              child: ListTile(
                                              leading:  Icon(Icons.search,color: AppColor.blackColor,),
                                              title: Text(_foundUsers[index]['Name'],style: TextStyle(fontWeight: FontWeight.bold,color: cardColor),),
                                              subtitle: Text(
                                                  '${_foundUsers[index]["email"].toString()}'),
                                              onTap: (){
                                                setState(() {
                                                  selectCompetitorID=_foundUsers[index]["id"];
                                                  selectCompetitorImage=_foundUsers[index]["image"];
                                                  selectCompetitorName=_foundUsers[index]['Name'];
                                                  selectCompetitorToken=_foundUsers[index]['Token'];
                                                  visableCompetitorCard=true;
                                                  _SearchBarController.text="";
                                                  _foundUsers=[];
                                                  texterrorCompUsername = false;
                                                  
                                                });
                                              },
                                            ),
                                            );
                                                    }
                                      
                                    }
                                    else{
                                      return  Card(
                                  elevation: 2,
                                //margin: const EdgeInsets.symmetric(vertical: 5),
                                  child: ListTile(
                                  leading:  Icon(Icons.search),
                                  title: Text(_foundUsers[index]['Name'],style: TextStyle(fontWeight: FontWeight.bold,color: cardColor),),
                                  subtitle: Text(
                                      '${_foundUsers[index]["email"].toString()}'),
                                  onTap: (){
                                    setState(() {
                                      selectCompetitorID=_foundUsers[index]["id"];
                                      selectCompetitorImage=_foundUsers[index]["image"];
                                      selectCompetitorName=_foundUsers[index]['Name'];
                                      selectCompetitorToken=_foundUsers[index]['Token'];
                                      visableCompetitorCard=true;
                                      _SearchBarController.text="";
                                      _foundUsers=[];
                                      texterrorCompUsername = false;
                                    
                                    });
                                  },
                                ),
                                );
                                    }
                                  },
                                ),
      
                            )
                    
                    
                  
                
      
                      )
                  )
                  )],)
                ,
                )
                ,SizedBox(height: 25,),
                if(sendInviteVisable) InkWell(
                            child: Container(
                              padding: EdgeInsets.all(10),
                              width: 130,
                              child: Center(child: Text("Send Invitation",style: TextStyle(color: AppColor.whiteColor,fontWeight: FontWeight.bold),)),
                              decoration: BoxDecoration(
                                  color: AppColor.darkColor,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        topRight: Radius.circular(15),
                                        bottomLeft: Radius.circular(15),
                                        bottomRight: Radius.circular(15),
                                    ),
                              
                              )),
                            onTap: (){
                              if(visableCompetitorCard==false){
                                setState(() {
                                  texterrorCompUsername = true;
                                  emptyCompUsername="Required";
                                  return;
                                });
                        
                            }else{
                              setState(() {
                                visableContent=false;
                                texterrorCompUsername = false;
                                addNewCompetition();
                              });
                            }
                            }
                          )else InkWell(
                            child: Container(
                              padding: EdgeInsets.all(10),
                              width: 130,
                              child: Center(child: Text("Sent !",style: TextStyle(color: AppColor.whiteColor,fontWeight: FontWeight.bold),)),
                              decoration: BoxDecoration(
                                  color: AppColor.infoyColor,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        topRight: Radius.circular(15),
                                        bottomLeft: Radius.circular(15),
                                        bottomRight: Radius.circular(15),
                                    ),
                              
                              )),
                            onTap: (){

                            }
                          )
              

                ],
            )else Container(margin: EdgeInsets.only(top: 50), child: Center(child: Image(image: AssetImage('assets/images/loading_login.gif'),width: 50,),),),
          ],
        )),
      )
            
        
                
              ;

    
  }
  //send requst to get users to send invite competiton
  loadUsers()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt(routeIndex, 0);
    var UserID=preferences.getString(id);
  var url = Uri.parse(competitionSearchUrl);
  var res = await http.post(url,body: {
        "user_id":UserID,
      }); 
    
    var responseBody=(jsonDecode(res.body) as List).map((e) => e as Map<String, dynamic>).toList();
    _allUsers=responseBody;
    return _allUsers;

  }
  //send requst to add new competiton requst 
  addNewCompetition() async{
      SharedPreferences preferences = await SharedPreferences.getInstance();
      var UserId=preferences.getString(id);
      int durationDays=DurationCounter.toInt();
      DateTime now = new DateTime.now();;
      DateTime endDate = now.add(Duration(days:durationDays));
      var url=Uri.parse(createCompetitionUrl);
      var response = await http.post(url,body: {
        
        "sender_id":UserId,
        "receiver_id":selectCompetitorID,
        "duration":DurationCounter.toString(),
        "end_time":endDate.toString()
      }
      );
      
      print("Status Code: ${response.statusCode} \n Body: ${response.body}");
      if(response.statusCode==200){
        var _firstName=preferences.getString(firstName);
        var _lastName=preferences.getString(lastName);
        setState(() {
          String dateDay = DateTime.now().day.toString();
          String dateMonth = DateTime.now().month.toString();
          String dateYear = DateTime.now().year.toString();
          var _firstName=preferences.getString(firstName);
        var _lastName=preferences.getString(lastName);
        //sendPushMessage(selectCompetitorToken, "Sent You An Invitation", "$_firstName $_lastName");
          addNewCompetitorNotification("sent you an invitation", "competition", "$dateDay/$dateMonth/$dateYear");
        });
      
      
      }


}
  //send requst update count notification number in the user
  updateCountNotification() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
      
      var _userId=preferences.getString(id);
      var url=Uri.parse(updateCountNotificationUrl);
      
      var response = await http.post(url,body: {
        "user_id":selectCompetitorID
      });
      if(response.statusCode==200){
        print(response.body);
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
  //send requst to send requst Notification to other user
  addNewCompetitorNotification(String _body,String Icon,String Date) async{
      SharedPreferences preferences = await SharedPreferences.getInstance();

      var UserId=preferences.getString(id);
      
        var url=Uri.parse(createNotificationUrl);
      var response = await http.post(url,body: {
        "post_id":"0",
        "user_id_sender":UserId,
        "user_id_reciever":selectCompetitorID,
        "body":_body,
        "icon":Icon,
        "date":Date,
      });
      print("Status Code: ${response.statusCode} \n Body: ${response.body}");
      if(response.statusCode==200){
        
        print("${response.body}");
        var _firstName=preferences.getString(firstName);
        var _lastName=preferences.getString(lastName);
        updateCountNotification();
        sendPushMessage(selectCompetitorToken, "sent you an invitation", "$_firstName $_lastName");
        setState(() {
          visableContent=true;
          sendInviteVisable=false;
        });
        AwesomeDialog(
                  context: context,
                  dialogType: DialogType.SUCCES,
                  animType: AnimType.BOTTOMSLIDE,
                  title: 'Invitation sent', 
                  desc: 'Please wait for your competitor to accept',
                  btnOkOnPress: () {
                    setState((){
                      sendInviteVisable=false;
                      goBack();
                    });
                  },
                  showCloseIcon: false,
                  
                  )..show();
      }
  
      
      
}
  //send requst to get users in other competiton
  CompetitionExceptionUsers()async{
  var url = Uri.parse(competitionExceptionUsersUrl);
  var res = await http.get(url); 
    
    var responseBody=(jsonDecode(res.body) as List).map((e) => e as Map<String, dynamic>).toList();
    _exceptionUsers=responseBody;
    return _exceptionUsers;
  }
  //function to back last page
  goBack()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (mounted) setState(() {
      preferences.setInt(routeIndex, 1);
    print(preferences.getInt(routeIndex));
    Navigator.pushNamed(context, Screens.mainScreen.value);
    });
  }
}