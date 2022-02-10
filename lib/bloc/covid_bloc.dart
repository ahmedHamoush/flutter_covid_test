import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter_covid/data/model/country.dart';
import 'package:flutter_covid/data/model/country_report.dart';
import 'package:flutter_covid/data/model/daily_report.dart';
import 'package:flutter_covid/data/model/report.dart';
import 'package:flutter_covid/data/repository/repository.dart';
import 'package:meta/meta.dart';
import 'package:intl/intl.dart';

part 'covid_event.dart';
part 'covid_state.dart';


class CovidBloc extends Bloc<CovidEvent, CovidState> {

  Repository repository;
  CovidBloc({CovidState? initialState, required this.repository})
      : super(initialState!) {
  }

  @override
  Stream<CovidState> mapEventToState(CovidEvent event) async* {
    if(event is FetshTotalReportEvent) {
      try{
        yield FetshLoadingState();
        Report report;
        report = await repository.getLatestTotals();

        if(report != null){
          yield FetshTotalRepoortState(report: report);
        }else{
          yield FetshErrorState();
        }
      }catch(e){
      }
    }
    else if(event is FetshCountriesListEvent){
      try{
        List<String?> countriesList = await repository.getCountriesListTotals();
        yield FetshLoadingState();
        if(countriesList.isNotEmpty){
          yield FetshCountriesListState(countries: countriesList);
        }else{
          yield FetshErrorState();
        }
      }catch(e){
      }
    }
    else if(event is FetshCountryReportEvent){
      try{
        CountryReport countryReport = await repository.getCountryReportTotals(event.name);
        yield FetshLoadingState();
        if(countryReport != null){
          yield FetshCountryReportState(countryReport: countryReport);
        }else{
          yield FetshErrorState();
        }
      }catch(e){
      }
    }
  }

  
}
