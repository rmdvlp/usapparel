import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:aqi/commonFunctions/CommonFunc.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:aqi/appConstant/AppConstant.dart';
import 'package:aqi/drawer/drawer.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_echarts/flutter_echarts.dart';
import 'package:aqi/appConstant/dark_theme_script.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aqi/Model Classes/totalEvents.dart';
import 'package:date_time_format/date_time_format.dart';

class DashBoard extends StatefulWidget {
  static const id = 'Dashboard';
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  var icon;
  Map data;
  bool theme = darkMode;
  Timer timer;
  DateTime pickedDate2;
  DateTime pickedDate1;
  List<dynamic> tempCValue = [];
  List<dynamic> tempCTime = [];
  List<dynamic> tempCValueGraph = [];
  List<dynamic> tempCTimeGraph = [];

  int lastDay = 0;
  DateTime now = DateTime.now();
  var pickedDate;

  ///new veriables
  List<DashboarModelClass> aqi;
  var celcius = "\u2103";
  var tempC;
  var humidity;
  var feelLikeC;

//chart for temc
  List<dynamic> temCValueList = [].obs;
  List<dynamic> temCTimeList = [].obs;
//chart for feelsLikeC
  List<dynamic> feelLikeValueList = [].obs;
  List<dynamic> feelLikeTimeList = [].obs;
  //chart for humidity
  List<dynamic> humidityValueList = [].obs;
  List<dynamic> humidityTimeList = [].obs;

  //  pickedDate = DateTime(now.year,now.month, now.day, 0, 0, 1);
  //  pickedDate1 = DateTime(now.year,now.month, now.day, 23,59,59);
  // int lastDay = DateTime(now.year, now.month, now.day).day;
  // int hours = DateTime.now().hour;
  /// Post/get Request for data fetching
  fetchData(int type) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.getString('token');
    //ee928473
    print("token of D $token");
    DateTime now = DateTime.now();
    pickedDate = DateTime(now.year, now.month, now.day, 0, 0, 1);
    pickedDate1 = DateTime(now.year, now.month, now.day, 23, 59, 59);
    lastDay = DateTime(now.year, now.month, now.day).day;
    int hours = DateTime.now().hour;
    print(
        "check date${pickedDate.subtract(new Duration(days: 30)).toString().replaceAll(' ', 'T')}+05:00/${pickedDate1.toString().replaceAll(' ', 'T')}+05:00");
    // print("check dates${pickedDate.subtract(new Duration(days: lastDay - 7))
    //     .toString()
    //     .replaceAll(' ', 'T')}+05:00/${pickedDate1.toString()
    //     .replaceAll(' ', 'T')}+05:00");

