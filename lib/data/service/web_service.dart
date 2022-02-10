
import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_covid/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WebServices {
  late Dio dio;

  WebServices() {
    BaseOptions options = BaseOptions(
      baseUrl: BASEURL,
      receiveDataWhenStatusError: true,
      connectTimeout: 20 * 1000, // 60 seconds,
      receiveTimeout: 20 * 1000,
      contentType: Headers.formUrlEncodedContentType
    );

    dio = Dio(options);
  }


  Future<dynamic> getLatestTotalsFromServer(DateTime dateTime) async {
    try {
      dio.options.headers["x-rapidapi-host"] = XRAPIDAPIHOST;
      dio.options.headers["x-rapidapi-key"] = XRAPIDAPIKEY;

      var response = await dio.get("report/totals?date=${dateTime}",
          options: Options(contentType: Headers.formUrlEncodedContentType));

      return response.data;
    } on DioError catch(e){
    }
  }

}