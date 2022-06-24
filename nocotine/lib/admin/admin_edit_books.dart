import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:flutter/material.dart';
import 'package:nocotine/admin/admin_add_book.dart';
import 'package:nocotine/admin/admin_remove_books.dart';
import 'package:nocotine/constants/colors.dart';
class AdminEditBooks extends StatefulWidget {
  const AdminEditBooks({ Key? key }) : super(key: key);

  @override
  State<AdminEditBooks> createState() => _AdminEditBooksState();
}

class _AdminEditBooksState extends State<AdminEditBooks> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Edit Books"),
        backgroundColor: AppColor.darkColor,
        leading: IconButton(onPressed: (){
        Navigator.pop(context);
      }, icon: Icon(Icons.arrow_back_ios)),
      ),
      body: Container(
        
  padding: const EdgeInsets.all(8.0),
  color: Colors.white,
  
  child: ContainedTabBarView(
    
    tabs: [
      Text('Add book'),
      Text('Delete book'),
    ],
    tabBarProperties: TabBarProperties(
          indicatorColor: AppColor.primaryColor,
          labelColor: AppColor.primaryColor,
          unselectedLabelColor: AppColor.infoyColor,
        ),
    views: [
      AdminAddBooks(),
      DeleteBooksListsScreen()
    ],
    
  ),
),);
  ;
  }
}