import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:aqi/appConstant/AppConstant.dart';
import 'package:aqi/commonFunctions/CommonFunc.dart';
import 'package:aqi/dashboard/dashboard.dart';

class AppDrawer extends StatefulWidget {

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    return myDrawer(context);
  }
}

Widget myDrawer(
    BuildContext context,
    ) {
  var _dropDownValue;
  return SafeArea(
    child: ClipRRect(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(35), bottomRight: Radius.circular(35)),
        child: Drawer(
          child: ListView(
            children: [
              //Icon on Top
              Container(
                height: deviceHeight(context) * 0.23,
                color: AppConsts.primaryColor,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.fitWidth,
                        width: deviceWidth(context) * 0.6,
                        scale: 3.5,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),],
                  ),
                ),
              ),
              Container(
                height: deviceHeight(context),
                color: AppConsts.primaryColor.withOpacity(0.9),
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: deviceHeight(context) * 0.05,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.dashboard_customize_rounded,
                              color: AppConsts.primaryTextColor,
                            ),
                            SizedBox(
                              width: 15.0,
                            ),
                            InkWell(
                                onTap: () {
                                  Navigator.pushNamed(context, DashBoard.id);
                                },
                                child: AutoSizeText(
                                  'Dashboard',
                                  style: AppConsts.whiteBold,
                                  presetFontSizes: [22],
                                )),
                          ],
                        ),
                        SizedBox(
                          height: deviceHeight(context) * 0.005,
                        ),
                        Container(
                          height: 1.0,
                          width: deviceWidth(context) * 0.6,
                          color: AppConsts.primaryTextColor,
                        )
                      ],
                    ),
                    SizedBox(
                      height: deviceHeight(context) * 0.05,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_rounded,
                              color: AppConsts.primaryTextColor,
                            ),
                            SizedBox(
                              width: 15.0,
                            ),
                            InkWell(
                                onTap: () {
                                  // Navigator.pushNamed(
                                  //     context, OperationCenter.id);
                                },
                                child: AutoSizeText(
                                  'Operation center',
                                  style: AppConsts.whiteBold,
                                  presetFontSizes: [22],
                                )),
                          ],
                        ),
                        SizedBox(
                          height: deviceHeight(context) * 0.005,
                        ),
                        Container(
                          height: 1.0,
                          width: deviceWidth(context) * 0.6,
                          color: AppConsts.primaryTextColor,
                        )
                      ],
                    ),
                    SizedBox(
                      height: deviceHeight(context) * 0.04,
                    ),

                  Theme(
                    data: Theme.of(context).copyWith(
                      canvasColor: AppConsts.primaryColor,
                    ),
                    child: Container(
                      height:  deviceWidth(context) * 0.1,
                      width: deviceWidth(context) * 0.47,
                      child: DropdownButton(
                 hint: _dropDownValue == null
                         ? Text('Device sensors',style: TextStyle(color: AppConsts.primaryTextColor,fontSize:22,fontWeight:FontWeight.bold),)
                          : Text(
                             _dropDownValue,
                              style: TextStyle(color: Colors.white),
                              ),
                        isExpanded: true,
                        iconSize: 30.0,
                        style: TextStyle(color: Colors.white),
                        items: ['Types','Configuration'].map(
                        (value1) {
                         return DropdownMenuItem<String>(
                value: value1,
                child: Text(value1),
              );
            },
          ).toList(),
          onChanged: (value1) {
            setState(
                      () {
                _dropDownValue = value1;
              },
            );
          },
        ),
                    ),
                  ),

                  ],
                ),
              )
            ],
          ),
        )),
  );
}

void setState(Null Function() param0) {
}


