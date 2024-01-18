import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutterweatherapp/const/app_color.dart';
import 'package:flutterweatherapp/const/app_resources.dart';
import 'package:flutterweatherapp/const/app_strings.dart';
import 'package:flutterweatherapp/const/utils.dart';
import 'package:flutterweatherapp/const/weather_app_fonts.dart';
import 'package:flutterweatherapp/const/weather_font_sizes.dart';
import 'package:flutterweatherapp/domian/entity/weather_entity.dart';
import 'package:flutterweatherapp/presentation/common_widgets/saved_cities_card.dart';
import 'package:flutterweatherapp/presentation/controller/connectivity/internate_connectivity_bloc.dart';
import 'package:flutterweatherapp/presentation/controller/local_database/user_city_controller/user_city_controller_bloc.dart';
import 'package:flutterweatherapp/presentation/controller/sync_data_controller/sync_database_bloc.dart';
import 'package:flutterweatherapp/routes/weather_routes.dart';
import 'package:lottie/lottie.dart';

class CitiesList extends StatelessWidget {
  final bool isCurrentCityNotFound;

  const CitiesList({super.key, required this.isCurrentCityNotFound});

  @override
  Widget build(BuildContext context) {
    final userCityBloc = BlocProvider.of<UserCityControllerBloc>(context);
    userCityBloc.add(const FetchSavedCitiesData());
    return UserCities(isCurrentCityNotFound: isCurrentCityNotFound);
  }
}

class UserCities extends StatefulWidget {
  final bool isCurrentCityNotFound;

  const UserCities({super.key, required this.isCurrentCityNotFound});

  @override
  State<UserCities> createState() => _UserCitiesState();
}

