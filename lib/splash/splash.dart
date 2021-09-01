import 'dart:async';

import 'package:aqi/dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:aqi/appConstant/AppConstant.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:aqi/commonFunctions/CommonFunc.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:aqi/login/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';


class Splash extends StatefulWidget {
  static const id = 'splash';

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  tokenExpire()async{
    Timer(Duration(seconds: 3), () async{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      bool hasExpired = true;
      if (token != null) {
        hasExpired = JwtDecoder.isExpired(token);
      }
      if (token != null && !hasExpired) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DashBoard()),
        );
      } else {
        print('in else');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
      }    });
  }
  @override
  void initState() {
    tokenExpire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          //backgroundColor: Image.asset('images/background.jpg').color,
        //backgroundColor: AppConsts.primaryColor,
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage('assets/images/background.jpg'),fit: BoxFit.cover),
            color: AppConsts.primaryColor,

          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                DelayedDisplay(
                  fadingDuration: Duration(milliseconds: 1800),
                  slidingCurve: Curves.easeInOutBack,
                  slidingBeginOffset: Offset(0, -1.2),
                  child: Image.asset(
                    'assets/images/minilogo.png',
                    height: deviceHeight(context) * 0.2,
                    width: deviceWidth(context) * 0.4,
                  ),
                ),
                DelayedDisplay(
                  fadingDuration: Duration(milliseconds: 1800),
                  slidingBeginOffset: Offset(0, 1.2),
                  child: AutoSizeText(
                    'Usapparel',
                    style: AppConsts.whiteBoldWithSpacing,
                    presetFontSizes: [38],
                  ),
                )
              ],
            ),
          ),
        ),
    ),
      );
  }

}
