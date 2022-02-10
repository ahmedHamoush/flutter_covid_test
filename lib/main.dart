import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_covid/bloc/covid_bloc.dart';
import 'package:flutter_covid/coutry_report_page.dart';
import 'package:flutter_covid/data/model/daily_report.dart';
import 'package:flutter_covid/utils/colors.dart';
import 'data/model/report.dart';
import 'data/repository/repository.dart';
import 'utils/custom_text.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_offline/flutter_offline.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  late Repository repository;
  late CovidBloc covidBloc;

  MyApp(){
    repository = Repository();
    covidBloc = CovidBloc(initialState: CovidInitial(), repository: repository);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        lazy: false,
        create: (BuildContext context) => covidBloc
        ..add(FetshTotalReportEvent()),
        child:MaterialApp(
          debugShowCheckedModeBanner:false,
          initialRoute: '/',
          home: MainPage(),
        )
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  @override
  void initState() {
    super.initState();
    /*
    context.read<CovidBloc>().add(
        FetshCountriesListEvent());
    */
  }
  bool a = false;
  bool b = false;

  Report report = Report(confirmed: 0, recovered: 0, deaths: 0, critical: 0, lastChange: DateTime.now(), lastUpdate: DateTime.now());
  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        body: OfflineBuilder(
          connectivityBuilder: (
              BuildContext context,
              ConnectivityResult connectivity,
              Widget child,
              ) {
            final bool connected = connectivity != ConnectivityResult.none;
            return connected ? BlocBuilder<CovidBloc, CovidState>(
                builder: (BuildContext context, CovidState state) {
                  if(state is FetshLoadingState){
                    return Scaffold(body: Center(child: Lottie.asset("assets/loading_lottie.json"),),);
                  }
                  else if(state is FetshErrorState){
                    return Scaffold(body: Column(
                      children: [
                        Center(child: Lottie.asset("assets/error_lottie.json"),),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(primary: CustomColors.mainColor),
                          onPressed: (){
                            context.read<CovidBloc>().add(
                                FetshDailyReportTotalEvent());
                          }, child: Text("Try again"),
                        )
                      ],
                    ),);
                  }
                  else if(state is FetshTotalRepoortState){
                    report = state.report!;
                    return Scaffold(
                      body: ListView(
                        padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const CustomText(text: "Hi,", textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 24)),
                            ],
                          ),
                          const SizedBox(height: 8,),
                          Row(mainAxisAlignment: MainAxisAlignment.start,
                            children: const[CustomText
                              (text: "Are you okay today?",
                                textStyle: TextStyle(color: Colors.blueGrey,
                                    fontWeight: FontWeight.normal,fontSize: 18))],),
                          const SizedBox(height: 16,),
                          Container(
                            padding: const EdgeInsets.all(20),
                            color: CustomColors.mainColor.withAlpha(40),
                            child: Column(
                              children: [
                                const SizedBox(height: 12,),
                                const Center(
                                    child:CustomText(text: "Covid-19 data",
                                      textStyle: TextStyle(color: CustomColors.mainColor, fontWeight: FontWeight.w900, fontSize: 18),)),
                                const SizedBox(height: 12,),
                                const Center(
                                    child:CustomText(text: "Latest total",
                                      textStyle: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.w500, fontSize: 16),)),
                                const SizedBox(height: 12,),
                                IntrinsicHeight(
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: Column(
                                            children: [
                                              CustomText(text: report.confirmed.toString(),
                                                textStyle: const TextStyle(color: CustomColors.mainColor, fontWeight: FontWeight.w300, fontSize: 16),),
                                              const CustomText(text: "confirmed",
                                                textStyle: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.w300, fontSize: 16),),
                                            ],
                                          )),
                                      VerticalDivider(
                                        thickness: 1,color: CustomColors.mainColor.withAlpha(200 ),
                                      ),
                                      Expanded(
                                          child: Column(
                                            children:  [
                                              CustomText(text: report.recovered.toString(),
                                                textStyle: const TextStyle(color: CustomColors.mainColor, fontWeight: FontWeight.w300, fontSize: 16),),
                                              const CustomText(text: "recovered",
                                                textStyle: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.w300, fontSize: 16),),
                                            ],
                                          )),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 12,),
                                IntrinsicHeight(
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: Column(
                                            children: [
                                              CustomText(text: report.deaths.toString(),
                                                textStyle: const TextStyle(color: CustomColors.mainColor, fontWeight: FontWeight.w300, fontSize: 16),),
                                              const CustomText(text: "active",
                                                textStyle: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.w300, fontSize: 16),),
                                            ],
                                          )),
                                      VerticalDivider(
                                        thickness: 1,color: CustomColors.mainColor.withAlpha(200 ),
                                      ),
                                      Expanded(
                                          child: Column(
                                            children: [
                                              CustomText(text: report.critical.toString(),
                                                textStyle: const TextStyle(color: CustomColors.mainColor, fontWeight: FontWeight.w300, fontSize: 16),),
                                              const CustomText(text: "critical",
                                                textStyle: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.w300, fontSize: 16),),
                                            ],
                                          )),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16,),
                          Row(mainAxisAlignment: MainAxisAlignment.start,
                            children: const[CustomText
                              (text: "Show a country's state",
                                textStyle: TextStyle(color: Colors.blueGrey,
                                    fontWeight: FontWeight.normal,fontSize: 18))],),
                          const SizedBox(height: 8,),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(primary: CustomColors.mainColor),
                            onPressed: (){
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => CountryPage()),
                              );
                            }, child: Text("Press here"),
                          )
                        ],
                      ),
                    );
                  }
                  else{
                    return Scaffold(body: Center(child: Lottie.asset("assets/error_lottie.json"),),);
                  }
                }) : Center(child: Lottie.asset("assets/no_internet_lottie.json"),);
          },
          child: Container(),
        ),
      ),
    );
  }
}
