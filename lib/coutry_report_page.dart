import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_covid/bloc/covid_bloc.dart';
import 'package:flutter_covid/data/model/country_report.dart';
import 'package:flutter_covid/main.dart';
import 'package:flutter_covid/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'utils/custom_text.dart';

class CountryPage extends StatefulWidget {
  const CountryPage({Key? key}) : super(key: key);

  @override
  _CountryPageState createState() => _CountryPageState();
}

class _CountryPageState extends State<CountryPage> {
  TextEditingController editingController = TextEditingController();

  var duplicateItems = List<String?>.generate(10, (i) => "test");
  var items = <String?>[];

  static ValueNotifier<bool> isCountriesListVisible = ValueNotifier(true);
  
  @override
  void initState() {
    context.read<CovidBloc>().add(
        FetshCountriesListEvent());
    super.initState();
  }
  void filterSearchResults(String query) {
    List<String?> dummySearchList = <String?>[];
    dummySearchList.addAll(duplicateItems);
    if(query.isNotEmpty) {
      List<String> dummyListData = <String>[];
      dummySearchList.forEach((item) {
        if(item!.contains(query[0].toUpperCase()+query.substring(1, query.length))) {
          dummyListData.add(item);
        }
      });
      setState(() {
        items.clear();
        items.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        items.clear();
        items.addAll(duplicateItems);
      });
    }

  }
  
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MyApp()),
        );
        return true;
        },
      child: OfflineBuilder(
      connectivityBuilder: (
      BuildContext context,
      ConnectivityResult connectivity,
      Widget child,
    ) {
        final bool connected = connectivity != ConnectivityResult.none;
        return connected ? BlocBuilder<CovidBloc, CovidState>(
            builder: (BuildContext context, CovidState state) {

              if (state is FetshCountriesListState) {
                duplicateItems = state.countries!;
                items.addAll(state.countries!);
                return SafeArea(child: Scaffold(
                  body: Container(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            onChanged: (value) {
                              if (isCountriesListVisible.value == false) {
                                isCountriesListVisible.value = true;
                              }
                              filterSearchResults(value);
                            },
                            controller: editingController,
                            decoration: const InputDecoration(
                                labelText: "Search",
                                hintText: "Search",
                                prefixIcon: Icon(Icons.search),
                                border: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(25.0))),
                              focusColor: CustomColors.mainColor,
                              hoverColor: CustomColors.mainColor
                            ),
                          ),
                        ),
                        Expanded(child: ValueListenableBuilder(
                            valueListenable: isCountriesListVisible,
                            builder: (context, newValue, child) {
                              var a = false;
                              if (newValue.toString() == "false") {
                                a = false;
                              } else {
                                a = true;
                              }

                              return Visibility(
                                visible: a,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: items.length,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () {
                                        editingController.text =
                                            items[index].toString();
                                        isCountriesListVisible.value =
                                        !isCountriesListVisible.value;

                                        context.read<CovidBloc>().add(
                                            FetshCountryReportEvent(
                                                name: items[index].toString()));
                                      },
                                      child: ListTile(
                                        title: Text('${items[index]}'),
                                      ),
                                    );
                                  },
                                ),
                              );
                            }),),
                      ],
                    ),
                  ),
                ));
              }
              else if (state is FetshCountryReportState) {
                CountryReport countryReport = state.countryReport!;

                if(countryReport!=null){
                  return SafeArea(child: Scaffold(
                    body: Container(
                      padding: EdgeInsets.all(12),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              onChanged: (value) {
                                if (isCountriesListVisible.value == false) {
                                  isCountriesListVisible.value = true;
                                  context.read<CovidBloc>().add(
                                      FetshCountriesListEvent());
                                }
                                filterSearchResults(value);
                              },
                              controller: editingController,
                              decoration: const InputDecoration(
                                  labelText: "Search",
                                  hintText: "Search",
                                  prefixIcon: Icon(Icons.search),
                                  border: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(25.0))),
                                  focusColor: CustomColors.mainColor,
                                  hoverColor: CustomColors.mainColor
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(20),
                            color: CustomColors.mainColor.withAlpha(40),
                            child: Column(
                              children: [
                                const SizedBox(height: 12,),
                                const Center(
                                    child: CustomText(text: "Covid-19 data",
                                      textStyle: TextStyle(
                                          color: CustomColors.mainColor,
                                          fontWeight: FontWeight.w900,
                                          fontSize: 18),)),
                                const SizedBox(height: 12,),
                                const Center(
                                    child: CustomText(text: "Latest total",
                                      textStyle: TextStyle(color: Colors.blueGrey,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16),)),
                                const SizedBox(height: 12,),
                                IntrinsicHeight(
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: Column(
                                            children: [
                                              CustomText(
                                                text: countryReport.confirmed
                                                    .toString(),
                                                textStyle: const TextStyle(
                                                    color: CustomColors.mainColor,
                                                    fontWeight: FontWeight.w300,
                                                    fontSize: 16),),
                                              const CustomText(text: "confirmed",
                                                textStyle: TextStyle(
                                                    color: Colors.blueGrey,
                                                    fontWeight: FontWeight.w300,
                                                    fontSize: 16),),
                                            ],
                                          )),
                                      VerticalDivider(
                                        thickness: 1,
                                        color: CustomColors.mainColor.withAlpha(
                                            200),
                                      ),
                                      Expanded(
                                          child: Column(
                                            children: [
                                              CustomText(
                                                text: countryReport.recovered
                                                    .toString(),
                                                textStyle: const TextStyle(
                                                    color: CustomColors.mainColor,
                                                    fontWeight: FontWeight.w300,
                                                    fontSize: 16),),
                                              const CustomText(text: "recovered",
                                                textStyle: TextStyle(
                                                    color: Colors.blueGrey,
                                                    fontWeight: FontWeight.w300,
                                                    fontSize: 16),),
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
                                              CustomText(
                                                text: countryReport.deaths
                                                    .toString(),
                                                textStyle: const TextStyle(
                                                    color: CustomColors.mainColor,
                                                    fontWeight: FontWeight.w300,
                                                    fontSize: 16),),
                                              const CustomText(text: "active",
                                                textStyle: TextStyle(
                                                    color: Colors.blueGrey,
                                                    fontWeight: FontWeight.w300,
                                                    fontSize: 16),),
                                            ],
                                          )),
                                      VerticalDivider(
                                        thickness: 1,
                                        color: CustomColors.mainColor.withAlpha(
                                            200),
                                      ),
                                      Expanded(
                                          child: Column(
                                            children: [
                                              CustomText(
                                                text: countryReport.critical
                                                    .toString(),
                                                textStyle: const TextStyle(
                                                    color: CustomColors.mainColor,
                                                    fontWeight: FontWeight.w300,
                                                    fontSize: 16),),
                                              const CustomText(text: "critical",
                                                textStyle: TextStyle(
                                                    color: Colors.blueGrey,
                                                    fontWeight: FontWeight.w300,
                                                    fontSize: 16),),
                                            ],
                                          )),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                        ],
                      ),
                    ),
                  ));
                }else{
                  return SafeArea(child: Scaffold(
                    body: Container(
                      padding: EdgeInsets.all(12),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              onChanged: (value) {
                                if (isCountriesListVisible.value == false) {
                                  isCountriesListVisible.value = true;
                                  context.read<CovidBloc>().add(
                                      FetshCountriesListEvent());
                                }
                                filterSearchResults(value);
                              },
                              controller: editingController,
                              decoration: const InputDecoration(
                                  labelText: "Search",
                                  hintText: "Search",
                                  prefixIcon: Icon(Icons.search),
                                  border: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(25.0))),
                                  focusColor: CustomColors.mainColor,
                                  hoverColor: CustomColors.mainColor),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(20),
                            color: CustomColors.mainColor.withAlpha(40),
                            child: Column(
                              children: const [
                                SizedBox(height: 12,),
                                Center(
                                    child: CustomText(text: "No data",
                                      textStyle: TextStyle(
                                          color: CustomColors.mainColor,
                                          fontWeight: FontWeight.w900,
                                          fontSize: 18),)),
                                SizedBox(height: 12,),
                              ],
                            ),
                          ),

                        ],
                      ),
                    ),
                  ));
                }

              }
              else if (state is FetshLoadingState) {
                return SafeArea(
                    child: Scaffold(body: Center(child: Lottie.asset(
                        "assets/loading_lottie.json"),),));
              }
              else{
                return SafeArea(child: Scaffold(
                  body: Container(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            onChanged: (value) {
                              if (isCountriesListVisible.value == false) {
                                isCountriesListVisible.value = true;
                                context.read<CovidBloc>().add(
                                    FetshCountriesListEvent());
                              }
                              filterSearchResults(value);
                            },
                            controller: editingController,
                            decoration: const InputDecoration(
                                labelText: "Search",
                                hintText: "Search",
                                prefixIcon: Icon(Icons.search),
                                border: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(25.0),
                                    ),
                                ),
                                focusColor: CustomColors.mainColor,
                                hoverColor: CustomColors.mainColor
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ));

              }
            }
        ) : Center(child: Lottie.asset("assets/no_internet_lottie.json"),);
      },
      child: Container(),
      )
    );
  }
}
