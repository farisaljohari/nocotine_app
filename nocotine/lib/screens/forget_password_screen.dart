import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:nocotine/constants/cofig_api.dart';
import 'package:nocotine/constants/colors.dart';
import 'package:http/http.dart' as http;
class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({ Key? key }) : super(key: key);

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  TextEditingController _EmailController = new TextEditingController();
  bool texterrorEmail = false;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SafeArea(
        child: Stack(
    alignment: Alignment.topLeft,
    children: <Widget>[
        Container(
        padding: EdgeInsets.only(top: 60,left: 40, right: 40),
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        width: 300,
                        height: 300,
                        child: Image.asset("assets/images/forget_pass.png"),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Forget password ?",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                          color: AppColor.darkColor,
                          fontFamily: 'Baloo 2'
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Enter your e-mail to receive a new password",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: AppColor.infoyColor
                        ),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),

                SizedBox(
                        height: 20,
                      ),
                Container(
                  width: double.infinity,
                  child: Column(
                    children: <Widget>[
                      _EmailField(),
                      SizedBox(
                        height: 20,
                      ),
                      _sendButtun(),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
      
        Container(
          margin: EdgeInsets.only(top: 10),
          child: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        )
    ],
  )
    
        ));
  }
  Widget _EmailField(){
    return TextFormField(
      controller: _EmailController,
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
  //send requst to send email new password
  ResetPassword(String _Email) async{
      
      var url=Uri.parse(forgetPasswordUrl);
      var response = await http.post(url,body: {
        "email":_Email,
      });
      print("Status Code: ${response.statusCode} \n Body: ${response.body}");
      if(response.statusCode==200){
        AwesomeDialog(
                  context: context,
                  dialogType: DialogType.SUCCES,
                  animType: AnimType.BOTTOMSLIDE,
                  title: 'Check your email and login', 
                  btnOkOnPress: () {
                  },
                  showCloseIcon: false,
                  
                  )..show();
      }else if(response.statusCode==401){
        AwesomeDialog(
                  context: context,
                  dialogType: DialogType.ERROR,
                  animType: AnimType.BOTTOMSLIDE,
                  title: 'Email not found', 
                  btnCancelOnPress: (){

                  },
                  showCloseIcon: false,
                  
                  )..show();
      }
      
      
      }
  //done button to run reset function
  Widget _sendButtun(){
  return  ElevatedButton(
                style: ElevatedButton.styleFrom(
                primary: AppColor.primaryColor,),
                child: Text("Send"),
                
                onPressed: (){
                    if(_EmailController.text.isEmpty){
                                setState(() {
                                  texterrorEmail=true;
                                });
                              }
                              else {
                                setState(() {
                                  texterrorEmail=false;
                                  ResetPassword(_EmailController.text);
                                });
                              }
                },
              );
}
  
}