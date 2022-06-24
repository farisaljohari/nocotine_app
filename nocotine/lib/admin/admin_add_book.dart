import 'dart:io';
import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nocotine/constants/cofig_api.dart';
import 'package:nocotine/constants/colors.dart';
import 'package:http/http.dart' as http;
import "package:path/path.dart" as path;
import "package:async/async.dart";
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
class AdminAddBooks extends StatefulWidget {
  const AdminAddBooks({ Key? key }) : super(key: key);

  @override
  State<AdminAddBooks> createState() => _AdminAddBooksState();
}

class _AdminAddBooksState extends State<AdminAddBooks> {
  TextEditingController _BookNameController = new TextEditingController();
  bool texterrorBookName = false;
  String NotMatchOrEmptyForBookName="";
  String? _directoryPath;
  final ImagePicker _picker=ImagePicker();
  String? imageFile = null;
  String? pdfFile = null;
  String? imageName;
  String? pdfName;
  String? imagePathDecode=null;
  var ImagePath;
  File? PDFPath;
  bool visableUploadProgress=true;
  String? randomName;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                if(visableUploadProgress) Column(
              
          children: [ 
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                getPdfImage(),
                getProfileImage(),
              ],
            ),
            SizedBox(height: 30,),
            Container(
              margin: EdgeInsets.only(left: 30,right: 30),
              width: double.infinity,
              child: Card(
                child:BookName()
              )
            ),
          
            SizedBox(height: 30,),
            Container(
              margin: EdgeInsets.only(left: 30,right: 30),
              width: double.infinity,
              child: Card(
                child: ListTile(
                title: Text("Choose pdf book",style: TextStyle(color: AppColor.darkColor),),
                leading: Icon(Icons.picture_as_pdf,color: AppColor.darkColor,),
                trailing: Icon(Icons.navigate_next,color: AppColor.infoyColor,),
                onTap: (){
                _pickFiles();
                },
              ),
              )
            ),
          
