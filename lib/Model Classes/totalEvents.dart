// To parse this JSON data, do
//
//     final dashboarModelClass = dashboarModelClassFromJson(jsonString);

import 'dart:convert';

List<DashboarModelClass> dashboarModelClassFromJson(String str) => List<DashboarModelClass>.from(json.decode(str).map((x) => DashboarModelClass.fromJson(x)));

String dashboarModelClassToJson(List<DashboarModelClass> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DashboarModelClass {
  DashboarModelClass({
    this.timestamp,
    this.result,
  });

  DateTime timestamp;
  Result result;

  factory DashboarModelClass.fromJson(Map<String, dynamic> json) => DashboarModelClass(
    timestamp: json["timestamp"] == null ? null : DateTime.parse(json["timestamp"]),
    result: json["result"] == null ? null : Result.fromJson(json["result"]),
  );

  Map<String, dynamic> toJson() => {
    "timestamp": timestamp == null ? null : timestamp.toIso8601String(),
    "result": result == null ? null : result.toJson(),
  };
}

class Result {
  Result({
    this.avgTemp,
    this.feelsLikeCTemp,
    this.humiditySum,
    this.tempSum,
    this.tempCount,
    this.avghumidity,
    this.feelsLikeSum,
    this.feelsLikeCount,
    this.humidityCount,
  });

  double avgTemp;
  double feelsLikeCTemp;
  double humiditySum;
  double tempSum;
  int tempCount;
  double avghumidity;
  double feelsLikeSum;
  int feelsLikeCount;
  int humidityCount;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    avgTemp: json["AvgTemp"] == null ? null : json["AvgTemp"].toDouble(),
    feelsLikeCTemp: json["feelsLikeCTemp"] == null ? null : json["feelsLikeCTemp"].toDouble(),
    humiditySum: json["humiditySum"] == null ? null : json["humiditySum"].toDouble(),
    tempSum: json["tempSum"] == null ? null : json["tempSum"].toDouble(),
    tempCount: json["tempCount"] == null ? null : json["tempCount"],
    avghumidity: json["Avghumidity"] == null ? null : json["Avghumidity"].toDouble(),
    feelsLikeSum: json["feelsLikeSum"] == null ? null : json["feelsLikeSum"].toDouble(),
    feelsLikeCount: json["feelsLikeCount"] == null ? null : json["feelsLikeCount"],
    humidityCount: json["humidityCount"] == null ? null : json["humidityCount"],
  );

  Map<String, dynamic> toJson() => {
    "AvgTemp": avgTemp == null ? null : avgTemp,
    "feelsLikeCTemp": feelsLikeCTemp == null ? null : feelsLikeCTemp,
    "humiditySum": humiditySum == null ? null : humiditySum,
    "tempSum": tempSum == null ? null : tempSum,
    "tempCount": tempCount == null ? null : tempCount,
    "Avghumidity": avghumidity == null ? null : avghumidity,
    "feelsLikeSum": feelsLikeSum == null ? null : feelsLikeSum,
    "feelsLikeCount": feelsLikeCount == null ? null : feelsLikeCount,
    "humidityCount": humidityCount == null ? null : humidityCount,
  };
}
