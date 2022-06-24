import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:flutter/material.dart';
import 'package:nocotine/admin/Admin_comp_completed.dart';
import 'package:nocotine/admin/admin_copm_inprogress.dart';
import 'package:nocotine/admin/admin_feedback_screen.dart';
import 'package:nocotine/constants/colors.dart';
class AdminCopmetition extends StatefulWidget {
  const AdminCopmetition({ Key? key }) : super(key: key);

  @override
  State<AdminCopmetition> createState() => _AdminCopmetitionState();
}

class _AdminCopmetitionState extends State<AdminCopmetition> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Competition"),
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
      Text('In Progress'),
      Text('Completed'),
    ],
    tabBarProperties: TabBarProperties(
          indicatorColor: AppColor.primaryColor,
          labelColor: AppColor.primaryColor,
          unselectedLabelColor: AppColor.infoyColor,
        ),
    views: [
      AdminCopmInProgress(),
      AdminCopmCopmleted()
    ],
    
  ),
),
    );
  }
}