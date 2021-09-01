import 'dart:async';
import 'dart:convert';
import 'package:aqi/dashboard/dashboard.dart';
import 'package:aqi/drawer/drawer.dart';
import 'package:flutter/material.dart';
import 'package:aqi/appConstant/AppConstant.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:aqi/commonFunctions/CommonFunc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:rounded_loading_button/rounded_loading_button.dart';




class Login extends StatefulWidget {
static const id = 'Login';
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool theme = darkMode;

  final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();
  void _onLoading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(child: CircularProgressIndicator());
      },
    );
    new Future.delayed(new Duration(seconds: 6), () {
    });
  }
  void postRequest(var tenant, var email, var password) async{
    var uri = Uri.parse("https://iot.dev.onstak.io/services/identity/api/v2/accounts/user/authentication");
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map<String,dynamic> body = {
      "tenant": tenant,
      "email": email,
      "password": password,
    };
    Map<String,String> headers={
      "Content-Type":"application/json"
    };
    var jsonResponse;
    var response = await http.post(uri , body: json.encode(body), headers:headers
    );
    print("response in login${response.body}");

    if(response.statusCode==200){

      myTokenClass totalElements = myTokenClass.fromJson(json.decode(response.body));
      print("myTokenCLass ${totalElements.token}");
      await sharedPreferences.setString('token',totalElements.token) ;
      var token = sharedPreferences.getString('token');
      print("token is here $token");
      if(jsonResponse!= null && token!=null){
        SharedPreferences prefs =
        await SharedPreferences.getInstance();
        prefs.setString('tenant', 'usapparel');
        prefs.setString('email', 'admin@usapparel.com');
        prefs.setString('password', 'usapparel123\$\$\!');
        prefs.setString('token', token);
        prefs.setString('token', jsonResponse.token);
      }
      Navigator.push(context, MaterialPageRoute(builder: (context)=>DashBoard()));
    }else{
      SnackBar(content: Text("PLease check credevtials or Internet Service"));
    }
  }
  var tenant;
  var email;
  var password;
  bool _isLoading = false;
  bool showSpinner = false;
  bool _showPassword = false;

   @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppConsts.secondaryColor,
        //keyboard
        // resizeToAvoidBottomPadding: false,
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage('assets/images/background.jpg'),fit: BoxFit.cover)
            ),
            height: MediaQuery.of(context).size.height * 1.0,
            child: ModalProgressHUD(
              inAsyncCall: showSpinner,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.14,
                        height: MediaQuery.of(context).size.height * 0.14,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                              // fit: BoxFit.fitHeight,
                                image: AssetImage(
                                    'assets/images/minilogo.png'))),
                      ),
                    ),
                    SizedBox(
                      height: 40.0,
                    ),
                    Center(
                      child: AutoSizeText(
                        'Login',
                        style: AppConsts.whiteBold,
                        presetFontSizes: [44],
                      ),
                    ),
                    SizedBox(
                      height: 40.0,
                    ),

                    //tenant
                    SizedBox(
                      height: 50,
                      width: deviceWidth(context) * 0.8,
                      child: TextFormField(
                        onChanged: (var value) {
                          if (value.isEmpty) {
                            return ' must fill';
                          }
                          tenant = value;
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.file_present,
                            color: AppConsts.secTextColor,
                          ),
                          fillColor: AppConsts.primaryTextColor,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          hintText: "tenant",
                          hintStyle: AppConsts.blackBold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),

                    //email
                    SizedBox(
                      height: 50,
                      width: deviceWidth(context),
                      child: TextField(
                        onChanged: (var value) {
                          if (value.isEmpty) {
                            return ' must fill';
                          }
                          email = value;
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.email,
                            color: AppConsts.secTextColor,
                          ),
                          fillColor: AppConsts.primaryTextColor,
                          filled: true,
                          hintText: 'email',
                          hintStyle: AppConsts.blackBold,

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),

                        ),
                      ),
                    ),
                    SizedBox(height:8.0),

                    ///password
                    SizedBox(
                      height: 50,
                      width: deviceWidth(context),
                      child: TextField(
                        onChanged: (var value) {
                          if (value.isEmpty) {
                            return ' must fill';
                          }
                          password = value;
                        },
                        obscureText: !this._showPassword,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.password,
                            color: AppConsts.secTextColor,
                          ),
                          fillColor: AppConsts.primaryTextColor,
                          filled: true,
                          hintText: 'password',
                          hintStyle: AppConsts.blackBold,

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          //prefixIcon: Icon(Icons.security),
                            suffixIcon: IconButton(
                                icon: Icon(
                                    _showPassword ? Icons.visibility : Icons.visibility_off),
                                onPressed: () {
                                  setState(() {
                                    _showPassword = !_showPassword;
                                  });
                                })),
                      ),
                    ),
                    SizedBox(
                      height: 50.0,
                    ),
                    SizedBox(
                      height: 50,
                      width: deviceWidth(context) * 0.8,
                      child: RaisedButton(
                          color: Colors.white,
                          child: AutoSizeText(
                            "Login",
                            style: AppConsts.blackBold,
                            presetFontSizes: [22],
                          ),
                         // controller: _btnController,
                          onPressed: () async {
                            _onLoading();
                            await postRequest(tenant,email,password);
                          }

                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
class   myTokenClass {
  String version;
  String token;
  String timestamp;

  myTokenClass({this.version, this.token, this.timestamp});

  myTokenClass.fromJson(Map<String, dynamic> json) {
    version = json['version'];
    token = json['token'];
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['version'] = this.version;
    data['token'] = this.token;
    data['timestamp'] = this.timestamp;
    return data;
  }
}