// main.dart
import 'package:nocotine/constants/cofig_api.dart';
import 'package:nocotine/constants/colors.dart';
import 'package:nocotine/constants/screens.dart';
import 'package:nocotine/screens/other_profile_screen.dart';
import 'package:nocotine/screens/search_Myprofile_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
class SearchBar extends StatefulWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  TextEditingController _SearchBarController=new TextEditingController();
  // This holds a list of fiction users
  // You can use data fetched from a database or a server as well
  List<Map<String, dynamic>> _allUsers = [
    
  ];

  // This list holds the data for the list view
  List<Map<String, dynamic>> _foundUsers = [];
  @override
  initState() {
    setState(() {
      loadUsers();
    });
    // at the beginning, all users are shown
    _foundUsers = _allUsers;
    super.initState();
  }

  // This function is called whenever the text field changes
  void _runFilter(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      //results = _allUsers;
    } else {
      results = _allUsers
          .where((user) =>
              user["Name"].toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      _foundUsers = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 8,
            ),
            TextField(
              cursorColor: AppColor.infoyColor,
              controller: _SearchBarController,
              onChanged: (value) => _runFilter(value),
              decoration:  InputDecoration(
                prefixIcon:  IconButton(onPressed: (){
              Navigator.pop(context);
            }, icon: Icon(Icons.arrow_back_ios,color: AppColor.infoyColor)),
            suffixIcon:  IconButton(onPressed: (){
              setState(() {
                _SearchBarController.text="";
                _runFilter(_SearchBarController.text);
              });
            }, icon: Icon(Icons.clear,color: AppColor.infoyColor)),
                  hintText: 'Search',
                  enabledBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          
          borderSide: BorderSide(
            color: AppColor.whiteColor,width: 4)

        ),
                  focusedBorder: UnderlineInputBorder(
          
          borderRadius: BorderRadius.circular(10),
          
          borderSide: BorderSide(
            width: 3,
            color: AppColor.whiteColor,
            
            ),
            
      )
                  ),
                  
            ),
            const SizedBox(
              height: 6,
            ),
            Divider(height: 1,thickness: 1.5,),
          
            FutureBuilder(
              future: loadUsers(),
              builder: (context,snapshot){
                if(snapshot.hasData){
                  return Expanded(
              child: _foundUsers.isNotEmpty
                  ? ListView.builder(
                      itemCount: _foundUsers.length,
                      itemBuilder: (context, index) => Card(
                        color: AppColor.whiteColor,
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: ListTile(
                          leading:  CircleAvatar(
                            backgroundColor: AppColor.infoyColor,
                            radius: 15,
                            backgroundImage:NetworkImage("$ImageUrl${_foundUsers[index]['image']}"),
                          ),
                          title: Text(_foundUsers[index]['Name'],style: TextStyle(fontWeight: FontWeight.bold),),
                          subtitle: Text(
                              '${_foundUsers[index]["email"].toString()}'),
                          onTap: ()async{
                            SharedPreferences preferences = await SharedPreferences.getInstance();
                            if(_foundUsers[index]['id']==preferences.getString(id)){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchProfileScreen()));
                            }else{
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>OtherProfileScreen(userId: _foundUsers[index]['id'])));
                            }
                            
                          },
                        ),
                      ),
                    )
                  : Column(
                    children: [
                      Image(image: AssetImage("assets/images/notFoundSearch.gif"),width: 200,)
                    ],
                  ),
            );
          
                }
                else{
                  return Container(margin: EdgeInsets.only(top: 50), child: Center(child: Image(image: AssetImage('assets/images/loading_login.gif'),width: 50,),),);
                }
              },
            ),
      
            ],
        ),));

    
  }
  //send requst to get all user data 
  loadUsers()async{
    
  var url = Uri.parse(allUsersURl);
  var res = await http.get(url); 
    
    var responseBody=(jsonDecode(res.body) as List).map((e) => e as Map<String, dynamic>).toList();
    _allUsers=responseBody;
    return _allUsers;

  }
}