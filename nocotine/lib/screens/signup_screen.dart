import 'package:nocotine/constants/cofig_api.dart';
import 'package:nocotine/constants/screens.dart';
import 'package:flutter_datetime_picker_bdaya/flutter_datetime_picker_bdaya.dart';
import 'package:nocotine/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:awesome_dialog/awesome_dialog.dart';
class SignupScreen extends StatefulWidget {
  const SignupScreen({ Key? key }) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController _firstNameController = new TextEditingController();
  TextEditingController _lastNameController = new TextEditingController();
  TextEditingController _EmailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _ConfirmPasswordController = new TextEditingController();
  var dateOfBirth;
  int Age=0;
  bool _visabless=false;
  String gender ="";
  bool texterrorFname = false;
  bool texterrorLname = false;
  bool texterrorEmail = false;
  bool texterrorPassword = false;
  bool texterrorCofirmPassword= false;
  bool visableGender= true;
  bool texterrorDateOfBirth=false;
  String NotMatchOrEmptyForFname="";
  String NotMatchOrEmptyForLname="";
  String NotMatchOrEmptyForEmail="";
  String NotMatchOrEmptyPassword="";
  String NotMatchOrEmptyConfPassword="";

  @override
  void initState() {
    if(dateOfBirth==null){
    dateOfBirth="yyyy-mm-dd";
  }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body:SingleChildScrollView(
        
        child: SafeArea(
          
        child:  Container(
          margin: EdgeInsets.only(top: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
        Align(
          alignment: Alignment.center,
          child: Text("Create Account",style: TextStyle(fontSize: 30,fontWeight: FontWeight.w700,color: AppColor.primaryColor,fontFamily: 'Baloo 2'),),
        ),

        Container(
          padding: EdgeInsets.only(top: 10),
          margin: EdgeInsets.only(left: 25,right: 25,top: 20),
        child: Form(
          
          child: Column(
            
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                  children: <Widget>[
                    Flexible(
                      child:_firstName()
                    ),
                    SizedBox(width: 10,),
                    Flexible(
                      child: _lastName()
                    ),
                  ],
                ),
              SizedBox(height: 20,),
              _Email(),
              SizedBox(height: 20,),
              _password(),
              SizedBox(height: 20,),
              _confirmPassword(),
              SizedBox(height: 20,),
              _RadioGender(),
              SizedBox(height: 20,),
          
              _DateOfBirth(),
              SizedBox(height: 20,),
              _signUpButton(),
            SizedBox(height: 5,),
              _HaveAccount()

            ],
          ),
        ),
      )
      ]),
        )
      ),
      )
    );
  }
  //fname textfeild widget
  Widget _firstName(){
    return TextFormField(
      controller: _firstNameController,
      
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: "First name",
        errorText: texterrorFname?"$NotMatchOrEmptyForFname":null,
        labelStyle: TextStyle(color: AppColor.infoyColor),
        
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
            width: 3,
            color: AppColor.primaryColor,
            
            ),
            
      ),
      
      ),
    );
  }
  //lname textfeild widget
  Widget _lastName(){
    return TextFormField(
      controller: _lastNameController,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: "Last name",
        errorText: texterrorLname?"$NotMatchOrEmptyForLname":null,
        labelStyle: TextStyle(color: AppColor.infoyColor),
        
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
            width: 3,
            color: AppColor.primaryColor,
            
            ),
            
      ),
      
      ),
    );
  }
  //email textfeild widget
  Widget _Email(){
    return TextFormField(
      controller: _EmailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.email,color: AppColor.infoyColor,),
        labelText: "Email",
        errorText: texterrorEmail?"$NotMatchOrEmptyForEmail":null,
        labelStyle: TextStyle(color: AppColor.infoyColor),
        
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
            width: 3,
            color: AppColor.primaryColor,
            
            ),
            
      ),
      
      ),
    );
  }
  //password textfeild widget
  Widget _password(){
  return TextFormField(
    controller: _passwordController,
    obscureText: true,
    keyboardType: TextInputType.text,
    decoration: InputDecoration(
        prefixIcon: Icon(Icons.lock,color: AppColor.infoyColor,),
        labelText: "Password",
        errorText: texterrorPassword?"$NotMatchOrEmptyPassword":null,
        labelStyle: TextStyle(color: AppColor.infoyColor),
        
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
            width: 3,
            color: AppColor.primaryColor,
            
            ),
            
      ),
      
      ),
  );
}
  //confirm passsword textfeild widget
  Widget _confirmPassword(){
    return TextFormField(
      controller: _ConfirmPasswordController,
      obscureText: true,
      
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.lock,color: AppColor.infoyColor,),
        labelText: "Confirm password",
        errorText: texterrorCofirmPassword?"$NotMatchOrEmptyConfPassword":null,
        labelStyle: TextStyle(color: AppColor.infoyColor),
        
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
            width: 3,
            color: AppColor.primaryColor,
            
            ),
            
      ),
      
      ),
    );
  }
  //gender radio button widget
  Widget _RadioGender(){
    return  Stack(
          children: <Widget>[
            if(visableGender)Container(
              margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
              decoration: BoxDecoration(
                border: Border.all(
                    color: AppColor.darkColor, width: 2),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Gender: ",style: TextStyle(color: AppColor.blackColor,fontSize: 16,fontWeight: FontWeight.w600),),
                Radio(value: "Male", groupValue: gender, onChanged: (value){
                  setState(() {
                    gender=value.toString();
                  });
                }),
                Text("male",style: TextStyle(color: AppColor.blackColor,fontSize: 16),),
                Radio(value: "Female", groupValue: gender, onChanged: (value){
                  setState(() {
                    gender=value.toString();
                  });
                }),
                Text("female",style: TextStyle(color: AppColor.blackColor ,fontSize: 16),),

              ],
            ),
    
            )else Container(
              margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
              decoration: BoxDecoration(
                border: Border.all(
                    color: AppColor.ErrorColor, width: 1),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Gender: ",style: TextStyle(color: AppColor.blackColor,fontSize: 16,fontWeight: FontWeight.w600),),
                Radio(value: "Male", groupValue: gender, onChanged: (value){
                  setState(() {
                    gender=value.toString();
                  });
                }),
                Text("male",style: TextStyle(color: AppColor.blackColor,fontSize: 16),),
                Radio(value: "Female", groupValue: gender, onChanged: (value){
                  setState(() {
                    gender=value.toString();
                  });
                }),
                Text("female",style: TextStyle(color: AppColor.blackColor ,fontSize: 16),),

              ],
            ),
    
            ),
            
            
            if(visableGender)Text("")else
            Positioned(
                left: 40,
                top: 2,
                child: Container(
                  padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
                  color: Colors.white,
                  child: Text(
                    'Required',
                    style: TextStyle(color: AppColor.ErrorColor, fontSize: 12),
                  ),
                )),
          ],
        );
  }
  //birthdate calender widget
  Widget _DateOfBirth(){
    return TextFormField(
      readOnly: true,
      decoration: InputDecoration(
          hintText: "$dateOfBirth",
          prefixIcon: Icon(Icons.event,color: AppColor.infoyColor,),
          errorText: texterrorDateOfBirth?"Required":null,
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
    onTap: () {
        DatePicker.showDatePicker(context,
                              showTitleActions: true,
                              minTime: DateTime(1990, 12, ),
                              maxTime: DateTime(2022, 12, 31), onChanged: (date) {
                            print('change ${date.year}');
                          }, onConfirm: (date) {
                            print('confirm ${date.year}');
                            print(DateTime.now().year);
                            setState(() {
                              dateOfBirth="${date.year}-${date.month}-${date.day}";
                              Age=DateTime.now().year-date.year;
                            });
                          }, currentTime: DateTime.now(),
                          
                          );
    },
    );
  }
  //signUp button widget
  Widget _signUpButton(){
    return ElevatedButton(
                style: ElevatedButton.styleFrom(
                primary: AppColor.primaryColor,),
                child: Text("Sign up"),
                
                onPressed: (){
                  //////////////////////////Check Fname////////////////////////////////
                  if(_firstNameController.text.isEmpty){
                            setState(() {
                              texterrorFname = true;
                              NotMatchOrEmptyForFname="Required";
                              return;
                            });
                        }else if(!RegExp(r'[A-Za-z]{2,}$').hasMatch(_firstNameController.text)){
                            setState(() {
                              texterrorFname = true;
                              NotMatchOrEmptyForFname="Enter Correct First Name";
                              return;
                            });
                        }else{
                          setState(() {
                            texterrorFname = false;
                          });
                        }
                   //////////////////////////Check Lname////////////////////////////////
                  if(_lastNameController.text.isEmpty){
                            setState(() {
                              texterrorLname = true;
                              NotMatchOrEmptyForLname="Required";
                              return;
                            });
                        }else if(!RegExp(r'[A-Za-z]{2,}$').hasMatch(_lastNameController.text)){
                            setState(() {
                              texterrorLname = true;
                              NotMatchOrEmptyForLname="Enter Correct Last Name";
                              return;
                            });
                        }else{
                          setState(() {
                            texterrorLname = false;
                          });
                        }
                      //////////////////////////Check Email////////////////////////////////
                      if(_EmailController.text.isEmpty){
                            setState(() {
                              texterrorEmail = true;
                              NotMatchOrEmptyForEmail="Required";
                              return;
                            });
                        }else if(!RegExp(r'^[A-Za-z0-9._%+-]+[@][A-Za-z0-9.-]+[.][A-Za-z]{2,}$').hasMatch(_EmailController.text)){
                            setState(() {
                              texterrorEmail = true;
                              NotMatchOrEmptyForEmail="example@bbb.com";
                              return;
                            });
                        }else{
                          setState(() {
                            texterrorEmail = false;
                          });
                        }
                      //////////////////////////Check Password////////////////////////////////
                      if(_passwordController.text.isEmpty){
                            setState(() {
                              texterrorPassword = true;
                              NotMatchOrEmptyPassword="Required";
                              return;
                            });
                        }else if(!RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$').hasMatch(_passwordController.text)){
                            setState(() {
                              texterrorPassword = true;
                              NotMatchOrEmptyPassword="Password must contain at least 8 characters, one digit, \none upper case and one lower case letter";
                              return;
                            });
                        }else{
                          setState(() {
                            texterrorPassword = false;
                          });
                        }
                         //////////////////////////Check Confirm Password////////////////////////////////
                        if(_ConfirmPasswordController.text.isEmpty){
                            setState(() {
                              texterrorCofirmPassword = true;
                              NotMatchOrEmptyConfPassword="Required";
                              return;
                            });
                        }else if(_ConfirmPasswordController.text!=_passwordController.text){
                            setState(() {
                              texterrorCofirmPassword = true;
                              NotMatchOrEmptyConfPassword="Password not Match";
                              return;
                            });
                        }else{
                          setState(() {
                            texterrorCofirmPassword = false;
                          });
                        }
                        //////////////////////////Check Gennder////////////////////////////////
                        if(gender.isEmpty){
                            setState(() {
                              visableGender = false;
                              return;
                            });
                        }else{
                          setState(() {
                            visableGender = true;
                          });
                        }
                        //////////////////////////Check Date of Birth////////////////////////////////
                        if(dateOfBirth=="yyyy-mm-dd"){
                            setState(() {
                              texterrorDateOfBirth = true;
                              return;
                            });
                        }else{
                          setState(() {
                            texterrorDateOfBirth = false;
                          });
                        }
                        if(texterrorFname==false&&texterrorLname==false&&texterrorEmail==false&&texterrorCofirmPassword==false&&texterrorPassword==false&&texterrorDateOfBirth==false&& visableGender==true){
                          addNewUser();
                        }else{
                          print("empty Data");
                        }
                  
                },
              );
  }
  //got to login button if already have account widget
  Widget _HaveAccount(){
  return Row(
      mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Already have an account?",style: TextStyle(color: AppColor.infoyColor,fontWeight:FontWeight.w700,fontSize: 15 ),),
                TextButton(onPressed: (){
                  Navigator.of(context).pushNamed(Screens.login.value);
                }, child: Text("Log in",style: TextStyle(color: AppColor.darkColor,fontSize: 15),))
              ],
            );
}
  
  //sende requst to add new user in database
  addNewUser() async{
      String FirstName= _firstNameController.text;
      String LastName= _lastNameController.text;
      String Email= _EmailController.text;
      String Password= _passwordController.text;
      String ConfPassword= _ConfirmPasswordController.text;
      String Gender= gender;
      if(FirstName.isEmpty || LastName.isEmpty || Email.isEmpty || Password.isEmpty || ConfPassword.isEmpty || Gender.isEmpty){
        
        print("NO DATA");
        return;
      }
      if(dateOfBirth=="Date of Birth"){
        return;
      }
      var url=Uri.parse(signupUrl);
      var response = await http.post(url,body: {
        "fname":FirstName,
        "lname":LastName,
        "email":Email,
        "password":Password,
        "conf_password":ConfPassword,
        "gender":Gender,
        "Age":Age.toString(),
      });
      print("Status Code: ${response.statusCode} \n Body: ${response.body}");
      if(response.statusCode==200){
        AwesomeDialog(
            context: context,
            animType: AnimType.SCALE,
            dialogType: DialogType.SUCCES,
            
            title: 'Accout created',
            btnOkOnPress: () {
              Navigator.pushNamed(context, Screens.login.value);
            },
                  )..show();
        _firstNameController.text="";
        _lastNameController.text="";
        _EmailController.text="";
        _passwordController.text="";
        _ConfirmPasswordController.text="";
        gender="";
        setState(() {
          dateOfBirth="";
        });
      }else if(response.statusCode==500){
        AwesomeDialog(
            context: context,
            animType: AnimType.SCALE,
            dialogType: DialogType.WARNING,
            
            desc: 'E-mail address you entered is already used by another user. Please enter a different e-mail address.',
            btnOkColor: AppColor.darkColor,
            btnOkOnPress: () {
              
            },
                  )..show();
        
      }
      
      
      }


}
