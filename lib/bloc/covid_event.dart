part of 'covid_bloc.dart';


class CovidEvent  {
  const CovidEvent();

  @override
  List<Object> get props => [];
}

class FetshTotalReportEvent extends CovidEvent{
  FetshTotalReportEvent();
}
class FetshCountriesListEvent extends CovidEvent{
  FetshCountriesListEvent();
}
class FetshCountryReportEvent extends CovidEvent{
  String name;
  FetshCountryReportEvent({required this.name});
}

class FetshDailyReportTotalEvent extends CovidEvent{
  FetshDailyReportTotalEvent();
}