    // print("${pickedDate.subtract(new Duration(days: 30)).toString().replaceAll(
    //     ' ', 'T')}+05:00/${pickedDate1.toString().replaceAll(
    //     ' ', 'T')}+05:00");
    // Map data = {
    //    "queryType": "timeseries",
    //    "granularity": "hour",
    //    "aggregations": [
    //      {
    //        "type": "filtered",
    //        "filter": {
    //          "type": "and",
    //          "fields": [
    //            {
    //              "type": "selector",
    //              "dimension": "label",
    //              "value": "tempC"
    //            },
    //            {
    //              "type": "selector",
    //              "dimension": "clientId",
    //              "value": "2a5afe76e7d50860"
    //            }
    //          ]
    //        },
    //        "aggregator":
    //        {
    //          "type": "count",
    //          "name": "tempCount",
    //          "fieldName": "value"
    //        }
    //      },
    //      {
    //        "type": "filtered",
    //        "filter": {
    //          "type": "and",
    //          "fields": [
    //            {
    //              "type": "selector",
    //              "dimension": "label",
    //              "value": "tempC"
    //            },
    //            {
    //              "type": "selector",
    //              "dimension": "clientId",
    //              "value": "2a5afe76e7d50860"
    //            }
    //          ]
    //        },
    //        "aggregator":
    //        {
    //          "type": "doubleSum",
    //          "name": "tempSum",
    //          "fieldName": "value"
    //        }
    //      },
    //
    //
    //
    //
    //      {
    //        "type": "filtered",
    //        "filter": {
    //          "type": "and",
    //          "fields": [
    //            {
    //              "type": "selector",
    //              "dimension": "label",
    //              "value": "feelsLikeC"
    //            },
    //            {
    //              "type": "selector",
    //              "dimension": "clientId",
    //              "value": "2a5afe76e7d50860"
    //            }
    //          ]
    //        },
    //        "aggregator":
    //        {
    //          "type": "count",
    //          "name": "feelsLikeCount",
    //          "fieldName": "value"
    //        }
    //      },
    //      {
    //        "type": "filtered",
    //        "filter": {
    //          "type": "and",
    //          "fields": [
    //            {
    //              "type": "selector",
    //              "dimension": "label",
    //              "value": "feelsLikeC"
    //            },
    //            {
    //              "type": "selector",
    //              "dimension": "clientId",
    //              "value": "2a5afe76e7d50860"
    //            }
    //          ]
    //        },
    //        "aggregator":
    //        {
    //          "type": "doubleSum",
    //          "name": "feelsLikeSum",
    //          "fieldName": "value"
    //        }
    //      },
    //
    //
    //
    //
    //      {
    //        "type": "filtered",
    //        "filter": {
    //          "type": "and",
    //          "fields": [
    //            {
    //              "type": "selector",
    //              "dimension": "label",
    //              "value": "humidity"
    //            },
    //            {
    //              "type": "selector",
    //              "dimension": "clientId",
    //              "value": "2a5afe76e7d50860"
    //            }
    //          ]
    //        },
    //        "aggregator":
    //        {
    //          "type": "count",
    //          "name": "humidityCount",
    //          "fieldName": "value"
    //        }
    //      },
    //      {
    //        "type": "filtered",
    //        "filter": {
    //          "type": "and",
    //          "fields": [
    //            {
    //              "type": "selector",
    //              "dimension": "label",
    //              "value": "humidity"
    //            },
    //            {
    //              "type": "selector",
    //              "dimension": "clientId",
    //              "value": "2a5afe76e7d50860"
    //            }
    //          ]
    //        },
    //        "aggregator":
    //        {
    //          "type": "doubleSum",
    //          "name": "humiditySum",
    //          "fieldName": "value"
    //        }
    //      }
    //    ],
    //    "postAggregations": [
    //      {
    //        "type": "arithmetic",
    //        "name": "AvgTemp",
    //        "fn": "/",
    //        "fields": [
    //          {
    //            "type": "fieldAccess",
    //            "fieldName": "tempSum"
    //          },
    //          {
    //            "type": "fieldAccess",
    //            "fieldName": "tempCount"
    //          }
    //        ]
    //      },
    //
    //      {
    //        "type": "arithmetic",
    //        "name": "feelsLikeCTemp",
    //        "fn": "/",
    //        "fields": [
    //          {
    //            "type": "fieldAccess",
    //            "fieldName": "feelsLikeSum"
    //          },
    //          {
    //            "type": "fieldAccess",
    //            "fieldName": "feelsLikeCount"
    //          }
    //        ]
    //      },
    //      {
    //        "type": "arithmetic",
    //        "name": "Avghumidity",
    //        "fn": "/",
    //        "fields": [
    //          {
    //            "type": "fieldAccess",
    //            "fieldName": "humiditySum"
    //          },
    //          {
    //            "type": "fieldAccess",
    //            "fieldName": "humidityCount"
    //          }
    //        ]
    //      }
    //    ],
    //    "intervals": [
    //      "2021-08-31T00:00:01.000Z/2021-08-31T18:59:59.999Z"
    //    ]
    //
    //  };
    if (type == 1) {
      data = {
        "queryType": "timeseries",
        "granularity": "hour",
        "aggregations": [
          {
            "type": "filtered",
            "filter": {
              "type": "and",
              "fields": [
                {"type": "selector", "dimension": "label", "value": "tempC"},
                {
                  "type": "selector",
                  "dimension": "clientId",
                  "value": "2a5afe76e7d50860"
                }
              ]
            },
            "aggregator": {
              "type": "count",
              "name": "tempCount",
              "fieldName": "value"
            }
          },
          {
            "type": "filtered",
            "filter": {
              "type": "and",
              "fields": [
                {"type": "selector", "dimension": "label", "value": "tempC"},
                {
                  "type": "selector",
                  "dimension": "clientId",
                  "value": "2a5afe76e7d50860"
                }
              ]
            },
            "aggregator": {
              "type": "doubleSum",
              "name": "tempSum",
              "fieldName": "value"
            }
          },
          {
            "type": "filtered",
            "filter": {
              "type": "and",
              "fields": [
                {
                  "type": "selector",
                  "dimension": "label",
                  "value": "feelsLikeC"
                },
                {
                  "type": "selector",
                  "dimension": "clientId",
                  "value": "2a5afe76e7d50860"
                }
              ]
            },
            "aggregator": {
              "type": "count",
              "name": "feelsLikeCount",
              "fieldName": "value"
            }
          },
          {
            "type": "filtered",
            "filter": {
              "type": "and",
              "fields": [
                {
                  "type": "selector",
                  "dimension": "label",
                  "value": "feelsLikeC"
                },
                {
                  "type": "selector",
                  "dimension": "clientId",
                  "value": "2a5afe76e7d50860"
                }
              ]
            },
            "aggregator": {
              "type": "doubleSum",
              "name": "feelsLikeSum",
              "fieldName": "value"
            }
          },
          {
            "type": "filtered",
            "filter": {
              "type": "and",
              "fields": [
                {"type": "selector", "dimension": "label", "value": "humidity"},
                {
                  "type": "selector",
                  "dimension": "clientId",
                  "value": "2a5afe76e7d50860"
                }
              ]
            },
            "aggregator": {
              "type": "count",
              "name": "humidityCount",
              "fieldName": "value"
            }
          },
          {
            "type": "filtered",
            "filter": {
              "type": "and",
              "fields": [
                {"type": "selector", "dimension": "label", "value": "humidity"},
                {
                  "type": "selector",
                  "dimension": "clientId",
                  "value": "2a5afe76e7d50860"
                }
              ]
            },
            "aggregator": {
              "type": "doubleSum",
              "name": "humiditySum",
              "fieldName": "value"
            }
          }
        ],
        "postAggregations": [
          {
            "type": "arithmetic",
            "name": "AvgTemp",
            "fn": "/",
            "fields": [
              {"type": "fieldAccess", "fieldName": "tempSum"},
              {"type": "fieldAccess", "fieldName": "tempCount"}
            ]
          },
          {
            "type": "arithmetic",
            "name": "feelsLikeCTemp",
            "fn": "/",
            "fields": [
              {"type": "fieldAccess", "fieldName": "feelsLikeSum"},
              {"type": "fieldAccess", "fieldName": "feelsLikeCount"}
            ]
          },
          {
            "type": "arithmetic",
            "name": "Avghumidity",
            "fn": "/",
            "fields": [
              {"type": "fieldAccess", "fieldName": "humiditySum"},
              {"type": "fieldAccess", "fieldName": "humidityCount"}
            ]
          }
        ],
        "intervals": [
          "${pickedDate.subtract(new Duration(days: 1)).toString().replaceAll(' ', 'T')}+05:00/${pickedDate1.toString().replaceAll(' ', 'T')}+05:00"
        ]
      };
    } else if (type == 2) {
      data = {
        "queryType": "timeseries",
        "granularity": "day",
        "aggregations": [
          {
            "type": "filtered",
            "filter": {
              "type": "and",
              "fields": [
                {"type": "selector", "dimension": "label", "value": "tempC"},
                {
                  "type": "selector",
                  "dimension": "clientId",
                  "value": "2a5afe76e7d50860"
                }
              ]
            },
            "aggregator": {
              "type": "count",
              "name": "tempCount",
              "fieldName": "value"
            }
          },
          {
            "type": "filtered",
            "filter": {
              "type": "and",
              "fields": [
                {"type": "selector", "dimension": "label", "value": "tempC"},
                {
                  "type": "selector",
                  "dimension": "clientId",
                  "value": "2a5afe76e7d50860"
                }
              ]
            },
            "aggregator": {
              "type": "doubleSum",
              "name": "tempSum",
              "fieldName": "value"
            }
          },
          {
            "type": "filtered",
            "filter": {
              "type": "and",
              "fields": [
                {
                  "type": "selector",
                  "dimension": "label",
                  "value": "feelsLikeC"
                },
                {
                  "type": "selector",
                  "dimension": "clientId",
                  "value": "2a5afe76e7d50860"
                }
              ]
            },
            "aggregator": {
              "type": "count",
              "name": "feelsLikeCount",
              "fieldName": "value"
            }
          },
          {
            "type": "filtered",
            "filter": {
              "type": "and",
              "fields": [
                {
                  "type": "selector",
                  "dimension": "label",
                  "value": "feelsLikeC"
                },
                {
                  "type": "selector",
                  "dimension": "clientId",
                  "value": "2a5afe76e7d50860"
                }
              ]
            },
            "aggregator": {
              "type": "doubleSum",
              "name": "feelsLikeSum",
              "fieldName": "value"
            }
          },
          {
            "type": "filtered",
            "filter": {
              "type": "and",
              "fields": [
                {"type": "selector", "dimension": "label", "value": "humidity"},
                {
                  "type": "selector",
                  "dimension": "clientId",
                  "value": "2a5afe76e7d50860"
                }
              ]
            },
            "aggregator": {
              "type": "count",
              "name": "humidityCount",
              "fieldName": "value"
            }
          },
          {
            "type": "filtered",
            "filter": {
              "type": "and",
              "fields": [
                {"type": "selector", "dimension": "label", "value": "humidity"},
                {
                  "type": "selector",
                  "dimension": "clientId",
                  "value": "2a5afe76e7d50860"
                }
              ]
            },
            "aggregator": {
              "type": "doubleSum",
              "name": "humiditySum",
              "fieldName": "value"
            }
          }
        ],
        "postAggregations": [
          {
            "type": "arithmetic",
            "name": "AvgTemp",
            "fn": "/",
            "fields": [
              {"type": "fieldAccess", "fieldName": "tempSum"},
              {"type": "fieldAccess", "fieldName": "tempCount"}
            ]
          },
          {
            "type": "arithmetic",
            "name": "feelsLikeCTemp",
            "fn": "/",
            "fields": [
              {"type": "fieldAccess", "fieldName": "feelsLikeSum"},
              {"type": "fieldAccess", "fieldName": "feelsLikeCount"}
            ]
          },
          {
            "type": "arithmetic",
            "name": "Avghumidity",
            "fn": "/",
            "fields": [
              {"type": "fieldAccess", "fieldName": "humiditySum"},
              {"type": "fieldAccess", "fieldName": "humidityCount"}
            ]
          }
        ],
        "intervals": [
          "${pickedDate.subtract(new Duration(days: 2)).toString().replaceAll(' ', 'T')}+05:00/${pickedDate1.toString().replaceAll(' ', 'T')}+05:00"
        ]
      };
    } else if (type == 3) {
      data = {
        "queryType": "timeseries",
        "granularity": "week",
        "aggregations": [
          {
            "type": "filtered",
            "filter": {
              "type": "and",
              "fields": [
                {"type": "selector", "dimension": "label", "value": "tempC"},
                {
                  "type": "selector",
                  "dimension": "clientId",
                  "value": "2a5afe76e7d50860"
                }
              ]
            },
            "aggregator": {
              "type": "count",
              "name": "tempCount",
              "fieldName": "value"
            }
          },
          {
            "type": "filtered",
            "filter": {
              "type": "and",
              "fields": [
                {"type": "selector", "dimension": "label", "value": "tempC"},
                {
                  "type": "selector",
                  "dimension": "clientId",
                  "value": "2a5afe76e7d50860"
                }
              ]
            },
            "aggregator": {
              "type": "doubleSum",
              "name": "tempSum",
              "fieldName": "value"
            }
          },
          {
            "type": "filtered",
            "filter": {
              "type": "and",
              "fields": [
                {
                  "type": "selector",
                  "dimension": "label",
                  "value": "feelsLikeC"
                },
                {
                  "type": "selector",
                  "dimension": "clientId",
                  "value": "2a5afe76e7d50860"
                }
              ]
            },
            "aggregator": {
              "type": "count",
              "name": "feelsLikeCount",
              "fieldName": "value"
            }
          },
          {
            "type": "filtered",
            "filter": {
              "type": "and",
              "fields": [
                {
                  "type": "selector",
                  "dimension": "label",
                  "value": "feelsLikeC"
                },
                {
                  "type": "selector",
                  "dimension": "clientId",
                  "value": "2a5afe76e7d50860"
                }
              ]
            },
            "aggregator": {
              "type": "doubleSum",
              "name": "feelsLikeSum",
              "fieldName": "value"
            }
          },
          {
            "type": "filtered",
            "filter": {
              "type": "and",
              "fields": [
                {"type": "selector", "dimension": "label", "value": "humidity"},
                {
                  "type": "selector",
                  "dimension": "clientId",
                  "value": "2a5afe76e7d50860"
                }
              ]
            },
            "aggregator": {
              "type": "count",
              "name": "humidityCount",
              "fieldName": "value"
            }
          },
          {
            "type": "filtered",
            "filter": {
              "type": "and",
              "fields": [
                {"type": "selector", "dimension": "label", "value": "humidity"},
                {
                  "type": "selector",
                  "dimension": "clientId",
                  "value": "2a5afe76e7d50860"
                }
              ]
            },
            "aggregator": {
              "type": "doubleSum",
              "name": "humiditySum",
              "fieldName": "value"
            }
          }
        ],
        "postAggregations": [
          {
            "type": "arithmetic",
            "name": "AvgTemp",
            "fn": "/",
            "fields": [
              {"type": "fieldAccess", "fieldName": "tempSum"},
              {"type": "fieldAccess", "fieldName": "tempCount"}
            ]
          },
          {
            "type": "arithmetic",
            "name": "feelsLikeCTemp",
            "fn": "/",
            "fields": [
              {"type": "fieldAccess", "fieldName": "feelsLikeSum"},
              {"type": "fieldAccess", "fieldName": "feelsLikeCount"}
            ]
          },
          {
            "type": "arithmetic",
            "name": "Avghumidity",
            "fn": "/",
            "fields": [
              {"type": "fieldAccess", "fieldName": "humiditySum"},
              {"type": "fieldAccess", "fieldName": "humidityCount"}
            ]
          }
        ],
        "intervals": [
          "${pickedDate.subtract(new Duration(days: 7)).toString().replaceAll(' ', 'T')}+05:00/${pickedDate1.toString().replaceAll(' ', 'T')}+05:00"
        ]
      };
    } else if (type == 4) {
      data = {
        "queryType": "timeseries",
        "granularity": "month",
        "aggregations": [
          {
            "type": "filtered",
            "filter": {
              "type": "and",
              "fields": [
                {"type": "selector", "dimension": "label", "value": "tempC"},
                {
                  "type": "selector",
                  "dimension": "clientId",
                  "value": "2a5afe76e7d50860"
                }
              ]
            },
            "aggregator": {
              "type": "count",
              "name": "tempCount",
              "fieldName": "value"
            }
          },
          {
            "type": "filtered",
            "filter": {
              "type": "and",
              "fields": [
                {"type": "selector", "dimension": "label", "value": "tempC"},
                {
                  "type": "selector",
                  "dimension": "clientId",
                  "value": "2a5afe76e7d50860"
                }
              ]
            },
            "aggregator": {
              "type": "doubleSum",
              "name": "tempSum",
              "fieldName": "value"
            }
          },
          {
            "type": "filtered",
            "filter": {
              "type": "and",
              "fields": [
                {
                  "type": "selector",
                  "dimension": "label",
                  "value": "feelsLikeC"
                },
                {
                  "type": "selector",
                  "dimension": "clientId",
                  "value": "2a5afe76e7d50860"
                }
              ]
            },
            "aggregator": {
              "type": "count",
              "name": "feelsLikeCount",
              "fieldName": "value"
            }
          },
          {
            "type": "filtered",
            "filter": {
              "type": "and",
              "fields": [
                {
                  "type": "selector",
                  "dimension": "label",
                  "value": "feelsLikeC"
                },
                {
                  "type": "selector",
                  "dimension": "clientId",
                  "value": "2a5afe76e7d50860"
                }
              ]
            },
            "aggregator": {
              "type": "doubleSum",
              "name": "feelsLikeSum",
              "fieldName": "value"
            }
          },
          {
            "type": "filtered",
            "filter": {
              "type": "and",
              "fields": [
                {"type": "selector", "dimension": "label", "value": "humidity"},
                {
                  "type": "selector",
                  "dimension": "clientId",
                  "value": "2a5afe76e7d50860"
                }
              ]
            },
            "aggregator": {
              "type": "count",
              "name": "humidityCount",
              "fieldName": "value"
            }
          },
          {
            "type": "filtered",
            "filter": {
              "type": "and",
              "fields": [
                {"type": "selector", "dimension": "label", "value": "humidity"},
                {
                  "type": "selector",
                  "dimension": "clientId",
                  "value": "2a5afe76e7d50860"
                }
              ]
            },
            "aggregator": {
              "type": "doubleSum",
              "name": "humiditySum",
              "fieldName": "value"
            }
          }
        ],
        "postAggregations": [
          {
            "type": "arithmetic",
            "name": "AvgTemp",
            "fn": "/",
            "fields": [
              {"type": "fieldAccess", "fieldName": "tempSum"},
              {"type": "fieldAccess", "fieldName": "tempCount"}
            ]
          },
          {
            "type": "arithmetic",
            "name": "feelsLikeCTemp",
            "fn": "/",
            "fields": [
              {"type": "fieldAccess", "fieldName": "feelsLikeSum"},
              {"type": "fieldAccess", "fieldName": "feelsLikeCount"}
            ]
          },
          {
            "type": "arithmetic",
            "name": "Avghumidity",
            "fn": "/",
            "fields": [
              {"type": "fieldAccess", "fieldName": "humiditySum"},
              {"type": "fieldAccess", "fieldName": "humidityCount"}
            ]
          }
        ],
        "intervals": [
          " ${pickedDate.subtract(new Duration(days: 30)).toString().replaceAll(' ', 'T')}+05:00/${pickedDate1.toString().replaceAll(' ', 'T')}+05:00"
        ]
      };
    } else {
      return CircularProgressIndicator();
    }
    http.Response response;
    var uri = Uri.parse(
        "https://iot.dev.onstak.io/services/core/api/v2/analytics/query");
    response = await http.post(uri,
        body: jsonEncode(data),
        headers: <String, String>{
          "Content-Type": "application/json",
          "x-auth-token": token
        });
    print("response body ${response.body}");

