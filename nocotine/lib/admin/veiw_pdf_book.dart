import 'package:nocotine/constants/cofig_api.dart';
import 'package:nocotine/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
class VeiwPDFBook extends StatefulWidget {
  const VeiwPDFBook({ Key? key }) : super(key: key);

  @override
  State<VeiwPDFBook> createState() => _VeiwPDFBookState();
}

class _VeiwPDFBookState extends State<VeiwPDFBook> {
  String BookNameAppBar="loading..";
  String BookPDFlink="";
  bool VisablePDF=false;
  @override
  void initState() {
    setState(() {
      getBookData();
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
      automaticallyImplyLeading: false,
      centerTitle: true,
      title:Text('$BookNameAppBar'),
      backgroundColor: AppColor.darkColor,
      leading: IconButton(onPressed: (){
        Navigator.pop(context);
      }, icon: Icon(Icons.arrow_back_ios)),
    )
      ,
      body:Column(
        children: [
          if(VisablePDF)Expanded(child: 
          Container(
          child: SfPdfViewer.network(
              '${baseUrl}pdf/$BookPDFlink'),
          
        )) else Container(margin: EdgeInsets.only(top: 50), child: Center(child: Image(image: AssetImage('assets/images/loading_login.gif'),width: 50,),),)
        ],
      ),
    
    );
  }
  //send requst to view all books
  getBookData()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // // Save response
    // if(preferences.getString(BookName)!=null&&
    //   preferences.getString(BookPDF)!=null
    // ){
    //   setState(() {
    //   BookNameAppBar=preferences.getString(BookName)!;
    //   BookPDFlink=preferences.getString(BookPDF)!;
    //   VisablePDF=true;
    // });
    // }
    Future.delayed(const Duration(seconds: 2), () {

// Here you can write your code

   setState(() {
      BookNameAppBar=preferences.getString(BookName)!;
      BookPDFlink=preferences.getString(BookPDF)!;
      VisablePDF=true;
    });

});
    
  }
}