class _UserCitiesState extends State<UserCities> {
  TextEditingController saveNewCityTextController = TextEditingController();
  List<WeatherModel> cityNamesData = [];
  bool isSyncing = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    saveNewCityTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    getState(context);
    return BlocBuilder<InternateConnectivityBloc, InternateConnectivityState>(
      builder: (context, state) {
        if (state is ConnectedState) {
          return BlocListener<SyncDatabaseBloc, SyncDatabaseState>(
            listener: (context, state) {
              if (state is SyncSuccessfull) {
                isSyncing = true;
                for (int i = 0; i <= state.newModel.length; i++) {
                  AppUtils.saveUserCity(state.newModel[i], context);
                }
                cityNamesData = [];
                AppUtils.showToastMessage(
                    WeatherAppString.syncDone, Toast.LENGTH_SHORT);
              }
            },
            child: WillPopScope(
              onWillPop: () async {
                cityNamesData = [];
                if (widget.isCurrentCityNotFound) {
                  return false;
                } else {
                  return true;
                }
              },
              child: Scaffold(
                  resizeToAvoidBottomInset: true,
                  key: const ValueKey("user_city_widget"),
                  body: Container(
                    decoration: BoxDecoration(
                      gradient: WeatherAppColor.linearGradientBackground,
                    ),
                    child: mainUI(context),
                  )),
            ),
          );
        } else if (state is NotConnectedState) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Lottie.asset(WeatherAppResources.connectivityLottie),
            ],
          );
        }
        return Container();
      },
    );
  }

  Stack mainUI(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          bottom: 20,
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            title: Text(
              WeatherAppString.savedLocations,
              style: WeatherAppFonts.medium(fontWeight: FontWeight.w400)
                  .copyWith(
                      fontSize: WeatherAppFontSize.s18,
                      color: WeatherAppColor.whiteColor),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.sync,
                  color: WeatherAppColor.whiteColor,
                  size: 30,
                ),
                onPressed: () {
                  if (cityNamesData.isNotEmpty) {
                    final syncBloc = BlocProvider.of<SyncDatabaseBloc>(context);
                    syncBloc.add(SyncMyData(cityNamesData));
                  }
                },
              ),
            ],
          ),
        ),
        Padding(
          padding:
              EdgeInsets.only(top: 80.h, left: 2.w, right: 0.w, bottom: 73.h),
          child: Center(
            child:
                BlocConsumer<UserCityControllerBloc, UserCityControllerState>(
              //buildWhen: (previous, current) {

               // return previous is UserCityLoading && current is  UserCityLoaded;
             // },
            //  listenWhen: (previous, current) {
            //    return previous is UserCityLoading && current is  UserCityLoaded;
           //   },
              builder: (context, state) {
                if (state is UserCityLoading) {
                  return Center(child: AppUtils().loadingSpinner);
                }
                if (state is UserCityLoaded) {
                  if (isSyncing) {
                    final currentCityWeatherModel = state.usermodel.firstWhere(
                      (element) => element.isCurrentCity == true,
                      orElse: () => state.usermodel.first,
                    );

                    AppUtils.updateHomeScreenWidget(currentCityWeatherModel);
                  }
                  return ListView.builder(
                    itemCount: state.usermodel.length,
                    itemBuilder: (context, index) {
                      cityNamesData.add(state.usermodel[index]);
                      return Padding(
                        padding:
                            EdgeInsets.only(left: 12.w, right: 12.w, top: 15.h),
                        child: GestureDetector(
                          onTap: () {
                            print("From City loaded");
                            resetState();
                           // Navigator.pushAndRemoveUntil(
                              //  context, WeatherRoutes.homePageRoute,
                              //  arguments: [true, state.usermodel[index]]);

                            Navigator.pushReplacementNamed(context, WeatherRoutes.homePageRoute,
                                arguments: [true, state.usermodel[index]]);
                          },
                          child: SavedCitiesCard(
                            cityName: state.usermodel[index].name,
                            weatherCondition:
                                state.usermodel[index].weather[0].description,
                            humidity:
                                state.usermodel[index].main.humidity.toString(),
                            windSpeed:
                                state.usermodel[index].wind.speed.toString(),
                            statusImage: state.usermodel[index].weather[0].icon,
                            temprature:
                                state.usermodel[index].main.temp.toString(),
                            isHomeCity:
                                state.usermodel[index].isCurrentCity ?? false,
                          ),
                        ),
                        //),
                      );
                    },
                  );
                }


                return Text(state.toString());
              },
              listener: (context, listenerState) {
                if (listenerState is UserCitySaveSuccess) {
                  /* return ListView.builder(
                    itemCount: state.weatherModel.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding:
                            EdgeInsets.only(left: 12.w, right: 12.w, top: 15.h),
                        child: GestureDetector(
                          onTap: () {
                            print("From Save Success");
                            resetState();
                            Navigator.pushNamed(
                                context, WeatherRoutes.homePageRoute,
                                arguments: [true, state.weatherModel[index]]);
                          },
                          child: SavedCitiesCard(
                            cityName: state.weatherModel[index].name,
                            weatherCondition: state
                                .weatherModel[index].weather[0].description,
                            humidity: state.weatherModel[index].main.humidity
                                .toString(),
                            windSpeed:
                                state.weatherModel[index].wind.speed.toString(),
                            statusImage:
                                state.weatherModel[index].weather[0].icon,
                            temprature:
                                state.weatherModel[index].main.temp.toString(),
                            isHomeCity:
                                state.weatherModel[index].isCurrentCity ??
                                    false,
                          ),
                        ),
                        //),
                      );
                    },
                  );
                  */
                  final userCityBloc = BlocProvider.of<UserCityControllerBloc>(context);
                  userCityBloc.add(const FetchSavedCitiesData());
                }
             //   print("State is");
               // print(listenerState);
                // UserCitySaveSuccess

                ///UserCityLoaded([Instance of 'WeatherModel', Instance of 'WeatherModel'])
                if (listenerState is CityWeatherLoaded) {
                  saveNewCityTextController.clear();
                  WeatherModel newModel = listenerState.usermodel;
                  newModel.cityImageURL = listenerState.usermodel.cityImageURL;
                  newModel.isCurrentCity = false;
                  AppUtils.saveUserCity(newModel, context);
                  if(widget.isCurrentCityNotFound==true)
                    {
                      AppUtils.updateHomeScreenWidget(newModel);

                    }

                }
                if (listenerState is UserCityFetchingError) {
                  saveNewCityTextController.clear();
                  AppUtils.showToastMessage(
                      WeatherAppString.noWeatherInfo, Toast.LENGTH_SHORT);
                  final userCityBloc =
                      BlocProvider.of<UserCityControllerBloc>(context);
                  userCityBloc.add(const FetchSavedCitiesData());
                }
              },
            ),
          ),
        ),
        Positioned(
          bottom: 10.h,
          left: 10.w,
          right: 10.w,
          child: InkWell(
            onTap: () {
              _showSaveDialog(context);
            },
            child: Container(
              height: 50.h,
              decoration: BoxDecoration(
                  color: WeatherAppColor.cardB,
                  borderRadius: const BorderRadius.all(Radius.circular(24))),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_circle_outline,
                    size: 25,
                    color: WeatherAppColor.whiteColor,
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Text(
                    WeatherAppString.addNew,
                    style: WeatherAppFonts.medium(
                      fontWeight: FontWeight.w500,
                    ).copyWith(
                        color: WeatherAppColor.whiteColor,
                        fontSize: WeatherAppFontSize.s24),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showSaveDialog(BuildContext context) async {
    final result = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(WeatherAppString.saveCity),
          content: TextField(
            controller: saveNewCityTextController,
            decoration: InputDecoration(
              hintText: WeatherAppString.enterCity,
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                WeatherAppString.cancel,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(WeatherAppString.save),
              onPressed: () {
                String text = saveNewCityTextController.text;
                Navigator.of(context).pop(text);
              },
            ),
          ],
        );
      },
    );

    if (result != null) {
      if (mounted) {
        getCityWeather(result, context);
      }
    }
  }

  int counter = 0;

  void getCityWeather(String result, BuildContext context) {
    final userCityBloc = BlocProvider.of<UserCityControllerBloc>(context);
    userCityBloc.add(GetCityWeather(result));
  }

  void resetState() {
    final resetState = BlocProvider.of<UserCityControllerBloc>(context);
    resetState.add(const UserCityInitial());
  }
}

void getState(BuildContext context) {
  final resetState = BlocProvider.of<UserCityControllerBloc>(context);
  print("State is1$resetState");
  //'UserCityControllerBloc'

}
