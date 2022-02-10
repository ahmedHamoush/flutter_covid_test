part of 'covid_bloc.dart';


class CovidState {
  const CovidState();

  @override
  List<Object> get props => [];
}


class CovidInitial extends CovidState {}


class FetshTotalRepoortState extends CovidState{
  final Report? report;
  const FetshTotalRepoortState({this.report});
}
class FetshCountriesListState extends CovidState{
  final List<String?>? countries;
  const FetshCountriesListState({this.countries});
}
class FetshCountryReportState extends CovidState{
  final CountryReport? countryReport;
  const FetshCountryReportState({this.countryReport});
}


class FetshDailyReportTotalState extends CovidState{
  final DailyReport? dailyReport;
  const FetshDailyReportTotalState({this.dailyReport});
}
class FetshLoadingState extends CovidState{}
class FetshErrorState extends CovidState{}

