import 'package:nocotine/constants/cofig_api.dart';
import 'package:nocotine/constants/screens.dart';
import 'package:flutter/material.dart';
import 'package:nocotine/constants/colors.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter_datetime_picker_bdaya/flutter_datetime_picker_bdaya.dart';
import 'package:expansion_widget/expansion_widget.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'dart:math' as math;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';
import 'dart:typed_data';
import "package:image_picker/image_picker.dart";
import "dart:io";
import "package:path/path.dart" as path;
import "package:async/async.dart";
import 'dart:io';
class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({ Key? key }) : super(key: key);

  @override
  _AccountSettingsScreenState createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  final GlobalKey<FormState> _formKeyName = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyPassword = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyDateOfBirth = GlobalKey<FormState>();
  String SaveBio="Bio";
  String FirstName="";
  String LastName="";
  var NewdateOfBirth;
  late double _NumOfPackets;
  late double _PriceOfPackets;
  String? imageFile = null;
  String? imageName;
  String? imagePathDecode=null;
  var ImagePath;
  String dec="";
  int Age=0;
  String CheckPassword="";
  String DefultDateOfBirth="yyyy-mm-dd";
  
  bool? _expandedImage;
  final ImagePicker _picker=ImagePicker();
  TextEditingController _NewdateOfBirthController=new TextEditingController();
  TextEditingController _NewFirstNameController=new TextEditingController();
  TextEditingController _NewLastNameController=new TextEditingController();
  TextEditingController _NewPasswordController=new TextEditingController();
  TextEditingController _NewConfirmPasswordController=new TextEditingController();
  TextEditingController _BioController=new TextEditingController();
  @override
  void initState() {
    setState(() {
      getLastData();
    });
    checkPermession();
    super.initState();
  }
  //function to permession camera and gallary
  Future checkPermession()async{
    var cameraPermession = await Permission.camera.status;
    print("Camera Status: $cameraPermession");
    if(cameraPermession.isDenied){
      cameraPermession =await Permission.camera.request();
    }
    var storagePermission = await Permission.storage.status;
    print("Storge Status: $storagePermission");
    if(storagePermission.isDenied){
      storagePermission =await Permission.storage.request();
    }
    var photoPermission = await Permission.photos.status;
    print("Photo Status: $photoPermission");
    if(photoPermission.isDenied){
      photoPermission =await Permission.photos.request();
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColor.darkColor,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.manage_accounts),
          SizedBox(width: 8,),
          Text("Account Settings"),
          
        ],
        
      ),
      leading: IconButton(onPressed: (){
        Navigator.pop(context);
      }, icon: Icon(Icons.arrow_back_ios)),
      ),
      
      body: SingleChildScrollView(
        child: SafeArea(
        child: Column(
          children: [
          
            ChangePassword(),
            ChangeBirthDate(),
            ChangeCigaretteInfo(),
            ChangePriceCigarette(),
            ResetSmokingCounter(),
          
          ],
        ),
      ),
      )
      
    );
  }
  //change password widget
  Widget ChangePassword(){
    return Card(
              child: ListTile(
                trailing: Icon(Icons.arrow_forward_ios),
                leading:CircleAvatar(
                                            backgroundColor: AppColor.whiteColor,
                                            radius: 18,
                                            child: CircleAvatar(
                                              radius: 17,
                                            backgroundColor: AppColor.primaryColor,
                                            child: const Icon(
                                              Icons.password,
                                              color:AppColor.whiteColor,
                                              size: 20,
                                            ),
                                            ),
                                          ),
              title: Center(
                child: Text("Change password"),
                
              ),
              onTap: (){
              AwesomeDialog(
                  context: context,
                  dialogType: DialogType.NO_HEADER,
                  animType: AnimType.BOTTOMSLIDE,
                  btnCancelColor: AppColor.primaryColor,
                  btnOkColor: AppColor.darkColor,
                  showCloseIcon: false,
                  btnOkText: "Save",
                  body: Form(
                    key: _formKeyPassword,
                    child: Container(
                    padding: EdgeInsets.all(20),
                    child: Column(
                    
                      children: <Widget>[
                        TextFormField(
                          obscureText: true,
                          controller: _NewPasswordController,
                          validator: (value) {
                          var pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$';
                              RegExp regex = new RegExp(pattern);
                              
                              if (value!.isEmpty)
                                return 'Required';
                                
                              else if(!regex.hasMatch(value))
                                return 'Password must contain at least 8 characters, one digit, \none upper case and one lower case letter';
                              else
                                  setState(() {
                                    CheckPassword=value;
                                  });
                                return null;
                            
                          
                        },
                          decoration: InputDecoration(
                            labelText: "New Password",
                            
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
                        ),
                      
                        TextFormField(
                          controller: _NewConfirmPasswordController,
                          validator: (value) {
                              
                              if (value!.isEmpty)
                                return 'Required';
                                
                              else if(value!=CheckPassword)
                                return 'Password Not Match';
                              else
                                return null;
                            
                          
                        },
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: "Confirm Password",
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
                        ),
                      SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                        
                      InkWell(
                        child: Container(
                          padding: EdgeInsets.all(10),
                          width: 120,
                          child: Center(child: Text("Cancel",style: TextStyle(color: AppColor.whiteColor,fontWeight: FontWeight.bold),)),
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
                          _NewPasswordController.text="";
                          _NewConfirmPasswordController.text="";
                          Navigator.of(context).pop();
                        }
                      ),
                        InkWell(
                        child: Container(
                          padding: EdgeInsets.all(10),
                          width: 120,
                          child: Center(child: Text("Save",style: TextStyle(color: AppColor.whiteColor,fontWeight: FontWeight.bold),)),
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
                            if (_formKeyPassword.currentState!.validate()) {
                              updatePassword();
                              Navigator.of(context).pop();
                        }}
                      ),
                    
                        ],
                      )
                      ],
                    ),
                  
                  
                  ),
                  
                  
                  
                  ),
                  )..show();
              
              },
            ),
            );
  }
  //change BirthDate Widget
  Widget ChangeBirthDate(){
    return Card(
              child: Form(
                child:   ListTile(
                trailing: Icon(Icons.arrow_forward_ios),
                leading:CircleAvatar(
                                            backgroundColor: AppColor.whiteColor,
                                            radius: 18,
                                            child: CircleAvatar(
                                              radius: 17,
                                            backgroundColor: AppColor.primaryColor,
                                            child: const Icon(
                                              Icons.calendar_month,
                                              color:AppColor.whiteColor,
                                              size: 20,
                                            ),
                                            ),
                                          ),
              title: Center(
                child: Text("Change birthdate"),
                
              ),
              onTap: (){
              AwesomeDialog(
                  context: context,
                  dialogType: DialogType.NO_HEADER,
                  animType: AnimType.BOTTOMSLIDE,
                  btnCancelColor: AppColor.primaryColor,
                  btnOkColor: AppColor.darkColor,
                  btnOkText: "Save",
                  body: Form(
                    key: _formKeyDateOfBirth,
                    child: Container(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          readOnly: true,
                          controller: _NewdateOfBirthController,
                          validator: (value) {
                              
                              if (DefultDateOfBirth=="yyyy-mm-dd")
                                return 'Required';
                                
                              else
                                return null;
                            
                          
                        },
                          decoration: InputDecoration(
                              hintText: "$DefultDateOfBirth",
                              prefixIcon: Icon(Icons.event,color: AppColor.infoyColor,),
                              
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
                        onTap: () {
                            DatePicker.showDatePicker(
                              context,
                              showTitleActions: true,
                              minTime: DateTime(1990, 12, ),
                              maxTime: DateTime(2022, 12, 31), onChanged: (date) {
                            print('change $date');
                          }, onConfirm: (date) {
                            print('confirm $date');
                            setState(() {
                              
                              
                              NewdateOfBirth="${date.year}-${date.month}-${date.day}";
                              DefultDateOfBirth="${date.year}-${date.month}-${date.day}";
                              Age=DateTime.now().year-date.year;
                              NewdateOfBirth=NewdateOfBirth.toString();
                              _NewdateOfBirthController.text=NewdateOfBirth;

                            });
                          }, currentTime: DateTime.now(), locale: LocaleType.en);
                        },
                        ),
                        SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                        
                      InkWell(
                        child: Container(
                          padding: EdgeInsets.all(10),
                          width: 120,
                          child: Center(child: Text("Cancel",style: TextStyle(color: AppColor.whiteColor,fontWeight: FontWeight.bold),)),
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
                            setState(() {
                          getLastData();
                          Navigator.of(context).pop();
                        });
                        }
                      ),
                        InkWell(
                        child: Container(
                          padding: EdgeInsets.all(10),
                          width: 120,
                          child: Center(child: Text("Save",style: TextStyle(color: AppColor.whiteColor,fontWeight: FontWeight.bold),)),
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
                            if (_formKeyDateOfBirth.currentState!.validate()) {
                              setState(() {
                                updateBirthDate();
                                Navigator.of(context).pop();
                              });
                        }}
                      ),
                    
                        ],
                      )
                      ],
                    ),
                    

                  ),
                  
                  ),
                  )..show();
              },
            ),
            
              ),
              );
  }
  //change CigaretteInfo Widget
  Widget ChangeCigaretteInfo(){
    return  ExpansionWidget(
    initiallyExpanded: false,
    titleBuilder: (double animationValue, _, bool isExpaned, toogleFunction) {
      return InkWell(
          onTap: () => toogleFunction(animated: true),
          child: Container(
            child: Card(
              child:  ListTile(
                trailing: Icon(Icons.arrow_forward_ios),
                leading:CircleAvatar(
                                            backgroundColor: AppColor.whiteColor,
                                            radius: 18,
                                            child: CircleAvatar(
                                              radius: 17,
                                            backgroundColor: AppColor.primaryColor,
                                            child: const Icon(
                                              Icons.smoking_rooms,
                                              color:AppColor.whiteColor,
                                              size: 20,
                                            ),
                                            ),
                                          ),
              title: Center(
                child: Center(child: Text("Change number of \npacks of cigarettes"),),
                
              ),
            ),)
          ));
    },
    content: Column(
        children: [
          Container(
              margin: EdgeInsets.only(top: 20),
            child: Text("How many packs of cigarettes do you \nsmoke per day?",style: TextStyle(fontSize: 17),),
          ),
          Container(
            padding: EdgeInsets.only(left: 30,right: 30),
            child: SpinBox(
            min: 0,
            max: 5,
            value: 0,
            decimals: 1,
            step: 0.5,
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
                _NumOfPackets=value;
              });
            },
                          ),
                ),
          
          
          IconButton(onPressed: (){
            updateNumberOfPackets();
          }
          , icon:Icon( Icons.save,color: AppColor.primaryColor,))
        ],
      ));
  }
  //change PriceCigarette Widget
  Widget ChangePriceCigarette(){
    return  ExpansionWidget(
    initiallyExpanded: false,
    titleBuilder: (double animationValue, _, bool isExpaned, toogleFunction) {
      return InkWell(
          onTap: () => toogleFunction(animated: true),
          child: Container(
            child: Card(
              child: ListTile(
                trailing: Icon(Icons.arrow_forward_ios),
                leading:CircleAvatar(
                                            backgroundColor: AppColor.whiteColor,
                                            radius: 18,
                                            child: CircleAvatar(
                                              radius: 17,
                                            backgroundColor: AppColor.primaryColor,
                                            child: const Icon(
                                              Icons.paid,
                                              color:AppColor.whiteColor,
                                              size: 20,
                                            ),
                                            ),
                                          ),
              title: Center(
                child: Center(child: Text("Change price of \npacks of cigarettes"),),
                
              ),
            ),)
          ));
    },
    content: Column(
        children: [
          Container(
              margin: EdgeInsets.only(top: 20),
            child: Text("How much does a pack of cigarettes \ncost?",style: TextStyle(fontSize: 17),),
          ),
          Container(
            padding: EdgeInsets.only(left: 30,right: 30),
            child: SpinBox(
            min: 0,
            max: 5,
            value: 0,
            decimals: 1,
            step: 0.1,
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
              _PriceOfPackets=value;
            },
                          ),
                ),
          IconButton(onPressed: (){
            updatePriceOfPackets();
          }
          , icon:Icon( Icons.save,color: AppColor.primaryColor,))
        ],
      ));
  }
  //Reset Smoking Counter Widget
  Widget ResetSmokingCounter(){
    return Card(
              child: ListTile(
                trailing: Icon(Icons.arrow_forward_ios),
                leading:CircleAvatar(
                                            backgroundColor: AppColor.whiteColor,
                                            radius: 18,
                                            child: CircleAvatar(
                                              radius: 17,
                                            backgroundColor: AppColor.primaryColor,
                                            child: const Icon(
                                              Icons.restart_alt,
                                              color:AppColor.whiteColor,
                                              size: 20,
                                            ),
                                            ),
                                          ),
              title: Center(
                child: Text("Reset smoking counter"),
                
              ),
              onTap: (){
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.NO_HEADER,
                  animType: AnimType.BOTTOMSLIDE,
                  btnCancelColor: AppColor.primaryColor,
                  btnOkColor: AppColor.darkColor,
                  title: 'Smoking counter',
                  desc: 'Are you sure you want to reset smoking counter?',
                  btnCancelOnPress: () {},
                  btnOkOnPress: () {
                    resetSmokingCounter();
                  },
                  )..show();
              },
            ),
            );
  }
  //get user data from shared preferance
  getLastData() async{
        SharedPreferences preferences = await SharedPreferences.getInstance();
      var _fname;
      var _lname;
      var _lastBirthDate;
      var _numPackets;
      var _pricePackets;
      setState(() {
        _fname=preferences.getString(firstName);
        FirstName=_fname;
        _lname=preferences.getString(lastName);
        LastName=_lname;
        _NewFirstNameController..text = FirstName;
        _NewLastNameController..text = LastName;
        _numPackets=preferences.getDouble(num_packets);
        
        _NumOfPackets=_numPackets;
        _pricePackets=preferences.getDouble(price_packets);
        _PriceOfPackets=_pricePackets;
        
      });
  }
  //send request to change password
  updatePassword() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
      
      var _userId=preferences.getString(id);
      var url=Uri.parse(updatePasswordURL);
      if(_NewPasswordController.text.isEmpty||_NewConfirmPasswordController.text.isEmpty){
        AwesomeDialog(
                      context: context,
                      dialogType: DialogType.WARNING,
                      animType: AnimType.BOTTOMSLIDE,
                      title: 'Empty feild', 
                      btnOkOnPress: () {},
                      showCloseIcon: false
                      
                      )..show();
        return;
      }
      var response = await http.post(url,body: {
        "password":_NewPasswordController.text,
        "conf_password":_NewConfirmPasswordController.text,
        "user_id":_userId
      });
      print(response.statusCode);
      if(response.statusCode==200){
      AwesomeDialog(
                      context: context,
                      dialogType: DialogType.SUCCES,
                      animType: AnimType.BOTTOMSLIDE,
                      title: 'Password changed', 
                      btnOkOnPress: () {},
                      showCloseIcon: false
                      
                      )..show();
      }
      
      
      
      
      }
  //send request to change birthdate
  updateBirthDate() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString(age, Age.toString());
      var _userId=preferences.getString(id);
      var url=Uri.parse(updateBirthDateURL);
      if(_NewdateOfBirthController.text.isEmpty){
        AwesomeDialog(
                      context: context,
                      dialogType: DialogType.WARNING,
                      animType: AnimType.BOTTOMSLIDE,
                      title: 'Empty feild', 
                      btnOkOnPress: () {},
                      showCloseIcon: false
                      
                      )..show();
        return;
      }
      var response = await http.post(url,body: {
        "Age":Age.toString(),
        "user_id":_userId
      });
      if(response.statusCode==200){
        SharedPreferences preferences = await SharedPreferences.getInstance();

      AwesomeDialog(
                      context: context,
                      dialogType: DialogType.SUCCES,
                      animType: AnimType.BOTTOMSLIDE,
                      title: 'Birthdate changed', 
                      btnOkOnPress: () {},
                      showCloseIcon: false
                      
                      )..show();
      }
      
      
      
      
      }
  //send request to change Number Of Packets
  updateNumberOfPackets() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
      
      var _userId=preferences.getString(id);
      var url=Uri.parse(updateVisbleSheetURL);
      
      var response = await http.post(url,body: {
        "user_id":_userId,
        "num_packets":_NumOfPackets.toString(),
        "price_packets":_PriceOfPackets.toString(),
      });
    
      if(response.statusCode==200){
        setState(() {
          
          // Save response
          
          preferences.setDouble(num_packets, _NumOfPackets);
          preferences.setDouble(price_packets, _PriceOfPackets);

          AwesomeDialog(
                      context: context,
                      dialogType: DialogType.SUCCES,
                      animType: AnimType.BOTTOMSLIDE,
                      title: 'Number of packs changed', 
                      btnOkOnPress: () {},
                      showCloseIcon: false
                      
                      )..show();
          
        });
        
      }
    
      
      }
  //send request to change Price Of Packets
  updatePriceOfPackets() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
      
      var _userId=preferences.getString(id);
      var url=Uri.parse(updateVisbleSheetURL);
      var response = await http.post(url,body: {
        "user_id":_userId,
        "num_packets":_NumOfPackets.toString(),
        "price_packets":_PriceOfPackets.toString(),
      });
    
      if(response.statusCode==200){
        setState(() {
          
          // Save response
          
          preferences.setDouble(num_packets, _NumOfPackets);
          preferences.setDouble(price_packets, _PriceOfPackets);
          preferences.setDouble(price_one_cigratte, _PriceOfPackets/20);

          AwesomeDialog(
                      context: context,
                      dialogType: DialogType.SUCCES,
                      animType: AnimType.BOTTOMSLIDE,
                      title: 'Price of packs changed', 
                      btnOkOnPress: () {},
                      showCloseIcon: false
                      
                      )..show();
          
        });
        
      }
    
      
      }
  //send request to reset Smoking Counter
  resetSmokingCounter() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
      
      var _userId=preferences.getString(id);
      var url=Uri.parse(resetSmokingCounterURL);
      var response = await http.post(url,body: {
        "user_id":_userId,
      });
    
      if(response.statusCode==200){
        setState(() {
          

          AwesomeDialog(
                      context: context,
                      dialogType: DialogType.SUCCES,
                      animType: AnimType.BOTTOMSLIDE,
                      title: 'Reset successful', 
                      btnOkOnPress: () {},
                      showCloseIcon: false
                      
                      )..show();
          
        });
        
      }
    
      
      }
  
}
