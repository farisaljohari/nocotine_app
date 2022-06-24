import "package:async/async.dart";
import "package:path/path.dart" as path;
import 'dart:io';
import 'package:animated_icon_button/animated_icon_button.dart';
import 'package:nocotine/constants/cofig_api.dart';
import 'package:nocotine/constants/screens.dart';
import 'package:nocotine/screens/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:nocotine/constants/colors.dart';
import 'package:nocotine/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:permission_handler/permission_handler.dart';
import "package:image_picker/image_picker.dart";
import 'package:keyboard_attachable/keyboard_attachable.dart';
class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({ Key? key }) : super(key: key);

  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  TextEditingController _postTextController = new TextEditingController();
  final ImagePicker _picker=ImagePicker();
  bool visableFeeling = false;
  String _Feeling="";
  var _UserId;
  var _Name;
  String? imageFile;
  String? imageName;
  String? imagePathDecode=null;
  var ImagePath;
  bool visableUploadProgress=true;
  @override
  void initState() { 
    setState(() {
      getUserID();
      checkPermession();
    });
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
        backgroundColor: AppColor.darkColor,
        centerTitle: true,
        title: Text("Create Post"),
        leading: Column(
          children: [
          if(visableUploadProgress)  IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.close)),
          ],
        ),
        actions: [
        if(visableUploadProgress) IconButton(onPressed: (){
            setState(() {
              if(_postTextController.text.trim()==''||_postTextController.text.isEmpty){
                ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(
              content: Text("Enter Text !",textAlign: TextAlign.center,style: TextStyle(fontSize: 16),),
            backgroundColor: AppColor.ErrorColor,
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.only(left: 100,right: 100,bottom: 70),
              duration: Duration(seconds: 1),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
            )
            );
              }
              else{
                addNewPost();
                
              }
              
            });
            
          }, icon: Icon(Icons.post_add),),
          
        ],
      ),
      body: SafeArea(
        maintainBottomViewPadding: false,

        child:
          
          Column(
            children: [
              
            if(visableUploadProgress)Expanded(
              child: FooterLayout(
              footer:
                Container(
                
                    margin: EdgeInsets.only(bottom: 1,left: 1,right: 1),
                    decoration: BoxDecoration(
                      color: AppColor.whiteColor,
                    border: Border.all(color: AppColor.darkColor,width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(15))
                  ),
                    child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
              Container(
                width: 200,
                child: ListTile(
                title: Text("Upload Photo"),
                leading: Icon(Icons.add_a_photo,color: AppColor.primaryColor,),
                onTap: (){
                  showCustomBottomSheet(context, contentSheet());
                  
                },
              ),),
              Container(
                width: 150,
                child: ListTile(
                title: Text("Feeling"),
                leading: Icon(Icons.emoji_emotions,color: AppColor.primaryColor,),
                onTap: (){
                  AwesomeDialog(
                        padding: EdgeInsets.all(10),
                        context: context,
                        dialogType: DialogType.NO_HEADER,
                        animType: AnimType.BOTTOMSLIDE,
                        btnOkOnPress: () {
                          setState(() {
                            
                          });
                          
                        },
                        body: Column(
                          children: [
                                Container(
                                  margin: EdgeInsets.only(left: 60,right: 60),
                                  child: ListTile(
                                  title: Text("Happy"),
                                  trailing: Image(image: AssetImage("assets/images/happy.gif"),width: 30,),
                                  onTap: (){
                                    setState(() {
                                      visableFeeling=true;
                                      Navigator.pop(context);
                                      _Feeling="Happy 😄";
                                      
                                    });
                                  },
                                ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 60,right: 60),
                                  child: ListTile(
                                  title: Text("Sad"),
                                  trailing: Image(image: AssetImage("assets/images/icons8-crying.gif"),width: 30,),
                                  onTap: (){
                                    setState(() {
                                      visableFeeling=true;
                                      Navigator.pop(context);
                                      _Feeling="Sad 😭";
                                    });
                                  },
                                ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 60,right: 60),
                                  child: ListTile(
                                  title: Text("Loved"),
                                  trailing: Image(image: AssetImage("assets/images/loved.gif"),width: 30,),
                                  onTap: (){
                                    setState(() {
                                      visableFeeling=true;
                                      Navigator.pop(context);
                                      _Feeling="Loved 🥰";
                                    });
                                  },
                                ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 60,right: 60),
                                  child: ListTile(
                                  title: Text("Tired"),
                                  trailing: Image(image: AssetImage("assets/images/tired.gif"),width: 30,),
                                  onTap: (){
                                    setState(() {
                                      visableFeeling=true;
                                      Navigator.pop(context);
                                      _Feeling="Tired 😪";
                                    });
                                  },
                                ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 60,right: 60),
                                  child: ListTile(
                                  title: Text("Proud"),
                                  trailing: Image(image: AssetImage("assets/images/proud.gif"),width: 30,),
                                  onTap: (){
                                    setState(() {
                                      visableFeeling=true;
                                      Navigator.pop(context);
                                      _Feeling="Proud 😌";
                                    });
                                  },
                                ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 60,right: 60),
                                  child: ListTile(
                                  title: Text("Blessed"),
                                  trailing: Image(image: AssetImage("assets/images/blessed.gif"),width: 30,),
                                  onTap: (){
                                    setState(() {
                                      visableFeeling=true;
                                      Navigator.pop(context);
                                      _Feeling="Blessed 😇";
                                    });
                                  },
                                ),
                                ),
                            
                          ],
                        ),
                        showCloseIcon: false,
                        btnOkColor: AppColor.primaryColor
                        
                        )..show();
                },
              ),
                    
                ),
                  ],),
                  ),
              
                      
              child: 
              ListView(
                children: [
                  if (visableFeeling) Container(margin: EdgeInsets.only(top: 10,left: 10), child: Row(children: [Text("$_Name",style: TextStyle(fontWeight: FontWeight.bold,fontSize:15),),Text(" is Feeling ",style: TextStyle(fontSize:15),),Text("$_Feeling",style: TextStyle(fontWeight: FontWeight.bold,fontSize:15),)],),),
                      
              Container(
                child:  TextFormField(
                  controller: _postTextController,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                minLines: null,
                maxLines: null, 
                decoration: InputDecoration(
                  hintText: "Create Post..",
                  
                  filled: true,
                  fillColor: AppColor.whiteColor,
            
                  enabledBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    
                    borderSide: BorderSide(
                      color: AppColor.transpartntColor,width: 3)
                  ),
                  focusedBorder: UnderlineInputBorder(
                    
                    borderRadius: BorderRadius.circular(10),
                    
                    borderSide: BorderSide(
                      width: 3,
                      color: AppColor.transpartntColor,
                      
                      ),
              
                  ),
                  
                  ),
                )
              ),
              (imageFile != null) ? Container(
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
              )): Text(""),
                      
                ],
              )
              
              
              ),
            )
            else  Container(
                  margin: EdgeInsets.only(top: 50),
                  child: Center(child: Image(image: AssetImage('assets/images/upload_progress.gif'),width: 100,),),),
            ],
          )
      
    
    
      ),
      
    );
  }


  //send requst to add new post
  addNewPost() async{
    setState(() {
      visableUploadProgress=false;
    });
    print("-----------------------------$ImagePath");
    print("-----------------------------$imageName");
    if(ImagePath==null||ImagePath==""){
      
        imageName="";
        
      }else{
        await addImage(ImagePath);
      }
    
      String UserId= _UserId;
      String PostText= _postTextController.text;
      String Feeling= _Feeling;
      
      if(UserId.isEmpty || PostText.isEmpty){
        
        print("NO DATA"); 
        return;
      }
      var url=Uri.parse(createPostUrl);
      var response = await http.post(url,body: {
        "user_id":UserId,
        "post_text":PostText,
        "feeling":Feeling,
        "image_name":imageName
      });
      print("Status Code: ${response.statusCode} \n Body: ${response.body}");
      if(response.statusCode==200){
        print("post created");
    ScaffoldMessenger.of(context)
    .showSnackBar(SnackBar(
      content: Text("Post Created",textAlign: TextAlign.center,style: TextStyle(fontSize: 16),),
    backgroundColor: AppColor.blackTransparentColor,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(left: 100,right: 100,bottom: 50),
      duration: Duration(seconds: 1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
    )
    );
              
    Navigator.pushReplacementNamed(context, Screens.mainScreen.value);
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
  // updateProfilePicture();
}else{
  print("Upload Failed");
}
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
  //function get user data from shared prefrence
  void getUserID() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      _UserId=preferences.getString(id);
      _Name="${preferences.getString(firstName)} ${preferences.getString(lastName)}";
    });
  }
}

