import 'dart:async';
import 'dart:ui';
import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:nocotine/constants/cofig_api.dart';
import 'package:nocotine/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:nice_buttons/nice_buttons.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:neon_circular_timer/neon_circular_timer.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:nocotine/constants/screens.dart';
import 'package:nocotine/screens/game_body_screen.dart';
import 'package:nocotine/screens/important_question_screen.dart';
import 'package:pushable_button/pushable_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:simple_timer/simple_timer.dart';
import 'dart:math';
import 'package:slide_countdown/slide_countdown.dart';
class CompetitionScreen extends StatefulWidget {
  const CompetitionScreen({ Key? key }) : super(key: key);

  @override
  _CompetitionScreenState createState() => _CompetitionScreenState();
}

class _CompetitionScreenState extends State<CompetitionScreen>{
  bool visableCompetition=false;
  var increaseCegaritte="0";
  var increaseCegaritteCompetitor="0";
  var timerDuration=0;
  var CompetitorUsername="Competitor Username";
  var CompetitorID="0";
  var CompetitorImage="user.png";
  Timer? timer;
  var CompetitionId;
  var CompetitorToken;
  var niceButtonVisable="";
  var senderData="";
  bool visableContent=false;
  final shadow = BoxShadow(
      color: AppColor.infoyColor.withOpacity(0.4),
      spreadRadius: 3,
      blurRadius: 4,
      offset: const Offset(0, 2),
    );
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 3), (Timer t) => checkCounters());
    checkCompetition();
    getCompetitionId();
    chekAppNotifcation();
    updateToken();
    //if app is open
    FirebaseMessaging.onMessage.listen((event) {
      print("=====================>onMessage<============");
      print(event.notification?.title);
      print(event.notification?.body);
      // AwesomeDialog(
      //   context: context,
      //   dialogType: DialogType.INFO,
      //   animType: AnimType.BOTTOMSLIDE,
      //   title: event.notification?.title,
      //   desc: event.notification?.body,
      //   btnCancelOnPress: () {},
      //   btnOkOnPress: () {},
      // )..show();
      Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      isDismissible:false,
      duration: Duration(seconds: 2),
      title: "${event.notification?.title}",
      message: "${event.notification?.body}",
      backgroundGradient: LinearGradient(colors: [AppColor.primaryColor,AppColor.lightprimaryColor,]),
      boxShadows: [BoxShadow(color: AppColor.primaryColor, offset: Offset(0.0, 2.0), blurRadius: 3.0,)],
      
    )..show(context);
        });
    //if app is in wait
    FirebaseMessaging.onMessageOpenedApp.listen((event) {

      Navigator.pushReplacementNamed(context, Screens.notification.value);
    });
  }
  //هاي فنكشن عشان اعمل بيرمشن للايفون بس عشان اقدر اطلع النتفكيشن
  Future chekAppNotifcation()async{
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }
  updateToken() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setInt(routeIndex, 0);
      var _userId=preferences.getString(id);
      var url=Uri.parse(updateTokenURL);
      _fcm.getToken().then((token) async{
        preferences.setString(myToken, token!);
      var response = await http.post(url,body: {
        "token":token,
        "user_id":_userId
      });
      if(response.statusCode==200){
      print(response.body);
      }
    });
      }
  
  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
      centerTitle: true,
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.emoji_events),
          SizedBox(width: 8,),
          Text('Competition'),
        ],
      ),
      backgroundColor: AppColor.darkColor,
    ),
    body:SingleChildScrollView(
      child:  ListView(
        shrinkWrap: true,
      children: [
            if(visableContent)Column(
              children: [
              
        if (visableCompetition) Container( height: 180,padding: EdgeInsets.only(top: 30),child: competitionContent(),)
        else Container(height: 180,padding: EdgeInsets.only(top: 50),child: Column(children: [Center(child: Text("Tips💡",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),),
              SizedBox(height:10,),
              Container(
                padding: EdgeInsets.only(left:25,right: 15),
                child: Center(
                  child: Text("• When the timer starts, make sure you adjust the cigarette counter each time you smoke a cigarette.\n• The competitor who has the fewest cigarettes wins.",style: TextStyle(height: 1.2,color: AppColor.infoyColor),),
                )),],)),
        Container(
          margin: EdgeInsets.only(top: 10),
          child: ListView(
            shrinkWrap: true,
            children: [
              ListTile(
            
          title: Center(child: Text("$CompetitorUsername")),
          leading:  Column(
                      
                      children: [
                        
                Icon(Icons.smoking_rooms,size: 35,color: AppColor.blackColor,),
                
                Text('$increaseCegaritteCompetitor',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                      ],
                    ),
          trailing:  GestureDetector(
            
                  child:  CircleAvatar(
                    radius: 25,
                    backgroundImage:NetworkImage("${ImageUrl}$CompetitorImage") ,
                    backgroundColor: AppColor.timerColor,
                          ),
                      )
                    
        ),
              SizedBox(height: 20,),
              ListTile(
          title: Center(child: Text("You")),
          leading:  Column(
                      
                      children: [
                        
                Icon(Icons.smoking_rooms,size: 35,color: AppColor.blackColor,),
                Text('$increaseCegaritte',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                      ],
                    ),
          trailing:  InkWell(
                  onTap: () {
                    if(visableCompetition==false){

                    }
                    else{
                      if (mounted) setState(() {
                      checkCompetitor();
                    });
                      
                    }
                    

                  },
                  child:  CircleAvatar(
                    radius: 25,
                    backgroundColor: AppColor.lightyColor,
                    child: Icon(Icons.add,color: AppColor.whiteColor,),
                          ),
                      )
                    
        ),
      
              ],
            ))
            ],
          )else Container(margin: EdgeInsets.only(top: 50), child: Center(child: Image(image: AssetImage('assets/images/loading_login.gif'),width: 50,),),)
        
        
      
      
      ],
    ),
    
    
    ),
    floatingActionButton: Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if(visableContent)createNewCompetition() else Container()
      ],
    ),
    floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
  Widget createNewCompetition(){
    if(visableCompetition){
      return Container(
        width: 200,
        child:  PushableButton(
                child: 
                    const Center(
                      child:  Text(
                      'Leave competition',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColor.whiteColor),
                    ),
                    ),
                height: 50,
                elevation: 7,
                
                hslColor: AppColor.infoHSLColor,
                shadow: shadow,
                onPressed: () {
                  dialogToleave();
                },
              )
        
      );
    }else{
      return Container(
        width: 200,
        child:  PushableButton(
                child: 
                    const Center(
                      child:  Text(
                      'Create New Competition ',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColor.whiteColor),
                    ),
                    ),
                height: 50,
                elevation: 7,
                
                hslColor: AppColor.primaryHSLColor,
                shadow: shadow,
                onPressed: () {
                  
                            if(niceButtonVisable=="meIsSender"){
                              print("1");
                                dialogIfsender();
                              }else if(niceButtonVisable=="meIsReceiver"){
                                print("2");
                                dialogIfreciever();
                              }else{
                                print("3");
                                    Navigator.pushNamed(context, Screens.competitionSearch.value);
                                  }
                        
                },
              )
        
      );

    }
  }
  //timer competition widget
  Widget competitionContent(){
    return  
        Center(
          child: SlideCountdownSeparated(
            duration:  Duration(seconds: timerDuration),
            width: 50,
            height: 50,
            onDone:(){
              endCompetition(int.parse(increaseCegaritte), int.parse(increaseCegaritteCompetitor));
            } ,
            decoration : const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(4)), color: AppColor.lightprimaryColor),
            textStyle: TextStyle(fontSize: 20,color: AppColor.whiteColor,fontWeight: FontWeight.bold),
            //separator: ":",
            //separatorStyle: TextStyle(fontSize: 30,color: AppColor.blackColor,fontWeight: FontWeight.bold),
            
          ),
        );
  }
  //function formted duration of timer competition
  String formted(Duration duration){
    String sDuration = "${duration.inDays}:${duration.inHours.remainder(24)}:${duration.inMinutes.remainder(60)}:${(duration.inSeconds.remainder(60))}"; 
    return sDuration;
  }
  //send requst to check if there is competition or not
  checkCompetition()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var compeititor1_id=preferences.getString(id);
    var url = Uri.parse(viewTimerCompetitionUrl);
    var res = await http.post(url,body: {
          
          "compeititor1_id":compeititor1_id,
        });
    List responseBody = jsonDecode(res.body);
      if(responseBody.isEmpty){
        setState(() {
        visableContent=true;
      });
        return;
      }else if(responseBody.isNotEmpty){
        if(res.statusCode==200){
          if(responseBody[0]['receiver_accept']=="0"){
            print(responseBody[0]['receiver_accept']);
              niceButtonVisable="0";
              preferences.remove(Visable_timer);
              if(compeititor1_id==responseBody[0]['sender_id']){
                preferences.setString(Competitor2_id_receiver, responseBody[0]['receiver_id']);
                preferences.remove(Competitor2_id_sender);
                loadCompetitorData2(responseBody[0]['receiver_id']);
                  if(mounted) setState(() {
                    niceButtonVisable="meIsSender";
                    
                  });
              }else if(compeititor1_id==responseBody[0]['receiver_id']){
                  preferences.setString(Competitor2_id_sender, responseBody[0]['sender_id']);
                  preferences.remove(Competitor2_id_receiver);
                  loadCompetitorData2(responseBody[0]['sender_id']);
                  if(mounted) setState(() {
                    niceButtonVisable="meIsReceiver";
                  });
              }
          }else if(responseBody[0]['receiver_accept']=="1"){
              niceButtonVisable="1";
                if(compeititor1_id==responseBody[0]['sender_id']){
                  preferences.setString(Competitor2_id_receiver, responseBody[0]['receiver_id']);
                  preferences.remove(Competitor2_id_sender);
                  preferences.setString(End_time_competition, responseBody[0]['end_time']);
                  preferences.setString(Visable_timer, "true");
                  //print("//////////////////////////${preferences.getString(Visable_timer)}");
              }else if(compeititor1_id==responseBody[0]['receiver_id']){
                  preferences.setString(Competitor2_id_sender, responseBody[0]['sender_id']);
                  preferences.remove(Competitor2_id_receiver);
                  preferences.setString(End_time_competition, responseBody[0]['end_time']);
                  preferences.setString(Visable_timer, "true");
                  //print("//////////////////////////${preferences.getString(Visable_timer)}");
              }
              print("Data Saved");
              startCompetition();
          }else{
              niceButtonVisable="3";
              preferences.remove(Visable_timer);
            print(responseBody[0]['receiver_accept']);
          }
        }else{
          print(res.statusCode);
          print(res.body);
        }
      }
      setState(() {
        visableContent=true;
      });
      return niceButtonVisable;
  }
  //send requst to start cometition
  startCompetition()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var preferencesVisableTimer=preferences.getString(Visable_timer);
    var preferencesCompetitorIdReceiver=preferences.getString(Competitor2_id_receiver);
    var preferencesCompetitorIdSender=preferences.getString(Competitor2_id_sender);
    if(preferencesVisableTimer==null||preferencesVisableTimer==""){
      if(mounted) setState(() {
        visableCompetition=false;
      });
      
    }else{
      if(mounted) setState(() {
        visableCompetition=true;
        calculateDurationTimer();
        if(preferencesCompetitorIdReceiver!=null){
          loadCompetitorData(preferencesCompetitorIdReceiver);
        }else if(preferencesCompetitorIdSender!=null){
          loadCompetitorData(preferencesCompetitorIdSender);
        }else{
          
        }
        
      });
    }
  }
  //function claculate deferant time between end comp time and currant time
  calculateDurationTimer()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var endCompetitonDate=preferences.getString(End_time_competition);
    if(endCompetitonDate!=null||endCompetitonDate!=""){
      DateTime currentDate = new DateTime.now();
      DateTime endDate = DateTime.parse("$endCompetitonDate");
      Duration diff = endDate.difference(currentDate);
      if(mounted) setState(() {
        timerDuration=diff.inSeconds;
        if(timerDuration<=0){
          visableCompetition=false;
        }
      });
      // //print(diff2);
      // //output (in days): 1198
      // print(diff.inDays);
      // print(diff.inHours);
      // //output (in hours): 28752

      // print(diff.inMinutes);
      // //output (in minutes): 1725170

      // print(diff.inSeconds);
    }
    
  }
  //send requst to get compititor1 data 
  loadCompetitorData(String competitorId)async{
  var url = Uri.parse(oneUserURl+"?id=$competitorId");
  var res = await http.get(url); 
  var responseBody = jsonDecode(res.body);
  if(res.statusCode==200){
    if(mounted) setState(() {
    CompetitorUsername=responseBody[0]['first_name']+" "+responseBody[0]['last_name'];
    CompetitorImage=responseBody[0]['image'];
    CompetitorToken=responseBody[0]['Token'];
    CompetitorID=responseBody[0]['id'];
  });
  }else{
    CompetitorUsername="Competitor Username";
    CompetitorImage="user.png";
    CompetitorID="0";
  }
  
  }
  //send requst to get compititor2 data 
  loadCompetitorData2(String competitorId)async{
  var url = Uri.parse(oneUserURl+"?id=$competitorId");
  var res = await http.get(url); 
  var responseBody = jsonDecode(res.body);
  if(res.statusCode==200){
    if(mounted) setState(() {
    CompetitorUsername="Competitor Username";
    CompetitorImage="user.png";
    CompetitorToken=responseBody[0]['Token'];
    CompetitorID=responseBody[0]['id'];
  });
  }else{
    CompetitorUsername="Competitor Username";
    CompetitorImage="user.png";
    CompetitorID="0";
  }
  
  }
  //send requst to update smoking counter sender
  updateCountSender() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
      
      var _userId=preferences.getString(id);
      var url=Uri.parse(senderCounterCompetitionUrl);
      
      var response = await http.post(url,body: {
        "sender_id":_userId
      });
      if(response.statusCode==200){
        print(response.body);
      }
      }
  //send requst to update smoking counter receiver
  updateCountReceiver() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
      
      var _userId=preferences.getString(id);
      var url=Uri.parse(receiverCounterCompetitionUrl);
      
      var response = await http.post(url,body: {
        "receiver_id":_userId
      });
      if(response.statusCode==200){
        print(response.body);
      }
      }
  //function to distinguish sender and receiver
  checkCompetitor()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var preferencesVisableTimer=preferences.getString(Visable_timer);
    var preferencesCompetitorIdReceiver=preferences.getString(Competitor2_id_receiver);
    var preferencesCompetitorIdSender=preferences.getString(Competitor2_id_sender);
    var _userId=preferences.getString(id);
        if(preferencesCompetitorIdReceiver!=null){
            updateCountSender();
            getSenderCounter(_userId!, increaseCegaritte);
            getReceiverCounter(preferencesCompetitorIdReceiver, increaseCegaritteCompetitor);
            increaseCegaritteCompetitor = await getReceiverCounter(preferencesCompetitorIdReceiver, increaseCegaritteCompetitor);
            increaseCegaritte = await getSenderCounter(_userId, increaseCegaritte);
        }else if(preferencesCompetitorIdSender!=null){
            updateCountReceiver();
            getSenderCounter(preferencesCompetitorIdSender, increaseCegaritteCompetitor);
            getReceiverCounter(_userId!, increaseCegaritte);
            increaseCegaritteCompetitor = await getSenderCounter(preferencesCompetitorIdSender, increaseCegaritteCompetitor);
            increaseCegaritte = await getReceiverCounter(_userId, increaseCegaritte);
        }
  
  }
  //function to distinguish sender and receiver counters
  checkCounters()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    print("-----------${preferences.getString(Visable_timer)}");
    if(preferences.getString(Visable_timer) != null||preferences.getString(Visable_timer)=="true"){
    var preferencesVisableTimer=preferences.getString(Visable_timer);
    var preferencesCompetitorIdReceiver=preferences.getString(Competitor2_id_receiver);
    var preferencesCompetitorIdSender=preferences.getString(Competitor2_id_sender);
    var _userId=preferences.getString(id);
        if(preferencesCompetitorIdReceiver!=null){
            getSenderCounter(_userId!, increaseCegaritte);
            getReceiverCounter(preferencesCompetitorIdReceiver, increaseCegaritteCompetitor);
            increaseCegaritteCompetitor = await getReceiverCounter(preferencesCompetitorIdReceiver, increaseCegaritteCompetitor);
            increaseCegaritte = await getSenderCounter(_userId, increaseCegaritte);
        
        }else if(preferencesCompetitorIdSender!=null){
            getSenderCounter(preferencesCompetitorIdSender, increaseCegaritteCompetitor);
            getReceiverCounter(_userId!, increaseCegaritte);
            increaseCegaritteCompetitor = await getSenderCounter(preferencesCompetitorIdSender, increaseCegaritteCompetitor);
            increaseCegaritte = await getReceiverCounter(_userId, increaseCegaritte);
          
        }else{
          return;
        }
        print("Counters Updated");
    }
  }
  //function to get sender counter
  getSenderCounter(String senderID,String senderCounter)async{
    
    var url=Uri.parse(getSenderCounterUrl);
      var response = await http.post(url,body: {
        "sender_id":senderID,
      });
    List responseBody = jsonDecode(response.body);
      if(response.statusCode==200){
        if(responseBody==null||responseBody==[]||responseBody.length==0||responseBody.isEmpty){
          senderCounter="0";
        }else{
            if(mounted)setState(() {
              senderCounter=responseBody[0]['sender_counter'];
            });
        }
      }
      return senderCounter;
  }
  //function to get receiver counter
  getReceiverCounter(String receiverID,String receiverCounter)async{
    var url=Uri.parse(getReceiverCounterUrl);
      var response = await http.post(url,body: {
        "receiver_id":receiverID,
      });
    List responseBody = jsonDecode(response.body);
      if(response.statusCode==200){
        if(responseBody==null||responseBody==[]||responseBody.length==0||responseBody.isEmpty){
          receiverCounter="0";
        }else{
            if(mounted)setState(() {
              receiverCounter=responseBody[0]['receiver_counter'];
            });
        }
      }
      
      return receiverCounter;
  }
  //send request to delete competition
  deleteCompetition()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
      
      var _userId=preferences.getString(id);
      var url=Uri.parse(deleteCompetitionUrl);
      var response = await http.post(url,body: {
        "user_id":_userId,
      });
      if(response.statusCode==200){
        print(response.body);
      }
  }
  //send request to get competition id
  getCompetitionId()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var _UserId=preferences.getString(id);
    var url=Uri.parse(getcompetitionIdUrl);
      var response = await http.post(url,body: {
        "user_id":_UserId,
      });
    List responseBody = jsonDecode(response.body);
      if(response.statusCode==200){
        
        if(responseBody==null||responseBody==[]||responseBody.length==0||responseBody.isEmpty){
          CompetitionId="0";
          
        }else{
          CompetitionId=responseBody[0]['competition_id'].toString();
        }
      }
      
  }
  //send request to convert data from competition table to competition result table
  competitionResult(String competitionId,String winnerId,String loserId)async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var _UserId=preferences.getString(id);
    var url=Uri.parse(competitionResultUrl);
      var response = await http.post(url,body: {
        "competition_id":competitionId,
        "winner_user_id":winnerId,
        "loser_user_id":loserId,
      });
      print("${response.statusCode}\n${response.body}");
  }
  //send request to end competition and send notificaion for winner and loser
  endCompetition(int userCounter,int competitorCounter)async{
    String dateDay = DateTime.now().day.toString();
    String dateMonth = DateTime.now().month.toString();
    String dateYear = DateTime.now().year.toString();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var myID=preferences.getString(id);
    if(mounted){
      setState(() {
        preferences.remove(Competitor2_id_receiver);
        preferences.remove(End_time_competition);
        preferences.remove(Visable_timer);
        preferences.remove(Competitor2_id_sender);
        visableCompetition=false;
        CompetitorUsername="Competitor Username";
        CompetitorImage="user.png";
        
        increaseCegaritteCompetitor="0";
        increaseCegaritte="0";
        niceButtonVisable="3";

      });
    }
    if(userCounter < competitorCounter){
      competitionResult(CompetitionId.toString(), myID!, CompetitorID);
      deleteCompetition();
      addNewResultNotificatin(CompetitorID, "you've lost the competition", "$dateDay/$dateMonth/$dateYear","com_lost");
      //addNewResultNotificatin(myID!, "you've won the competition", "$dateDay/$dateMonth/$dateYear");
      //sendPushMessage(preferences.getString(myToken).toString(), "you've won the competition", "Congratulations");
      sendPushMessage(CompetitorToken, "you've lost the competition", "Hard Luck");
      Dialogs.materialDialog(
        color: Colors.white,
        msg: "Congratulations, you've managed to smoke less cigarettes than your competitor.",
        title: 'Congratulations',
        lottieBuilder: Lottie.asset(
          'assets/images/celebration.json',
          fit: BoxFit.cover,
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
      CompetitorID="0";
    }else if(userCounter > competitorCounter){
      addNewResultNotificatin(CompetitorID, "you've won the competition", "$dateDay/$dateMonth/$dateYear","com_won");
      //addNewResultNotificatin(myID!, "you've lost the competition", "$dateDay/$dateMonth/$dateYear");
      sendPushMessage(CompetitorToken, "you've won the competition", "Congratulations");
      //sendPushMessage(preferences.getString(myToken).toString(), "you've lost the competition", "Hard Luck");
      competitionResult(CompetitionId.toString(), CompetitorID, myID!);
      deleteCompetition();
      Dialogs.materialDialog(
        color: Colors.white,
        msg: "You've lost the competition.",
        title: 'Hard Luck!',
        lottieBuilder: Lottie.asset(
          'assets/images/loss.json',
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
      CompetitorID="0";
    }else if(userCounter==competitorCounter){
      addNewResultNotificatin(CompetitorID, "you've both smoked the same amount of cigarettes", "$dateDay/$dateMonth/$dateYear","com_draw");
      //addNewResultNotificatin(myID!, "You've both smoked the same amount of cigarettes", "$dateDay/$dateMonth/$dateYear");
      deleteCompetition();
      sendPushMessage(CompetitorToken, "you've both smoked the same amount of cigarettes.", "It's a Draw");
      //sendPushMessage(preferences.getString(myToken).toString(), "You've both smoked the same amount of cigarettes.", "It's a Draw");
      Dialogs.materialDialog(
        color: Colors.white,
        msg: "You've both smoked the same amount of cigarettes.",
        title: "It's a Draw!",
        lottieBuilder: Lottie.asset(
          'assets/images/draw.json',
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
      CompetitorID="0";
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
  addNewResultNotificatin(String _CompetitorId,String _body,String _Date,String _icon) async{
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
  //dilog if user sender click to and new competition button
  dialogIfsender(){
    AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.NO_HEADER,
                                  animType: AnimType.BOTTOMSLIDE,
                                  title: 'you have to wait untill the user accept your invetition',
                                  desc: 'or you can cancel the invetition.',
                                  btnOkText: 'Cancel invetition',
                                  btnCancelText: 'Wait',
                                  btnOkColor: AppColor.primaryColor,
                                  btnCancelColor: AppColor.darkColor,
                                  btnOkOnPress: () async{
                                    await cancelInvite();
                                    setState(() {
                                      
                                      visableContent=true;

                                    });
                                    
                                  },
                                  btnCancelOnPress: (){},
                                  )..show();
                                  
  }
  //dilog if user reciver click to and new competition button
  dialogIfreciever(){
    AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.NO_HEADER,
                                    animType: AnimType.BOTTOMSLIDE,
                                    title: 'Invitation request', 
                                    desc: 'Would you like to accept the invitation',
                                    btnOkOnPress: () async{
                                      
                                      await  acceptInvite();
                                        setState(() {
                                      
                                        visableContent=true;

                                        });
                                    },
                                    btnCancelOnPress: () async{
                                      await  rejectInvite();
                                      setState(() {
                                      
                                        visableContent=true;

                                        });
                                    },
                                    btnCancelIcon: Icons.close,
                                    btnCancelText: "",
                                    btnOkIcon: Icons.done,
                                    btnOkText: ""
                                    
                                    )..show();
  }
  //dilog if user reciver,cender click to leave competition button
  dialogToleave(){
    AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.NO_HEADER,
                                  animType: AnimType.BOTTOMSLIDE,
                                  title: 'Leave!',
                                  desc: 'are you sure you want to leave the competition?',
                                  btnOkText: 'yes',
                                  btnCancelText: 'no',
                                  btnOkColor: AppColor.primaryColor,
                                  btnCancelColor: AppColor.darkColor,
                                  btnOkOnPress: () async{
                                    leaveCompetition();
                                  },
                                  btnCancelOnPress: (){},
                                  )..show();
  }
  //send requst leave competition
  leaveCompetition() async{
    String dateDay = DateTime.now().day.toString();
    String dateMonth = DateTime.now().month.toString();
    String dateYear = DateTime.now().year.toString();
    SharedPreferences preferences = await SharedPreferences.getInstance();
      var fUserName=preferences.getString(firstName);
      var lUserName=preferences.getString(lastName);
      var _userId=preferences.getString(id);
      var url=Uri.parse(deleteCompetitionUrl);
      var response = await http.post(url,body: {
        "user_id":_userId,
      });
      if(response.statusCode==200){
        preferences.remove(Competitor2_id_receiver);
        preferences.remove(End_time_competition);
        preferences.remove(Visable_timer);
        preferences.remove(Competitor2_id_sender);
        visableCompetition=false;
        CompetitorUsername="Competitor Username";
        CompetitorImage="user.png";
        
        increaseCegaritteCompetitor="0";
        increaseCegaritte="0";
        niceButtonVisable="3";
        sendPushMessage(CompetitorToken, "has left the Competition", "$fUserName $lUserName");
        addNewResultNotificatin(CompetitorID, "has left the Competition", "$dateDay/$dateMonth/$dateYear", "com_lost");
        if (mounted) setState(() {
          preferences.setInt(routeIndex, 1);
        print(preferences.getInt(routeIndex));
        Navigator.pushNamed(context, Screens.mainScreen.value);
        });
        print(response.body); 
      }
      
      
      
      
      }
  //send requst accept invetation
  acceptInvite() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
      String dateDay = DateTime.now().day.toString();
      String dateMonth = DateTime.now().month.toString();
      String dateYear = DateTime.now().year.toString();
      var fUserName=preferences.getString(firstName);
      var lUserName=preferences.getString(lastName);
      var _my_token=preferences.getString(myToken);
      var senderID=preferences.getString(Competitor2_id_sender);
      var _userId=preferences.getString(id);
      print("@@@@@@@@@@@@@${senderID}"); 
      var url=Uri.parse(acceptInviteUrl);
      var response = await http.post(url,body: {
        "User_id_sender":senderID,
        "User_id_receiver":_userId,
      });
      
      if(response.statusCode==200){
        await checkCompetition();
        loadUserIdProfile(senderID!);
        sendPushMessage(CompetitorToken, "your competition has started", "$fUserName $lUserName");
        addNewResultNotificatin(senderID, "your competition has started", "$dateDay/$dateMonth/$dateYear", "com_accept");
        sendPushMessage(_my_token!, "your competition has started", "$senderData");
        addNewResultNotificatin(_userId!, "your competition has started", "$dateDay/$dateMonth/$dateYear", "com_accept");
        
      }
      
      
      
      
      }
  //send requst reject invetation
  rejectInvite() async{
    String dateDay = DateTime.now().day.toString();
    String dateMonth = DateTime.now().month.toString();
    String dateYear = DateTime.now().year.toString();
    SharedPreferences preferences = await SharedPreferences.getInstance();
      var fUserName=preferences.getString(firstName);
      var lUserName=preferences.getString(lastName);
      var _userId=preferences.getString(id);
      var senderID=preferences.getString(Competitor2_id_sender);
      var url=Uri.parse(rejectInviteUrl);
      var response = await http.post(url,body: {
        "User_id_sender":senderID,
        "User_id_receiver":_userId,
      });
      if(response.statusCode==200){
        sendPushMessage(CompetitorToken, "has rejected your competition", "$fUserName $lUserName");
        addNewResultNotificatin(CompetitorID, "has rejected your competition", "$dateDay/$dateMonth/$dateYear", "com_reject");
        if (mounted) setState(() {
          preferences.setInt(routeIndex, 1);
        print(preferences.getInt(routeIndex));
        Navigator.pushNamed(context, Screens.mainScreen.value);
        });
        print(response.body); 
      }
      
      
      
      
      }
  //send requst cancel invetation 
  cancelInvite() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
      var receiverID=preferences.getString(Competitor2_id_receiver);
      var _userId=preferences.getString(id);
      var url=Uri.parse(rejectInviteUrl);
      var response = await http.post(url,body: {
        "User_id_sender":_userId,
        "User_id_receiver":receiverID,
      });
      if(response.statusCode==200){
        if (mounted) setState(() {
          preferences.setInt(routeIndex, 1);
        print(preferences.getInt(routeIndex));
        Navigator.pushNamed(context, Screens.mainScreen.value);
        });
        print(response.body);
      }
      
      
      
      
      }
  //send requst get name competitior 
  loadUserIdProfile(String userID)async{
    var url = Uri.parse(oneUserURl+"?id=$userID");
    var res = await http.get(url);
    var responseBody = jsonDecode(res.body);
    if(mounted) setState(() {
      senderData="${responseBody[0]['first_name']} ${responseBody[0]['last_name']}";
    });
  }
  }