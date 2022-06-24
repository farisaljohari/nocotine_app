import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:nocotine/constants/cofig_api.dart';
import 'package:nocotine/constants/colors.dart';
import 'package:nocotine/constants/screens.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class DeleteBooksListsScreen extends StatefulWidget {
  const DeleteBooksListsScreen({ Key? key }) : super(key: key);

  @override
  State<DeleteBooksListsScreen> createState() => _DeleteBooksListsScreenState();
}

class _DeleteBooksListsScreenState extends State<DeleteBooksListsScreen> {
  List Books=[
    
    
  ];
  bool ShowProgress=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
    body: FutureBuilder(
              future: loadBooks(),
              builder: (context,snapshot){
                if(snapshot.hasData){
                  if(ShowProgress){
                    return GridView.builder(
                itemCount: Books.length,
                padding: EdgeInsets.all(5),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 5
                  
                ),
                itemBuilder: (context,index){
                  return InkWell(
      onTap: (){
        SaveBookData(context,Books[index]['book_name'],Books[index]['pdf_name_file']);
      },
      child: GridTile(
        child: Stack(children: [
          StatefulBuilder(
                              builder: (BuildContext context, StateSetter setState) => Container(
                              margin: EdgeInsets.only(left: 5,right: 5,top: 10,bottom: 10),
                              height: 200,
                              width: double.infinity,
                              child:CachedNetworkImage(
                                imageUrl: "$ImageBooKUrl${Books[index]['book_poster']}",
                                fit: BoxFit.fill,
                                progressIndicatorBuilder: (context, url, downloadProgress) => 
                                        Image(image: AssetImage('assets/images/loading_login.gif'),width: 20,),
                                errorWidget: (context, url, error) => Icon(Icons.error),
                              ))),
          Positioned(
                  right: 5,
                  top: 10,
                  child: InkWell(
                    child: CircleAvatar(
                    backgroundColor: AppColor.whiteColor,
                    radius: 21,
                    child: CircleAvatar(
                      radius: 20,
                    backgroundColor: AppColor.ErrorColor,
                    child: const Icon(
                      Icons.delete,
                      color:AppColor.whiteColor,
                      size: 20,
                    ),
                    ),
                  ),
                  onTap: (){
                     AwesomeDialog(
                                                    context: context,
                                                    dialogType: DialogType.NO_HEADER,
                                                    animType: AnimType.BOTTOMSLIDE,
                                                    btnCancelColor: AppColor.primaryColor,
                                                    btnOkColor: AppColor.darkColor,
                                                    title: 'Delete Book',
                                                    desc: 'Are you sure you want to delete this book?',
                                                    btnCancelOnPress: () {},
                                                    btnOkOnPress: () async{
                                                     deleteBook(Books[index]['book_id']);
                                                      
                                                    },
                                                    )..show();
                  },
                  )
                  ),
                                      
        ],),
        
        footer: Container(
          width: double.infinity,
          height: 40,
          color: AppColor.blackTransparentColor,
          child: Align(
            alignment: Alignment.center,
            child: Text("${Books[index]['book_name']}", style: TextStyle(
              color: Colors.white,
              fontFamily: 'Baloo 2',
              fontSize: 25,
              fontWeight: FontWeight.w700,
              shadows: [
                Shadow(color: AppColor.blackColor,blurRadius: 20)
              ]
            ),),
          ),
        )

      ),
    );
                });
    
                  }else{
                    return  Container(margin: EdgeInsets.only(top: 50), child: Center(child: Image(image: AssetImage('assets/images/loading_login.gif'),width: 50,),),);
                  }
                }
                else{
                  if(ShowProgress){
                    return GridView.builder(
                itemCount: Books.length,
                padding: EdgeInsets.all(5),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 5
                  
                ),
                itemBuilder: (context,index){
                  return InkWell(
      onTap: (){
        SaveBookData(context,Books[index]['book_name'],Books[index]['pdf_name_file']);
        
      },
      child: GridTile(
        child: Stack(children: [
          StatefulBuilder(
                              builder: (BuildContext context, StateSetter setState) => Container(
                              margin: EdgeInsets.only(left: 5,right: 5,top: 10,bottom: 10),
                              height: 200,
                              width: double.infinity,
                              child:CachedNetworkImage(
                                imageUrl: "$ImageUrl${Books[index]['Image']}",
                                fit: BoxFit.fill,
                                progressIndicatorBuilder: (context, url, downloadProgress) => 
                                        Image(image: AssetImage('assets/images/loading_login.gif'),width: 20,),
                                errorWidget: (context, url, error) => Icon(Icons.error),
                              ))),
          Positioned(
                  right: 5,
                  top: 10,
                  child: InkWell(
                    child: CircleAvatar(
                    backgroundColor: AppColor.whiteColor,
                    radius: 21,
                    child: CircleAvatar(
                      radius: 20,
                    backgroundColor: AppColor.ErrorColor,
                    child: const Icon(
                      Icons.delete,
                      color:AppColor.whiteColor,
                      size: 20,
                    ),
                    ),
                  ),
                  onTap: (){
                     AwesomeDialog(
                                                    context: context,
                                                    dialogType: DialogType.NO_HEADER,
                                                    animType: AnimType.BOTTOMSLIDE,
                                                    btnCancelColor: AppColor.primaryColor,
                                                    btnOkColor: AppColor.darkColor,
                                                    title: 'Delete Book',
                                                    desc: 'Are you sure you want to delete this book?',
                                                    btnCancelOnPress: () {},
                                                    btnOkOnPress: () async{
                                                     deleteBook(Books[index]['book_id']);
                                                      
                                                    },
                                                    )..show();
                  },
                  )
                  ),
                                      
        ],),
        
        footer: Container(
          width: double.infinity,
          height: 40,
          color: AppColor.blackTransparentColor,
          child: Align(
            alignment: Alignment.center,
            child: Text("${Books[index]['Name']}", style: TextStyle(
              color: Colors.white,
              fontFamily: 'Baloo 2',
              fontSize: 25,
              fontWeight: FontWeight.w700,
              shadows: [
                Shadow(color: AppColor.blackColor,blurRadius: 20)
              ]
            ),),
          ),
        )

      ),
    );
                });
    
                  }else{
                    return  Container(margin: EdgeInsets.only(top: 50), child: Center(child: Image(image: AssetImage('assets/images/loading_login.gif'),width: 50,),),);}}
              },
            ),
      
    );
  }
  //send requst to get all Books
  loadBooks()async{
    
  var url = Uri.parse(viewAllBooksUrl);
  var res = await http.get(url); 
  var responseBody = jsonDecode(res.body);
  if (mounted) setState(() {
    ShowProgress=true;
    Books=responseBody;
  });
  return Books;
  }
  //send requst to delete  Book
  deleteBook(String BookID) async{
    print(BookID);
      var url=Uri.parse(deleteBookUrl);
      var response = await http.post(url,body: {
        "Book_id":BookID,
      });
      if(response.statusCode==200){
        print("Body: ${response.body}");
        
      }else{
        print("statusCode: ${response.statusCode}");
        print("Body: ${response.body}");
      }
    
      
      }
  //save data book in sharedpreference
  SaveBookData(BuildContext context,String _BookName,String _BookPDF) async{
    
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // Save response
    
    preferences.setString(BookName, _BookName);
    preferences.setString(BookPDF, _BookPDF);
    
    // push to home screen
    Navigator.pushNamed(context, Screens.ViewBookPDF.value);
    
  }
  
}