import 'dart:convert';
import 'dart:ffi';

import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:nocotine/constants/cofig_api.dart';
import 'package:nocotine/constants/colors.dart';
import 'package:nocotine/constants/screens.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
class LoginScreen extends StatefulWidget {
  // const LoginScreen({ Key? key }) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _EmailControllerLogin = new TextEditingController();
  TextEditingController _passwordControllerLogin = new TextEditingController();
  double NumOfPackets=0.0;
  double PriceOfPackets=0.0;
  bool texterrorEmail = false;
  bool texterrorPassword = false;
  bool _passwordVisible = false;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: SingleChildScrollView(
        child: Container(
        color: Colors.white,
        width: double.infinity,
        padding: EdgeInsets.only(left: 40,right: 40),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * .15),
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
            children: [
            Image(image: AssetImage("assets/images/login2.gif"),width: 200,),
            SizedBox(height: 40,),
            _EmailLogin(),
            SizedBox(height: 20,),
            _passwordLogin(),
            SizedBox(height: 20,),
            _loginButtun(),
            _DontAccount(),
            _ForgetPassword()
            
            ],
          ),
          ),
        ),
      ),
    
    
      )
    );
  }
  //login button widget 
  Widget _loginButtun(){
  return  ElevatedButton(
                style: ElevatedButton.styleFrom(
                primary: AppColor.primaryColor,),
                child: Text("Login"),
                
                onPressed: (){
                  if(_EmailControllerLogin.text.isEmpty){
                    setState(() {
                      texterrorEmail=true;
                    });
                  }
                  else {
                    setState(() {
                      texterrorEmail=false;
                    });
                  }
                  if(_passwordControllerLogin.text.isEmpty){
                    setState(() {
                      texterrorPassword=true;
                    });
                  }
                  else {
                    setState(() {
                      texterrorPassword=false;
                    });
                  }
                  if(texterrorEmail==false&&texterrorPassword==false){
                    setState(() {
                      loginUser(context, _EmailControllerLogin.text, _passwordControllerLogin.text);
                    });
                  }
                  
                },
              );
}
  //email textfeild widget
  Widget _EmailLogin(){
    return TextFormField(
      controller: _EmailControllerLogin,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.email,color: AppColor.infoyColor,),
        labelText: "Email",
        errorText: texterrorEmail?"Required":null,
        labelStyle: TextStyle(color: AppColor.infoyColor),
        
        filled: true,
        fillColor: AppColor.whiteColor,

        enabledBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          
          borderSide: BorderSide(
            color: AppColor.darkColor,width: 4.4)
        ),
        focusedBorder: UnderlineInputBorder(
          
          borderRadius: BorderRadius.circular(10),
          
          borderSide: BorderSide(
            width: 4.4,
            color: AppColor.primaryColor,
            
            ),
            
      ),
      
      ),
    );
  }
  //password textfeild widget
  Widget _passwordLogin(){
    return TextFormField(
      controller: _passwordControllerLogin,
      obscureText: !_passwordVisible,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.lock,color: AppColor.infoyColor,),
        labelText: "Password",
        errorText: texterrorPassword?"Required":null,
        labelStyle: TextStyle(color: AppColor.infoyColor),
        suffixIcon: IconButton(
            icon: Icon(
                _passwordVisible
                ? Icons.visibility
                : Icons.visibility_off,
                color: AppColor.infoyColor,
                ),
            onPressed: () {
                setState(() {
                    _passwordVisible = !_passwordVisible;
                });
              },
              ),
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
            color: AppColor.primaryColor,
            
            ),
            
      ),
      
      ),
    );
  }
  //go to sign up page widget
  Widget _DontAccount(){
  return Row(
      mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have an account?",style: TextStyle(color: AppColor.infoyColor,fontWeight:FontWeight.w700,fontSize: 15 ),),
                TextButton(onPressed: (){
                  Navigator.of(context).pushNamed(Screens.signup.value);
                }, child: Text("Create account",style: TextStyle(color: AppColor.darkColor,fontSize: 15),))
              ],
            );
}
  //if login  send requst to check if there is competition or not
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
  //send requst to check email and password
  void loginUser(BuildContext context, String _email, String _password) async{
    var url= Uri.parse(loginUrl);
    Map<String,String> loginBody = {"Email":_email, "Password":_password};
    var response = await http.post(url,body: jsonEncode(loginBody));
    if(response.statusCode == 401){
      AwesomeDialog(
            context: context,
            dialogType: DialogType.ERROR,
            animType: AnimType.BOTTOMSLIDE,
            title: 'Email or password invalid',
            btnCancelOnPress: () {},
            )..show();
      return;
    }
    var res = jsonDecode(response.body);
    if(response.statusCode == 200){
      //print(res);
      if(res['verified']=="1"||res['verified']==1){
        if(res['type']=="user"){
        loginSuccessfulUser(context, res);
      }else if(res['type']=="admin"){
        loginSuccessfulAdmin(context, res);
      }
      }else{
        AwesomeDialog(
            context: context,
            dialogType: DialogType.ERROR,
            animType: AnimType.BOTTOMSLIDE,
            title: 'Please check your email for verification',
            btnCancelOnPress: () {},
            )..show();
      } 
    
    }
  }
  //if email and password Successful and type=user 
  void loginSuccessfulUser(BuildContext context,res) async{
    
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // Save response
    preferences.setString("PROFILE", res.toString());
    
    preferences.setString(id, res["id"]);
    preferences.setString(firstName, res['first_name']);
    preferences.setString(lastName, res['last_name']);
    preferences.setString(email, res['email']);
    preferences.setString(type, res['type']);
    preferences.setString(gender, res['gender']);
    preferences.setString(age, res['Age']);
    preferences.setString(bio, res['bio']);
    preferences.setString(image, res['image']);
    preferences.setString(visable_sheet, res['visable_sheet']);
    preferences.setDouble(num_packets, double.parse(res['number_of_packets']));
    preferences.setDouble(price_packets, double.parse(res['price_of_packets']));
    preferences.setDouble(price_one_cigratte, double.parse(res['price_of_packets'])/20);
    preferences.setInt(routeIndex, 0);
    // push to home screen
    getVisableSheet();
    
    checkCompetition();
  }
  //if email and password Successful and type=admin
  void loginSuccessfulAdmin(BuildContext context,res) async{
    
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // Save response
    preferences.setString("PROFILE", res.toString());
    preferences.setString(id, res["id"]);
    preferences.setString(type, res['type']);
    preferences.setString(firstName, res['first_name']);
    preferences.setString(lastName, res['last_name']);
    preferences.setString(email, res['email']);
    Navigator.pushReplacementNamed(context, Screens.AdminHomeScreen.value);
  }
  //if email and password Successful and VisableSheet=0
  void getVisableSheet() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var _VisableSheet;
    setState(() {
      
      
      _VisableSheet=preferences.getString(visable_sheet);
      if(_VisableSheet=="0"){
        //showCustomBottomSheet(context, contentSheet());
        Navigator.pushReplacementNamed(context, Screens.importantQuestion.value);
        
      }
      else if(_VisableSheet=="1"){
      
        Navigator.pushReplacementNamed(context, Screens.mainScreen.value);
      }
    });
    
  }
  //Forget Password button widget
  Widget _ForgetPassword(){
  return Row(
      mainAxisAlignment: MainAxisAlignment.center,
              children: [
                
                TextButton(onPressed: (){
                  Navigator.of(context).pushNamed(Screens.ForgetPassword.value);
                }, child: Text("Forget password?",style: TextStyle(color: AppColor.lightyColor,fontWeight:FontWeight.w700,fontSize: 15 ),),)
              ],
            );
}
  
}