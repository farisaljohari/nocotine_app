import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nocotine/constants/cofig_api.dart';
import 'package:nocotine/constants/colors.dart';
import 'package:nocotine/constants/screens.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import "dart:io";
import 'package:permission_handler/permission_handler.dart';
import "package:path/path.dart" as path;
import "package:async/async.dart";
class EditImage extends StatefulWidget {
  const EditImage({ Key? key }) : super(key: key);

  @override
  State<EditImage> createState() => _EditImageState();
}

class _EditImageState extends State<EditImage> {
  var _Name="";
  var _UserId;
  bool _visbleLike=false;
  bool _visableGender=true;
  var _userId;
  String dec="loadingImage.gif";
  String Age="";
  String Gender="Male";
  double NumOfCigarette=0.0;
  String Bio="";
  var TotalPosts="0";
  var TotalWins="0";
  final String assetName = 'assets/images/pack.svg';
  String? imageFile = null;
  String? imageName;
  String? imagePathDecode=null;
  var ImagePath;
  
  bool? _expandedImage;
  bool visableUploadProgress=true;
  final ImagePicker _picker=ImagePicker();
  @override
  void initState() {
    getUserData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Edit Profile Picture"),
        backgroundColor: AppColor.darkColor,
        leading: IconButton(onPressed: (){
        Navigator.pop(context);
      }, icon: Icon(Icons.arrow_back_ios)),
      ),
      body: Container(
        child: Column(
          children: [
            if(visableUploadProgress)Column(
          children: [
            SizedBox(height: 100,),
            getProfileImage(),
            SizedBox(height: 20,),
            Container(
              margin: EdgeInsets.only(left: 30,right: 30),
              width: double.infinity,
              child: OutlinedButton(
                
                child: Text("Choose a photo",style: TextStyle(color: AppColor.darkColor),),
                onPressed: (){
                  showCustomBottomSheet(context, contentSheet());
                  //Navigator.pushNamed(context,Screens.login.value);
                },
              ),
            ),
          
            Container(
              margin: EdgeInsets.only(left: 30,right: 30),
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                primary: AppColor.primaryColor,),
                child: Text("Save",),
                
                
                onPressed: (){
                  //Navigator.pushNamed(context,Screens.signup.value);
                  if(ImagePath != null){
                    addImage(ImagePath);
                  }else{
                    AwesomeDialog(
                        context: context,
                        dialogType: DialogType.WARNING,
                        animType: AnimType.BOTTOMSLIDE,
                        title: 'Please select an image', 
                        btnOkOnPress: () {},
                        showCloseIcon: false,
                        btnOkColor: AppColor.darkColor
                        )..show();
                  }
                  
                },
              ),
            ),
            ],
        )else  Expanded(child:Center(child: Image(image: AssetImage('assets/images/upload_progress.gif'),width: 100,),),
              )
      
          ],
        )),
    );
  }
  //function get user data from shared prefrence
  getUserData() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      var _firstName;
      var _lastName;
      var _image;
      var _age;
      var _gender;
      var _NoOfCigarette;
      var _bio;
      _firstName=preferences.getString(firstName);
      _lastName=preferences.getString(lastName);
      _Name="$_firstName $_lastName";
      _UserId=preferences.getString(id);
      _image=preferences.getString(image);
        dec=_image;
      _bio=preferences.getString(bio);
      _age=preferences.getString(age);
      _gender=preferences.getString(gender);
      _NoOfCigarette=preferences.getDouble(num_packets);
      Age=_age;
      Gender=_gender;
      if(Gender[0]=="M"){
        _visableGender=true;
      }else{
        _visableGender=false;
      }
      NumOfCigarette=_NoOfCigarette;
      Bio=_bio;
    });
  }
  //function get current profile picture
  Widget getProfileImage() {
    return (imageFile != null) ? Container(
            decoration:  BoxDecoration(

            image: DecorationImage(

            image: FileImage(File(imageFile!)),

            fit: BoxFit.contain),),
            
            height: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
              Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: (){
                    setState(() {
                    imageFile=null;
                  });
                  },
                  child:Container(
                    margin: EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      color:AppColor.LightblackColor,
                      borderRadius: BorderRadius.all(Radius.circular(10))
                ),
                    
                    child: Icon(Icons.close,color: AppColor.whiteColor,size: 20,),),
                  ),
              
                
              ],
            ),
          
              ],
            )):Container(
            decoration:  BoxDecoration(

            image: DecorationImage(

            image: NetworkImage("$ImageUrl$dec"),

            fit: BoxFit.contain),),
            
            height: 300,) ;
  }
  //upload image from camera or gallary bar widget
  void showCustomBottomSheet(BuildContext context,Widget child){
    showModalBottomSheet(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft:Radius.circular(30),topRight: Radius.circular(40) ),
      ),
      context: context,
      builder: (context){
      return SingleChildScrollView(
        child: Container(
        height: 175,
        child: child,
      ),
      );
    });
  }
  //upload image from camera or gallary bar widget
  Widget contentSheet(){
    return Container(
      padding: EdgeInsets.only(left: 20,top: 20),
      child: Column(
        children: [
          InkWell(
            child: ListTile(
            title: Text("From Camera"),
            leading: Icon(Icons.photo_camera),
          ),
          onTap: (){
            getImageFromCamera();
            Navigator.pop(context);
          },
          ),
          InkWell(
            child: ListTile(
            title: Text("From Gallery"),
            leading: Icon(Icons.collections),
          ),
          onTap: (){
            getImageFromGallery();
            Navigator.pop(context);
          },
          )
        ],
      ),
    );
  }
  //function get camera image 
  void getImageFromCamera()async{
    var image =await _picker.pickImage(source: ImageSource.camera);
    if(image != null){
      setState(() {
        imageFile = image.path;
        imageName = image.name;
        ImagePath=File(image.path);
        print(imageFile);

        print(imageName);
      });
    }
  }
  //function get gallary image 
  void getImageFromGallery()async{
    var image =await _picker.pickImage(source: ImageSource.gallery);
    if(image != null){
      setState(() {
        imageFile = image.path;
        imageName=image.name;
        ImagePath=File(image.path);
        print(imageFile);
        
        print(imageName);
      });
      print("------------------------");
    }

  }
  //send requst to upload image post to server   
  Future addImage(File imageFile) async{
// ignore: deprecated_member_use
var stream= new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
var length= await imageFile.length();
var uri = Uri.parse("${baseUrl}test_upload.php");

var request = new http.MultipartRequest("POST", uri);

var multipartFile = new http.MultipartFile("image", stream, length, filename: path.basename(imageFile.path));

request.files.add(multipartFile);
var respond = await request.send();
print("Status Code: ${respond.statusCode} \n Body: ${respond}");
if(respond.statusCode==200){
  print("Image Uploaded");
  updateProfilePicture();
}else{
  print("Upload Failed");
}
  }
  //send request to change profile picture
  updateProfilePicture() async{
      setState(() {
        visableUploadProgress=false;
      });
      SharedPreferences preferences = await SharedPreferences.getInstance();
        
        var _userId=preferences.getString(id);
        var url=Uri.parse(upadteProfilePictureURL);
        if(imageName==null||imageName==""){
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
          "image":imageName,
          "user_id":_userId
        });
        if(response.statusCode==200){
          setState(() {
            visableUploadProgress=true;
          });
          SharedPreferences preferences = await SharedPreferences.getInstance();
        // Save response
        preferences.setString(image, imageName!);
        AwesomeDialog(
                        context: context,
                        dialogType: DialogType.SUCCES,
                        animType: AnimType.BOTTOMSLIDE,
                        title: 'Profile picture changed', 
                        btnOkOnPress: () async{
                          SharedPreferences preferences = await SharedPreferences.getInstance();
                          if (mounted) setState(() {
                            preferences.setInt(routeIndex, 2);
                          print(preferences.getInt(routeIndex));
                          Navigator.pushNamed(context, Screens.mainScreen.value);
                          });
                        },
                        showCloseIcon: false
                        
                        )..show();
        }
        
        
        
        
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
    
}