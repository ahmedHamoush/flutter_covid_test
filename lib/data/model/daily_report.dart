// To parse this JSON data, do
//
//     final dailyReport = dailyReportFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<DailyReport> dailyReportFromJson(String str) => List<DailyReport>.from(json.decode(str).map((x) => DailyReport.fromJson(x)));

String dailyReportToJson(List<DailyReport> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DailyReport {
  DailyReport({
    required this.confirmed,
    required this.recovered,
    required this.deaths,
    required this.active,
    required this.critical,
    required this.date,
  });

  int confirmed;
  int recovered;
  int deaths;
  int active;
  int critical;
  DateTime date;

  factory DailyReport.fromJson(Map<String, dynamic> json) => DailyReport(
    confirmed: json["confirmed"],
    recovered: json["recovered"],
    deaths: json["deaths"],
    active: json["active"],
    critical: json["critical"],
    date: DateTime.parse(json["date"]),
  );

  Map<String, dynamic> toJson() => {
    "confirmed": confirmed,
    "recovered": recovered,
    "deaths": deaths,
    "active": active,
    "critical": critical,
    "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
  };
}
