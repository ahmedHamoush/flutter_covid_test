import 'dart:convert';
import 'dart:developer';

import 'package:flutter_covid/data/model/country.dart';
import 'package:flutter_covid/data/model/country_report.dart';
import 'package:flutter_covid/data/model/daily_report.dart';
import 'package:flutter_covid/data/model/report.dart';
import 'package:flutter_covid/data/service/web_service.dart';
import 'package:flutter_covid/utils/constants.dart';
import 'package:dio/dio.dart';

class Repository {
  late Dio dio;

  Repository() {
    BaseOptions options = BaseOptions(
        baseUrl: BASEURL,
        receiveDataWhenStatusError: true,
        connectTimeout: 20 * 1000, // 60 seconds,
        receiveTimeout: 20 * 1000,
        contentType: Headers.formUrlEncodedContentType
    );
    dio = Dio(options);
    dio.options.headers["x-rapidapi-host"] = XRAPIDAPIHOST;
    dio.options.headers["x-rapidapi-key"] = XRAPIDAPIKEY;

  }

  Future<dynamic> getLatestTotals() async{
    try {
      dio.options.headers["x-rapidapi-host"] = XRAPIDAPIHOST;
      dio.options.headers["x-rapidapi-key"] = XRAPIDAPIKEY;

      var response = await dio.get("totals",
          options: Options(contentType: Headers.formUrlEncodedContentType));

      Report report = Report.fromJson(response.data[0]);
      return report;

    } on DioError catch(e){
    }
  }

  Future<dynamic> getCountriesListTotals() async{
    try {
      dio.options.headers["x-rapidapi-host"] = XRAPIDAPIHOST;
      dio.options.headers["x-rapidapi-key"] = XRAPIDAPIKEY;
      var response = await dio.get("help/countries",
          options: Options(contentType: Headers.formUrlEncodedContentType));

      var list = response.data as List;
      List<String?> itemsList = list.map((i) => Country.fromJson(i).name).toList();

      return itemsList;
    } on DioError catch(e){
    }
  }
  Future<dynamic> getCountryReportTotals(String name) async{
    try {
      dio.options.headers["x-rapidapi-host"] = XRAPIDAPIHOST;
      dio.options.headers["x-rapidapi-key"] = XRAPIDAPIKEY;
      var response = await dio.get("country?name=$name",
          options: Options(contentType: Headers.formUrlEncodedContentType));

      CountryReport report = CountryReport.fromJson(response.data[0]);
      return report;
    } on DioError catch(e){
    }
  }

}