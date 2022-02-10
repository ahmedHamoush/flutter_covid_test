// To parse this JSON data, do
//
//     final countryReport = countryReportFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<CountryReport> countryReportFromJson(String str) => List<CountryReport>.from(json.decode(str).map((x) => CountryReport.fromJson(x)));

String countryReportToJson(List<CountryReport> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CountryReport {
  CountryReport({
    required this.country,
    required this.code,
    required this.confirmed,
    required this.recovered,
    required this.critical,
    required this.deaths,
    required this.latitude,
    required this.longitude,
    required this.lastChange,
    required this.lastUpdate,
  });

  String country;
  String code;
  int confirmed;
  int recovered;
  int critical;
  int deaths;
  double latitude;
  double longitude;
  DateTime lastChange;
  DateTime lastUpdate;

  factory CountryReport.fromJson(Map<String, dynamic> json) => CountryReport(
    country: json["country"],
    code: json["code"],
    confirmed: json["confirmed"],
    recovered: json["recovered"],
    critical: json["critical"],
    deaths: json["deaths"],
    latitude: json["latitude"].toDouble(),
    longitude: json["longitude"].toDouble(),
    lastChange: DateTime.parse(json["lastChange"]),
    lastUpdate: DateTime.parse(json["lastUpdate"]),
  );

  Map<String, dynamic> toJson() => {
    "country": country,
    "code": code,
    "confirmed": confirmed,
    "recovered": recovered,
    "critical": critical,
    "deaths": deaths,
    "latitude": latitude,
    "longitude": longitude,
    "lastChange": lastChange.toIso8601String(),
    "lastUpdate": lastUpdate.toIso8601String(),
  };
}
