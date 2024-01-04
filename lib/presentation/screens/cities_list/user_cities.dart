import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterweatherapp/const/app_color.dart';
import 'package:flutterweatherapp/const/app_locator/service_locator.dart';
import 'package:flutterweatherapp/const/app_strings.dart';
import 'package:flutterweatherapp/const/sharedPrefs/sharedprefsservice.dart';
import 'package:flutterweatherapp/const/utils.dart';
import 'package:flutterweatherapp/const/weather_app_fonts.dart';
import 'package:flutterweatherapp/const/weather_font_sizes.dart';
import 'package:flutterweatherapp/domian/entity/weather_entity.dart';
import 'package:flutterweatherapp/presentation/common_widgets/saved_cities_card.dart';
import 'package:flutterweatherapp/presentation/controller/get_user_city_controller/get_user_city_weather_controller_bloc.dart';
import 'package:flutterweatherapp/presentation/controller/local_database_database/user_city_controller/user_city_controller_bloc.dart';
import 'package:flutterweatherapp/routes/weather_routes.dart';

class CitiesList extends StatelessWidget {
  const CitiesList({super.key});

  @override
  Widget build(BuildContext context) {
    final userCityBloc = BlocProvider.of<UserCityControllerBloc>(context);
    userCityBloc.add(const FetchUserCity());
    return const UserCities();
  }
}

class UserCities extends StatefulWidget {
  const UserCities({Key? key}) : super(key: key);

  @override
  State<UserCities> createState() => _UserCitiesState();
}

class _UserCitiesState extends State<UserCities> {
  TextEditingController searchTextController = TextEditingController();

