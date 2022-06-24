import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:nocotine/constants/cofig_api.dart';
import 'package:nocotine/constants/colors.dart';
import 'package:nocotine/constants/screens.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
class ImportantQuestion extends StatefulWidget {
  const ImportantQuestion({ Key? key }) : super(key: key);

  @override
  State<ImportantQuestion> createState() => _ImportantQuestionState();
}

class _ImportantQuestionState extends State<ImportantQuestion> {
  int currentStep = 0;
  double NumOfPackets=0.0;
  double PriceOfPackets=0.0;
  bool visableProgress=true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body:SafeArea(
        child: Column(
          children: [
            if(visableProgress)Column(
        children: [
          SizedBox(height: 40,),
          Text("one last thing..",style: TextStyle(fontSize: 30,fontWeight: FontWeight.w700,fontFamily: 'Baloo 2',color: AppColor.primaryColor),),
          SizedBox(height: 40,),
          Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: AppColor.primaryColor
              )
            ),
            child: Stepper(
            controlsBuilder: (BuildContext context, ControlsDetails details) {
        return Row(
              children: <Widget>[
                currentStep == 0
                    ? TextButton(
                        onPressed: (){
                          setState(() {
                            currentStep++;
                          });
                        },
                        child: const Text('NEXT'),
                      )
                    : currentStep >= 1
                            ? Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextButton(
                                      onPressed: (){
                                  setState(() {
                                    updateVisbleSheet();
                                  });
                                },
                                      child: const Text('SAVE'),
                                    ),
                                    TextButton(
                                      onPressed: (){
                                  setState(() {
                                    currentStep--;
                                  });
                                },
                                      child: const Text('BACK'),
                                    ),
                                  ],
                                ),
                              )
                            : TextButton(
                                onPressed: (){

                                },
                                child: const Text('BACK'),
                              ),
              ],
            );},
        
            currentStep: currentStep,
            onStepTapped: (index){
              setState(() {
                currentStep=index;
              });
            },
            
            
            steps: [
              Step(
                isActive: currentStep>=0,
                title: Text("Number cigarettes"),
                content: Container(
                  width: double.infinity,
                  height: 150,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text("How many packs of cigarettes do you \nsmoke per day?",style: TextStyle(fontSize: 15),),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 30,right: 30),
                      child: SpinBox(
                      min: 0,
                      max: 5,
                      value: 0,
                      decimals: 1,
                      step: 0.5,
                      iconColor: MaterialStateProperty.resolveWith((states) {
                                if (states.contains(MaterialState.disabled)) {
                                  return Colors.grey;
                                }
                                if (states.contains(MaterialState.error)) {
                                  return Colors.red;
                                }
                                if (states.contains(MaterialState.focused)) {
                                  return AppColor.primaryColor;

                                }
                                return AppColor.primaryColor;
                              }),
                      decoration: InputDecoration(
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
                              width: 4,
                              color: AppColor.darkColor,
                              ),
                        ),
                  ),
                      onChanged: (value) {
                        setState(() {
                          NumOfPackets=value;
                        });
                      },
                          ),
                ),
                  ],
                ),
                
                )),
              Step(
                isActive: currentStep>=1,
                title: Text("Cost of cigarettes"),
                content: Container(
                  width: double.infinity,
                  height: 150,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text("How much does a pack of cigarettes \ncost?",style: TextStyle(fontSize: 15),),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 30,right: 30),
                      child: SpinBox(
                      min: 0,
                      max: 5,
                      value: 0,
                      decimals: 1,
                      step: 0.1,
                      iconColor: MaterialStateProperty.resolveWith((states) {
                                if (states.contains(MaterialState.disabled)) {
                                  return Colors.grey;
                                }
                                if (states.contains(MaterialState.error)) {
                                  return Colors.red;
                                }
                                if (states.contains(MaterialState.focused)) {
                                  return AppColor.primaryColor;

                                }
                                return AppColor.primaryColor;
                              }),
                      decoration: InputDecoration(
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
                              width: 4,
                              color: AppColor.darkColor,
                              ),
                        ),
                  ),
                      onChanged: (value) {
                        PriceOfPackets=value;
                      },
                                    ),
                          ),
          ],
                ),
                )),
              
            ],
            )
        )
          ],
      )else Expanded(child:Center(child: Image(image: AssetImage('assets/images/loading_login.gif'),width: 50,),),
              )
          
            ],
        )
      )
  );}
  //send requst to update VisbleSheet in data base =1
  updateVisbleSheet() async{
    setState(() {
      visableProgress=false;
    });
    SharedPreferences preferences = await SharedPreferences.getInstance();
      
      var _userId=preferences.getString(id);
      var url=Uri.parse(updateVisbleSheetURL);
      var response = await http.post(url,body: {
        "user_id":_userId,
        "num_packets":NumOfPackets.toString(),
        "price_packets":PriceOfPackets.toString(),
      });
      
      if(response.statusCode==200){
        setState(() {
          
          // Save response
          
          preferences.setDouble(num_packets, NumOfPackets);
          preferences.setDouble(price_packets, PriceOfPackets);
          preferences.setDouble(price_one_cigratte, preferences.getDouble(price_packets)!/20);
          Navigator.pushReplacementNamed(context, Screens.mainScreen.value);
          
        });
        
      }
    
      
      }

  
}



