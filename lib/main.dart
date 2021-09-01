import 'package:aqi/dashboard/dashboard.dart';
import 'package:aqi/login/login.dart';
import 'package:aqi/splash/splash.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get_storage/get_storage.dart';


Future <void> main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  var token = sharedPreferences.getString("token");
  runApp(MyHomePage(token: token));}
  class MyHomePage extends StatelessWidget {
    final String token;
    MyHomePage({this.token});
    @override
    Widget build(BuildContext context) {
      bool hasExpired = true ;
      if (token==null){
        hasExpired = true;
      }else{
        hasExpired = false;
      }

      return MaterialApp(
        debugShowCheckedModeBanner: false,
         initialRoute: Splash.id,
        //initialRoute:  hasExpired == false ? DashBoard.id: Login.id,
        routes: {
          Splash.id:(context)=>Splash(),
         Login.id:(context) => Login(),
          DashBoard.id:(context) => DashBoard(),

        },
      );

    }
  }
