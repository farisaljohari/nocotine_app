import 'package:nocotine/constants/cofig_api.dart';
import 'package:nocotine/constants/screens.dart';
import 'package:flutter/material.dart';
import 'package:nocotine/constants/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
class RootScreen extends StatefulWidget {
  const RootScreen({ Key? key }) : super(key: key);

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  bool rootVisable=false;
  @override
  void initState() {
    checkIsLogin();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * .15),
        child: Column(
          children: [
            
            if(rootVisable)Image(image: AssetImage("assets/images/logo.png"),width: 300,)else   Container(
                    padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * .25),
                    child: Center(
                      child: Image(image: AssetImage("assets/images/loading_login.gif"),width: 60,)
                    )
                  ),
            if(rootVisable)SizedBox(height: 30,),
            if(rootVisable)Container(
              margin: EdgeInsets.only(left: 30,right: 30),
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                primary: AppColor.primaryColor,),
                child: Text("Sign up",),
                
                
                onPressed: (){
                  Navigator.pushNamed(context,Screens.signup.value);
                },
              ),
            ),
            if(rootVisable)Container(
              margin: EdgeInsets.only(left: 30,right: 30),
              width: double.infinity,
              child: OutlinedButton(
                
                child: Text("Already have an account? Log In",style: TextStyle(color: AppColor.darkColor),),
                onPressed: (){
                  
                  Navigator.pushNamed(context,Screens.login.value);
                },
              ),
            )
          ],
        ),
      ),
      ),
      )
    );
    
  }
  //function check if user is already login or not
  checkIsLogin() async {
  
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var _email=preferences.getString(email);
    var _type=preferences.getString(type);
    Future.delayed(Duration(seconds: 1), (){
    if (_email != "" && _email != null) {
      print("alreay login.");
      if(_type=="admin"){
        Navigator.pushReplacementNamed(context,Screens.AdminHomeScreen.value); 
      }else if(_type=="user"){
        Navigator.pushReplacementNamed(context,Screens.mainScreen.value); 
      }
      }
    else
    {
      print("no login.");
      setState(() {
        rootVisable=true;
      });
    }});
  }
}