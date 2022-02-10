import 'package:meta/meta.dart';
import 'dart:convert';

List<Report> reportFromJson(String str) => List<Report>.from(json.decode(str).map((x) => Report.fromJson(x)));

String reportToJson(List<Report> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Report {
  Report({
    required this.confirmed,
    required this.recovered,
    required this.critical,
    required this.deaths,
    required this.lastChange,
    required this.lastUpdate,
  });

  int confirmed;
  int recovered;
  int critical;
  int deaths;
  DateTime lastChange;
  DateTime lastUpdate;

  factory Report.fromJson(Map<String, dynamic> json) => Report(
    confirmed: json["confirmed"],
    recovered: json["recovered"],
    critical: json["critical"],
    deaths: json["deaths"],
    lastChange: DateTime.parse(json["lastChange"]),
    lastUpdate: DateTime.parse(json["lastUpdate"]),
  );

  Map<String, dynamic> toJson() => {
    "confirmed": confirmed,
    "recovered": recovered,
    "critical": critical,
    "deaths": deaths,
    "lastChange": lastChange.toIso8601String(),
    "lastUpdate": lastUpdate.toIso8601String(),
  };
}