  /// save alert
  void _showSaveDialog(BuildContext context) async {
    final result = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        TextEditingController textEditingController = TextEditingController();

        return AlertDialog(
          title: const Text('Save New City'),
          content: TextField(
            controller: textEditingController,
            decoration: const InputDecoration(
              hintText: 'Enter City',
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                String text = textEditingController.text;
                Navigator.of(context).pop(text);
              },
            ),
          ],
        );
      },
    );

    if (result != null) {
      if(mounted)
        {
          getCityWeather(result, context);

        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GetUserCityWeatherControllerBloc,
        GetUserCityWeatherControllerState>(
        listenWhen: (previous, current) {
          return previous is UserCityWeatherLoading &&
              current is NewUserCityWeatherLoaded;
        },
      listener: (context, state) {

          print("State is State");
          print(state);

        if (state is NewUserCityWeatherLoaded) {
          WeatherModel newModel = state.cityWeatherInformation;
          newModel.cityImageURL = state.cityImageURL;
          newModel.isCurrentCity = false;
          AppUtils.saveCity(newModel, context);
        }
      },
      child: Scaffold(
          resizeToAvoidBottomInset: true,
          key: const ValueKey("user_city_widget"),
          body: Container(
            decoration: BoxDecoration(
              gradient: WeatherAppColor.linearGradientBackground,
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: AppBar(
                    backgroundColor: Colors.transparent,
                    title: Text(
                            WeatherAppString.savedLocations,
                            style: WeatherAppFonts.medium(
                                    fontWeight: FontWeight.w400)
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

                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: 80.h, left: 2.w, right: 0.w, bottom: 53.h),
                  child: Center(
                    child: BlocConsumer<UserCityControllerBloc,
                        UserCityControllerState>(
                      listener: (context, state) {
                        print("Consumer status12");
                        print(state);
                        // TODO: implement listener
                        if (state is UserCitySaveSuccessfull) {}
                        if (state is UserCityDeleteSuccessfull) {}
                        if (state is UserCityUpdateSuccessfull) {}
                        if (state is UserCityAction) {}
                        if (state is UserActionLoading) {}
                      },
                      builder: (context, state) {
                        if (state is UserCitySaveSuccessfull) {
                          return ListView.builder(
                            itemCount: state.weatherModel.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.only(
                                    left: 12.w, right: 12.w, top: 15.h),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, WeatherRoutes.homePageRoute,
                                        arguments: [true,state.weatherModel[index]]);
                                  },
                                  child: SavedCitiesCard(
                                    cityName: state.weatherModel[index].name,
                                    weatherCondition: state.weatherModel[index]
                                        .weather[0].description,
                                    humidity: state
                                        .weatherModel[index].main.humidity
                                        .toString(),
                                    windSpeed: state
                                        .weatherModel[index].wind.speed
                                        .toString(),
                                    statusImage: state
                                        .weatherModel[index].weather[0].icon,
                                    temprature: state
                                        .weatherModel[index].main.temp
                                        .toString(),
                                    isHomeCity: state.weatherModel[index].isCurrentCity ??false,

                                  ),
                                ),
                                //),
                              );
                            },
                          );
                        }
                        if (state is SearchUserCityLoaded) {
                          return Padding(
                            padding: EdgeInsets.only(
                                left: 12.w, right: 12.w, top: 15.h),
                            child: SizedBox(
                              height: 150.h,
                              child: GestureDetector(
                                onTap: () {
                                  //Navigator.pushNamed(
                                      //context, WeatherRoutes.homePageRoute,
                                     // arguments: [state.usermodel]);
                                  Navigator.pushNamed(
                                      context, WeatherRoutes.homePageRoute,
                                      arguments: [true,state.usermodel]);
                                },
                                child: SavedCitiesCard(
                                  cityName: state.usermodel.name,
                                  weatherCondition:
                                      state.usermodel.weather[0].description,
                                  humidity:
                                      state.usermodel.main.humidity.toString(),
                                  windSpeed:
                                      state.usermodel.wind.speed.toString(),
                                  statusImage: state.usermodel.weather[0].icon,
                                  temprature:
                                      state.usermodel.main.temp.toString(),
                                  isHomeCity: state.usermodel.isCurrentCity ??false,
                                ),
                              ),
                            ),
                            //),
                          );
                        }
                        if (state is UserCityAction) {
                          return Center(child: AppUtils().loadingSpinner);
                        }
                        if (state is UserActionLoading) {
                          return Center(child: AppUtils().loadingSpinner);
                        }
                        if (state is UserCityLoaded) {
                          return ListView.builder(
                            itemCount: state.usermodel.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.only(
                                    left: 12.w, right: 12.w, top: 15.h),
                                child: GestureDetector(
                                  onTap: () {
                                    //Navigator.pushNamed(
                                    //    context, WeatherRoutes.homePageRoute,
                                       // arguments: [state.usermodel[index]]);
                                    Navigator.pushNamed(
                                        context, WeatherRoutes.homePageRoute,
                                        arguments: [true,state.usermodel[index]]);
                                  },
                                  child: SavedCitiesCard(
                                    cityName: state.usermodel[index].name,
                                    weatherCondition: state.usermodel[index]
                                        .weather[0].description,
                                    humidity: state
                                        .usermodel[index].main.humidity
                                        .toString(),
                                    windSpeed: state.usermodel[index].wind.speed
                                        .toString(),
                                    statusImage:
                                        state.usermodel[index].weather[0].icon,
                                    temprature: state.usermodel[index].main.temp
                                        .toString(),
                                    isHomeCity: state.usermodel[index].isCurrentCity ??false,
                                  ),
                                ),
                                //),
                              );
                            },
                          );
                        }
                        return Container();
                      },
                    ),
                  ),
                ),

                /// add btn
                Positioned(
                  bottom: 10.h,
                  left: 10.w,
                  right: 10.w,
                  child: InkWell(
                    onTap: () {
                      _showSaveDialog(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: WeatherAppColor.cardB,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(24))),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_circle_outline,
                            size: 24,
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
            ),
          )),
    );
  }

  void getCityWeather(String result, BuildContext context) {
    final userCityBloc =
        BlocProvider.of<GetUserCityWeatherControllerBloc>(context);
    userCityBloc.add(GetSavedCityWeather(result));
  }

}

