import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:nocotine/constants/colors.dart';
import 'package:nocotine/constants/screens.dart';
import 'package:nocotine/screens/books_lists_screen.dart';
import 'package:nocotine/screens/game_home_page.dart';
import 'package:flutter/material.dart';
import 'package:pushable_button/pushable_button.dart';

class IneedAsmookOptions extends StatefulWidget {
  // const IneedAsmookOptions({Key key}) : super(key: key);

  @override
  State<IneedAsmookOptions> createState() => _IneedAsmookOptionsState();
}

class _IneedAsmookOptionsState extends State<IneedAsmookOptions> {
  @override
  Widget build(BuildContext context) {
    final shadow = BoxShadow(
      color: AppColor.infoyColor.withOpacity(0.4),
      spreadRadius: 3,
      blurRadius: 4,
      offset: const Offset(0, 2),
    );
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('I Need A Smoke'),
        backgroundColor: AppColor.darkColor,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios)),
      ),
      body: Container(
        
  padding: const EdgeInsets.all(8.0),
  color: Colors.white,
  
  child: ContainedTabBarView(
    
    tabs: [
      Text('Play a game?'),
      Text('Read a book?'),
    ],
    tabBarProperties: TabBarProperties(
          indicatorColor: AppColor.primaryColor,
          labelColor: AppColor.primaryColor,
          unselectedLabelColor: AppColor.infoyColor,
        ),
    views: [
      GameHomePage(),
      BooksListsScreen()
    ],
    
  ),
),
     );
  }
}
