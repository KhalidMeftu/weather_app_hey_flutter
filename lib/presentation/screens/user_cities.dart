import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterweatherapp/const/app_color.dart';
import 'package:flutterweatherapp/const/app_strings.dart';
import 'package:flutterweatherapp/const/common_widgets/saved_cities_card.dart';
import 'package:flutterweatherapp/const/weather_app_fonts.dart';
import 'package:flutterweatherapp/const/weather_font_sizes.dart';
import 'package:flutterweatherapp/domian/entity/weather_entity.dart';
import 'package:flutterweatherapp/presentation/controller/get_user_city_controller/get_user_city_weather_controller_bloc.dart';
import 'package:flutterweatherapp/presentation/controller/local_database_database/user_city_controller/user_city_controller_bloc.dart';
import 'package:flutterweatherapp/routes/weather_routes.dart';

class UserCities extends StatefulWidget {
  const UserCities({Key? key}) : super(key: key);

  @override
  State<UserCities> createState() => _UserCitiesState();
}

class _UserCitiesState extends State<UserCities> {
  bool _isSearching = false;
  TextEditingController searchTextController= TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    final userCityBloc = BlocProvider.of<UserCityControllerBloc>(context);
    userCityBloc.add(const FetchUserCity());
    super.initState();
  }

  /// save alert
  void _showSaveDialog(BuildContext context) async {
    final result = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        TextEditingController _textEditingController = TextEditingController();

        return AlertDialog(
          title: const Text('Save New City'),
          content: TextField(
            controller: _textEditingController,
            decoration: const InputDecoration(
              hintText: 'Enter City',
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                String text = _textEditingController.text;
                Navigator.of(context).pop(text);
              },
            ),
          ],
        );
      },
    );

    if (result != null) {
      saveToDatabase(result, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GetUserCityWeatherControllerBloc,
        GetUserCityWeatherControllerState>(
      listener: (context, state) {
        // TODO: implement listener
        if (state is UserCityWeatherLoaded) {
          saveCity(state.cityWeatherInformation, context);
        }
      },
      child: Scaffold(
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
                leading: _isSearching
                    ? IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: WeatherAppColor.whiteColor,
                        ),
                        onPressed: () {
                          setState(() {
                            _isSearching = false;
                          });
                        },
                      )
                    : Container(),
                title: _isSearching
                    ? TextField(
                  controller: searchTextController,
                  autofocus: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: WeatherAppString.search,
                    hintStyle: const TextStyle(color: Colors.white70),
                  ),
                  onSubmitted: (String searchText) {
                    final searchUserCityBloc = BlocProvider.of<UserCityControllerBloc>(context);
                    searchUserCityBloc.add(SearchUserCity(searchText));
                    setState(() {
                      _isSearching = false;
                    });
                  },
                )

                    : Text(
                        WeatherAppString.savedLocations,
                        style:
                            WeatherAppFonts.medium(fontWeight: FontWeight.w400)
                                .copyWith(
                                    fontSize: WeatherAppFontSize.s18,
                                    color: WeatherAppColor.whiteColor),
                      ),
                actions: [
                  IconButton(
                    icon: Icon(
                      Icons.search,
                      color: WeatherAppColor.whiteColor,
                      size: 30,
                    ),
                    onPressed: () {
                      setState(() {
                        _isSearching = true;
                      });

                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 80.h, left: 2.w, right: 0.w, bottom: 53.h),
              child: Center(
                child: BlocConsumer<UserCityControllerBloc,
                    UserCityControllerState>(
                  listener: (context, state) {
                    // TODO: implement listener
                    if (state is UserCityInsertSuccessfull) {

                    }
                    if (state is UserCityDeleteSuccessfull) {}
                    if (state is UserCityUpdateSuccessfull) {}
                    if (state is UserCityAction) {}
                    if (state is UserCityExecute) {}
                  },
                  builder: (context, state) {
                    if (state is UserCityInsertSuccessfull) {
                      return ListView.builder(
                        itemCount: state.weatherModel.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(
                                left: 12.w, right: 12.w, top: 15.h),
                            child: SavedCitiesCard(
                              cityName: state.weatherModel[index].name,
                              weatherCondition:
                              state.weatherModel[index].weather[0].description,
                              humidity: state.weatherModel[index].main.humidity
                                  .toString(),
                              windSpeed:
                              state.weatherModel[index].wind.speed.toString(),
                              statusImage:
                              state.weatherModel[index].weather[0].icon,
                              temprature:
                              state.weatherModel[index].main.temp.toString(),
                            ),
                            //),
                          );
                        },
                      );

                    }
                    if (state is UserCityDeleteSuccessfull) {}
                    if (state is UserCityUpdateSuccessfull) {}
                    if (state is SearchUserCityLoaded) {
                      return Padding(
                        padding: EdgeInsets.only(
                            left: 12.w, right: 12.w, top: 15.h),
                        child: SizedBox(
                          height: 150.h,
                          child: GestureDetector(
                            onTap: (){
                              Navigator.pushNamed(
                                  context, WeatherRoutes.homePageRoute,
                                  arguments: [state.usermodel.name, "",state.usermodel]);
                            },
                            child: SavedCitiesCard(
                              cityName: state.usermodel.name,
                              weatherCondition:
                              state.usermodel.weather[0].description,
                              humidity: state.usermodel.main.humidity
                                  .toString(),
                              windSpeed:
                              state.usermodel.wind.speed.toString(),
                              statusImage:
                              state.usermodel.weather[0].icon,
                              temprature:
                              state.usermodel.main.temp.toString(),
                            ),
                          ),
                        ),
                        //),
                      );


                    }
                    //UserCityAction

                    if (state is UserCityAction) {
                      return Center(child: Text("City not saved"));
                    }
                    if (state is UserCityExecute) {}
                    if (state is UserCityLoaded) {
                      return ListView.builder(
                        itemCount: state.usermodel.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(
                                left: 12.w, right: 12.w, top: 15.h),
                            child: GestureDetector(
                              onTap: (){
                                Navigator.pushNamed(
                                    context, WeatherRoutes.homePageRoute,
                                    arguments: [state.usermodel[index].name, "",state.usermodel[index]]);
                              },
                              child: SavedCitiesCard(
                                cityName: state.usermodel[index].name,
                                weatherCondition:
                                    state.usermodel[index].weather[0].description,
                                humidity: state.usermodel[index].main.humidity
                                    .toString(),
                                windSpeed:
                                    state.usermodel[index].wind.speed.toString(),
                                statusImage:
                                    state.usermodel[index].weather[0].icon,
                                temprature:
                                    state.usermodel[index].main.temp.toString(),
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

  void saveToDatabase(String result, BuildContext context) {
    final userCityBloc =
        BlocProvider.of<GetUserCityWeatherControllerBloc>(context);
    userCityBloc.add(GetUserCityWeather(result));
  }

  void saveCity(WeatherModel cityWeatherInformation, BuildContext context) {
    BlocProvider.of<UserCityControllerBloc>(context)
        .add(InsertUserCity(cityWeatherInformation));
  }
}