            SizedBox(height: 30,),
            Container(
              margin: EdgeInsets.only(left: 30,right: 30),
              width: double.infinity,
              child: Card(
                child: ListTile(
                title: Text("Choose book poster",style: TextStyle(color: AppColor.darkColor),),
                leading: Icon(Icons.image,color: AppColor.darkColor,),
                trailing: Icon(Icons.navigate_next,color: AppColor.infoyColor,),
                onTap: (){
                  getImageFromGallery();
                },
              ),
              )
            ),
            SizedBox(height: 30,),
            Container(
              margin: EdgeInsets.only(left: 30,right: 30),
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                primary: AppColor.primaryColor,),
                child: Text("Add",),
                
                
                onPressed: (){
                    
                  if(_BookNameController.text.isEmpty){
                            setState(() {
                              texterrorBookName = true;
                              NotMatchOrEmptyForBookName="Required";
                              return;
                            });
                        }else if(!RegExp(r'^[A-Za-z0-9 ]{5,}$').hasMatch(_BookNameController.text)){
                            setState(() {
                              texterrorBookName = true;
                              NotMatchOrEmptyForBookName="at least 5 characters \nno special characters";
                              return;
                            });
                        }else{
                          setState(() {
                            texterrorBookName = false;
                            if(PDFPath==null){
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.WARNING,
                                animType: AnimType.BOTTOMSLIDE,
                                title: 'Please choose PDF book', 
                                btnOkOnPress: () {},
                                showCloseIcon: false,
                                btnOkColor: AppColor.darkColor
                                )..show();
                            }else if(ImagePath==null){
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.WARNING,
                                animType: AnimType.BOTTOMSLIDE,
                                title: 'Please choose poster to book', 
                                btnOkOnPress: () {},
                                showCloseIcon: false,
                                btnOkColor: AppColor.darkColor
                                )..show();
                            }else{
                              addPDF(PDFPath!);
                            }
                            
                          });
                        }
                },
              ),
            ),
            ],
        )
                else  Container(
                  margin: EdgeInsets.only(top: 50),
                  child: Center(child: Image(image: AssetImage('assets/images/upload_progress.gif'),width: 100,),),),
              ],
            )  
        
          ],
        ),
      ),
    );
  
  }
  //widget textfeild please enter book name
  Widget BookName(){
    return TextFormField(
      controller: _BookNameController,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.menu_book,color: AppColor.darkColor,),
        labelText: "Enter book name..",
        errorText: texterrorBookName?"$NotMatchOrEmptyForBookName":null,
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
  //function get pdf from files
  void _pickFiles() async {
    
      _directoryPath = null;
      // _paths = await FilePicker.platform.pickFiles(
      //   type: FileType.custom,
      //   allowMultiple: false,
      //   //onFileLoading: (FilePickerStatus status) => print(status),
      //   allowedExtensions: ['pdf'],
        
      // );
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
  allowedExtensions: ['pdf'],
  
    );

      PlatformFile file1 = result!.files.first;
    print(file1.name);
  print(file1.bytes);
  print(file1.size);
  print(file1.extension);
  print(file1.path);
  if(file1.name !=null){
    setState(() {
      pdfFile="1";
      PDFPath=File(file1.path!);
      changePath(file1.path!);
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
  //widget get image selected
  Widget getProfileImage() {
    return (imageFile != null) ? Column(
      children: [
        Stack(
          children: [
            CircleAvatar(
              backgroundImage: FileImage(File(imageFile!)),
              radius: 55,
            ),
            Positioned(
                      right: 0,
                      top: 0,
                      child: InkWell(
                        child: CircleAvatar(
                        backgroundColor: AppColor.whiteColor,
                        radius: 16,
                        child: CircleAvatar(
                          radius: 14,
                        backgroundColor: AppColor.ErrorColor,
                        child: const Icon(
                          Icons.close,
                          color:AppColor.whiteColor,
                          size: 20,
                        ),
                        ),
                      ),
                      onTap: (){
                        setState(() {
                        imageFile=null;
                      });
                      },
                      )
                      ),
              
          ],
        ),
        SizedBox(height: 10,),
        Text("POSTER OF BOOK")
      ],
    ):Container(
            ) ;
  }
  //widget get pdf selected
  Widget getPdfImage() {
    return (PDFPath != null) ? Column(
      children: [
        Stack(
      children: [
        CircleAvatar(
          backgroundImage: AssetImage("assets/images/book_pdf.gif"),
          radius: 55,
        ),
        Positioned(
                  right: 0,
                  top: 0,
                  child: InkWell(
                    child: CircleAvatar(
                    backgroundColor: AppColor.whiteColor,
                    radius: 16,
                    child: CircleAvatar(
                      radius: 14,
                    backgroundColor: AppColor.ErrorColor,
                    child: const Icon(
                      Icons.close,
                      color:AppColor.whiteColor,
                      size: 20,
                    ),
                    ),
                  ),
                  onTap: (){
                    setState(() {
                    PDFPath=null;
                  });
                  },
                  )
                  ),
          
      ],
    ),
    SizedBox(height: 10,),

    Text("PDF BOOK"),
    
      ],
    ):Container(
            ) ;
  }
  //function uploade image 
  Future addImage(File imageFile) async{
// ignore: deprecated_member_use
var stream= new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
var length= await imageFile.length();
var uri = Uri.parse("${baseUrl}upload_pdf.php");

var request = new http.MultipartRequest("POST", uri);

var multipartFile = new http.MultipartFile("image", stream, length, filename: path.basename(imageFile.path));

request.files.add(multipartFile);
var respond = await request.send();
print(respond.request);
print("Status Code: ${respond.statusCode} \n Body: ${respond}");
if(respond.statusCode==200){
  print("Image Uploaded");
  addNewBook();
}else{
  print("Upload Failed");
}
  }
  //function uploade pdf 
  Future addPDF(File imageFile1) async{
    setState(() {
        visableUploadProgress=false;
      });
// ignore: deprecated_member_use
var stream= new http.ByteStream(DelegatingStream.typed(imageFile1.openRead()));
var length= await imageFile1.length();
var uri = Uri.parse("${baseUrl}upload_pdf.php");

var request = new http.MultipartRequest("POST", uri);

var multipartFile = new http.MultipartFile("image", stream, length, filename: path.basename(imageFile1.path));

request.files.add(multipartFile);
var respond = await request.send();
print(respond.request);
print("Status Code: ${respond.statusCode} \n Body: ${respond}");
if(respond.statusCode==200){
  print("PDF Uploaded");
  addImage(ImagePath);
}else{
  setState(() {
        visableUploadProgress=true;
      });
  AwesomeDialog(
                        context: context,
                        dialogType: DialogType.ERROR,
                        animType: AnimType.BOTTOMSLIDE,
                        title: 'This book is already exist', 
                        btnOkOnPress: () {
                          setState(() {
                            PDFPath=null;
                            imageFile=null;
                            _BookNameController.text="";
                          });
                        },
                        btnOkColor: AppColor.ErrorColor,
                        showCloseIcon: false
                        
                        )..show();
  print("PDF Failed");
}
  }
  //send request to add new book to db table
  addNewBook() async{
      
      
        var url=Uri.parse(addNewBookUrl);
        var response = await http.post(url,body: {
          "book_name":_BookNameController.text,
          "pdf_name_file":pdfName,
          "book_poster":imageName
        });
        if(response.statusCode==200){
          setState(() {
            visableUploadProgress=true;
          });
        AwesomeDialog(
                        context: context,
                        dialogType: DialogType.SUCCES,
                        animType: AnimType.BOTTOMSLIDE,
                        title: 'Add book successfully', 
                        btnOkOnPress: () {
                          setState(() {
                            PDFPath=null;
                            imageFile=null;
                            _BookNameController.text="";
                          });
                        },
                        showCloseIcon: false
                        
                        )..show();
        }else{
          print(response.statusCode);
          print(response.body);
        }
        
        
        
        
        }
  //function to change name pdf before uploade
  changePath(String lastPath)async{
    String dir = (await getApplicationDocumentsDirectory()).path;
    generateRandomString(20);
    setState(() {
      randomName=randomName!+".pdf";
      pdfName=randomName;
      print(randomName);
    });
    String newPath = path.join(dir, '$randomName');
    PDFPath= await File(lastPath).copy(newPath);
  }
  //function to change name pdf before uploade random string
  generateRandomString(int len) {
    var r = Random();
    setState(() {
       randomName =String.fromCharCodes(List.generate(len, (index)=> r.nextInt(33) + 89));
    });
    
    }


}