    if (response.statusCode == 200) {
      print("status code${response.statusCode}");
      final mydashClassConvert = dashboarModelClassFromJson(response.body);
      print("my Dash$mydashClassConvert");

      aqi = mydashClassConvert;
      print("my aqi$aqi");
      print("${aqi.length.toString()}");
      for (int i = 0; i < aqi.length; i++) {
        tempC = aqi[i].result.avgTemp.toString();
        print(tempC);
        feelLikeC = aqi[i].result.feelsLikeCTemp.toString();
        print(feelLikeC);
        humidity = aqi[i].result.avghumidity.toString();
        print(humidity);
        break;
      }
      for (int i = 0; i <= aqi.length - 1; i++) {
        //tempC
        temCValueList.add(
            "${aqi[i].result.avgTemp.toString().split(' ').last.split('.').first}");
        temCTimeList.add(
            "${aqi[i].timestamp.toString().split(" ").first.split("-").last.split("-").last}");
        print("tecsting check$temCTimeList");
        //FeelLikeC
        feelLikeValueList.add(
            "${aqi[i].result.feelsLikeCTemp.toString().split(' ').last.split('.').first}");
        print(feelLikeValueList);
        feelLikeTimeList.add(
            "${aqi[i].timestamp.toString().split(" ").first.split("-").last}");
        //humidity
        humidityValueList.add(
            "${aqi[i].result.avghumidity.toString().split(' ').last.split('.').first}");
        print(feelLikeValueList);
        humidityTimeList.add(
            "${aqi[i].timestamp.toString().split(" ").first.split("-").last}");
      }
      Obx(() {
        temCValueList;
        temCTimeList;
        feelLikeValueList;
        feelLikeTimeList;
        humidityTimeList;
        humidityValueList;
      });
    } else {
      throw Exception('failed to load data');
    }
  }

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              new GestureDetector(
                onTap: () => Navigator.of(context).pop(false),
                child: Container(
                  color: Color.fromRGBO(20, 28, 43, 1),
                  child: FlatButton(
                    child: Text("No", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ),
              new GestureDetector(
                onTap: () => Navigator.of(context).pop(true),
                child: Container(
                  color: Color.fromRGBO(20, 28, 43, 1),
                  child: FlatButton(
                    child: Text(
                      "yes",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  final GlobalKey<ScaffoldState> globalkey = GlobalKey();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData(2);
    //socketConnect();
  }

  void openDrawer;
  var option;
  @override
  bool spinner = false;
  int dropDownValue = 0;
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            backgroundColor: AppConsts.secondaryColor,
            key: globalkey,
            appBar: AppBar(
              backgroundColor: AppConsts.primaryColor,
              elevation: 0,
              centerTitle: true,
              title: Column(
                children: [
                  AutoSizeText(
                    'Usapparel',
                    style: TextStyle(
                        fontSize: 24, color: AppConsts.primaryTextColor),
                  ),
                ],
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AutoSizeText(
                              'Welcome to Dashboard',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: AppConsts.primaryTextColor),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(12),
                        child: Container(
                          height: deviceHeight(context) * 0.2,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: AppConsts.primaryColor,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: AutoSizeText(
                                      'Current Weather Stats',
                                      style: TextStyle(
                                          fontSize: 17,
                                          color: AppConsts.primaryTextColor),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  //temp c
                                  Column(children: [
                                    tempC != null
                                        ? AutoSizeText(
                                            "${tempC.split(".").first} $celcius",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    AppConsts.primaryTextColor,
                                                fontFamily: AppConsts.appFont))
                                        : AutoSizeText(
                                            "30 $celcius",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    AppConsts.primaryTextColor,
                                                fontFamily: AppConsts.appFont),
                                          ),
                                    SizedBox(
                                      height: 2.0,
                                    ),
                                    AutoSizeText("temperature$celcius",
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 15,
                                            color: AppConsts.primaryTextColor,
                                            fontFamily: AppConsts.appFont))
                                  ]),
                                  //feelLike C
                                  Column(children: [
                                    feelLikeC != null
                                        ? AutoSizeText(
                                            "${feelLikeC.toString().split(".").first} $celcius",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    AppConsts.primaryTextColor,
                                                fontFamily: AppConsts.appFont))
                                        : AutoSizeText(
                                            "29 $celcius",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    AppConsts.primaryTextColor,
                                                fontFamily: AppConsts.appFont),
                                          ),
                                    SizedBox(
                                      height: 2.0,
                                    ),
                                    AutoSizeText("FeelsLike$celcius",
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 15,
                                            color: AppConsts.primaryTextColor,
                                            fontFamily: AppConsts.appFont))
                                  ]),
                                  //humidity ...relative like
                                  Column(children: [
                                    humidity != null
                                        ? AutoSizeText(
                                            "${humidity.toString().split(".").first} %",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    AppConsts.primaryTextColor,
                                                fontFamily: AppConsts.appFont))
                                        : AutoSizeText(
                                            "40 %",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    AppConsts.primaryTextColor,
                                                fontFamily: AppConsts.appFont),
                                          ),
                                    SizedBox(
                                      height: 2.0,
                                    ),
                                    AutoSizeText("Relative like",
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 15,
                                            color: AppConsts.primaryTextColor,
                                            fontFamily: AppConsts.appFont))
                                  ])
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      DefaultTabController(
                          length: 3,
                          child: Column(
                            children: [
                              TabBar(
                                isScrollable: true,
                                indicatorColor: AppConsts.primaryTextColor,
                                labelColor: AppConsts.primaryTextColor,
                                //  unselectedLabelColor:
                                // // AppConsts.primaryTextColor.withOpacity(0.4),
                                onTap: (index) {},
                                tabs: [
                                  Tab(text: 'Temperature$celcius'),
                                  Tab(text: 'FeelsLike$celcius'),
                                  Tab(text: 'Humidity'),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Container(
                                  height: deviceHeight(context) * 0.5,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: AppConsts.primaryColor),
                                  child: TabBarView(children: [
                                    //tempC
                                    Container(
                                      height: deviceHeight(context) * 0.5,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10,
                                                        horizontal: 20.0),
                                                child: AutoSizeText(
                                                  'Temperature$celcius',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: AppConsts
                                                          .primaryTextColor),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 20.0),
                                                child: Container(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.06,
                                                  child: DropdownButton(
                                                    dropdownColor:
                                                        AppConsts.primaryColor,
                                                    hint: Text(
                                                      "Weeklyyyy",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    value: dropDownValue,
                                                    onChanged: (int newVal) {
                                                      setState(() {
                                                        dropDownValue = newVal;
                                                        print(
                                                            '-------------------------');
                                                        print(dropDownValue);
                                                      });
                                                    },
                                                    items: [
                                                      DropdownMenuItem(
                                                          value: 0,
                                                          child: Text('Hourly',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white)),
                                                          onTap: () async {
                                                            print(
                                                                'Hourly pressed');
                                                            await fetchData(1);
                                                            spinner = false;
                                                          }),
                                                      DropdownMenuItem(
                                                          value: 1,
                                                          child: Text('Daily',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white)),
                                                          onTap: () {
                                                            temCValueList
                                                                .clear();
                                                            temCTimeList
                                                                .clear();
                                                            fetchData(2);
                                                          }),
                                                      DropdownMenuItem(
                                                          value: 2,
                                                          child: Text('Weekly',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white)),
                                                          onTap: () {
                                                            temCValueList
                                                                .clear();
                                                            temCTimeList
                                                                .clear();
                                                            fetchData(3);
                                                          }),
                                                      DropdownMenuItem(
                                                          value: 3,
                                                          child: Text(
                                                            'Monthly',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                          onTap: () {
                                                            temCValueList
                                                                .clear();
                                                            temCTimeList
                                                                .clear();
                                                            fetchData(4);
                                                          }),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              child: Obx(
                                                () => Echarts(
                                                  extensions: [darkThemeScript],
                                                  theme: 'dark',
                                                  option: '''
   {


        tooltip: {
                  trigger: 'axis'
        },
        legend: {
                  data: ['Temp$celcius']
        },
        grid: {
                  left: '3%',
                  right: '4%',
                  bottom: '3%',
                  containLabel: true
        },
        toolbox: {
                  feature: {
                      saveAsImage: {}
                  }
        },
        
        xAxis: {
                  type: 'category',
                  data:  $temCTimeList
                  },
                  
        yAxis: {
                  type: 'value'
        },
        series: [
                  {
                      name: 'Temp$celcius',
                      type: 'bar',
                      step: 'start',
                        data: $temCValueList
                  },
            

        ]
}
  ''',
                                                ),
                                              ),
                                              height:
                                                  deviceHeight(context) * 0.4,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: deviceHeight(context) * 0.5,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                child: AutoSizeText(
                                                  'Temperature$celcius',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      color: AppConsts
                                                          .primaryTextColor),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 20.0),
                                                child: Container(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.06,
                                                  child: DropdownButton(
                                                    dropdownColor:
                                                        AppConsts.primaryColor,
                                                    hint: Text(
                                                      "Hourlyyyyy",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    value: dropDownValue,
                                                    onChanged: (int newVal) {
                                                      setState(() {
                                                        dropDownValue = newVal;
                                                        print(
                                                            '1111111111111111111111111');
                                                        print(dropDownValue);
                                                      });
                                                    },
                                                    items: [
                                                      DropdownMenuItem(
                                                          value: 0,
                                                          child: Text('Hourly',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white)),
                                                          onTap: () async {
                                                            await fetchData(1);
                                                            spinner = false;
                                                          }),
                                                      DropdownMenuItem(
                                                          value: 1,
                                                          child: Text('Daily',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white)),
                                                          onTap: () {
                                                            feelLikeValueList
                                                                .clear();
                                                            feelLikeTimeList
                                                                .clear();
                                                            fetchData(2);
                                                          }),
                                                      DropdownMenuItem(
                                                          value: 2,
                                                          child: Text('Weekly',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white)),
                                                          onTap: () {
                                                            feelLikeValueList
                                                                .clear();
                                                            feelLikeTimeList
                                                                .clear();
                                                            fetchData(3);
                                                          }),
                                                      DropdownMenuItem(
                                                          value: 3,
                                                          child: Text(
                                                            'Monthly',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                          onTap: () {
                                                            feelLikeValueList
                                                                .clear();
                                                            feelLikeTimeList
                                                                .clear();
                                                            fetchData(4);
                                                          }),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              child: Obx(
                                                () => Echarts(
                                                  extensions: [darkThemeScript],
                                                  theme: 'dark',
                                                  option: '''
   {


        tooltip: {
                  trigger: 'axis'
        },
        legend: {
                  data: ['FeelsLike$celcius']
        },
        grid: {
                  left: '3%',
                  right: '4%',
                  bottom: '3%',
                  containLabel: true
        },
        toolbox: {
                  feature: {
                      saveAsImage: {}
                  }
        },
        
        xAxis: {
                  type: 'category',
                  data:  $feelLikeTimeList
                  },
                  
        yAxis: {
                  type: 'value'
        },
        series: [
                  {
                      name: 'FeelsLike$celcius',
                      type: 'bar',
                      step: 'start',
                        data: $feelLikeValueList
                  },
            

        ]
}
  ''',
                                                ),
                                              ),
                                              height:
                                                  deviceHeight(context) * 0.4,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: deviceHeight(context) * 0.5,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                child: AutoSizeText(
                                                  'Humidity',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      color: AppConsts
                                                          .primaryTextColor),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 20.0),
                                                child: Container(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.06,
                                                  child: DropdownButton(
                                                    dropdownColor:
                                                        AppConsts.primaryColor,
                                                    hint: Text(
                                                      "Dailyyyy",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    value: dropDownValue,
                                                    onChanged: (int newVal) {
                                                      setState(() {
                                                        dropDownValue = newVal;
                                                        print(
                                                            '22222222222222222222222222');
                                                        print(dropDownValue);
                                                      });
                                                    },
                                                    items: [
                                                      DropdownMenuItem(
                                                          value: 0,
                                                          child: Text('Hourly',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white)),
                                                          onTap: () async {
                                                            await fetchData(1);
                                                            spinner = false;
                                                          }),
                                                      DropdownMenuItem(
                                                          value: 1,
                                                          child: Text('Daily',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white)),
                                                          onTap: () {
                                                            humidityValueList
                                                                .clear();
                                                            humidityTimeList
                                                                .clear();
                                                            fetchData(2);
                                                          }),
                                                      DropdownMenuItem(
                                                          value: 2,
                                                          child: Text('Weekly',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white)),
                                                          onTap: () {
                                                            humidityValueList
                                                                .clear();
                                                            humidityTimeList
                                                                .clear();
                                                            fetchData(3);
                                                          }),
                                                      DropdownMenuItem(
                                                          value: 3,
                                                          child: Text(
                                                            'Monthly',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                          onTap: () {
                                                            humidityValueList
                                                                .clear();
                                                            humidityTimeList
                                                                .clear();
                                                            fetchData(4);
                                                          }),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              child: Obx(
                                                () => Echarts(
                                                  extensions: [darkThemeScript],
                                                  theme: 'dark',
                                                  option: '''
   {


        tooltip: {
                  trigger: 'axis'
        },
        legend: {
                  data: ['Humidity']
        },
        grid: {
                  left: '3%',
                  right: '4%',
                  bottom: '3%',
                  containLabel: true
        },
        toolbox: {
                  feature: {
                      saveAsImage: {}
                  }
        },
        
        xAxis: {
                  type: 'category',
                  data:  $humidityTimeList
                  },
                  
        yAxis: {
                  type: 'value'
        },
        series: [
                  {
                      name: 'Humidity',
                      type: 'bar',
                      step: 'start',
                        data: $humidityValueList
                  },
            

        ]
}
  ''',
                                                ),
                                              ),
                                              height:
                                                  deviceHeight(context) * 0.4,
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ]),
                                ),
                              )
                            ],
                          ))
                    ],
                  )
                ],
              ),
            )),
      ),
    );
  }
}
