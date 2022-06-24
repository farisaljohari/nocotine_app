import 'package:nocotine/constants/colors.dart';
import 'package:flutter/material.dart';
import 'game_body_screen.dart';

class GameHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
          
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
            
              Container(
                child:Image.asset("assets/images/xo_image.gif",width: 200,)
              ),
              SizedBox(height: 40,),
              Center(
                child: Container(
                  
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      
                      InkWell(
                        child: Container(
                          padding: EdgeInsets.all(10),
                          width: 120,
                          child: Center(child: Text("vs Bot",style: TextStyle(color: AppColor.whiteColor,fontWeight: FontWeight.bold),)),
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
                            Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return GameBodyScreen(true);
                          }));
                          },
                          ),
                          SizedBox(width: 20,),
                          InkWell(
                        child: Container(
                          padding: EdgeInsets.all(10),
                          width: 120,
                          child: Center(child: Text("vs Friend",style: TextStyle(color: AppColor.whiteColor,fontWeight: FontWeight.bold),)),
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
                            Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return GameBodyScreen(false);
                          }));
                          },
                          ),
                    
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }
}
