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
import 'package:flutterweatherapp/presentation/screens/saved_cities/saved_cities_widget/main_widget.dart';
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
  void dispose() {
    saveNewCityTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InternateConnectivityBloc, InternateConnectivityState>(
      builder: (context, state) {
        if (state is ConnectedState) {
          return BlocListener<SyncDatabaseBloc, SyncDatabaseState>(
            listener: (context, state) {
              if (state is SyncSuccessfull) {
                isSyncing = true;
                int currentIndex = 0;

                for (int i = 0; i < state.newModel.length; i++) {
                  if (state.newModel[i].isCurrentCity == true) {
                    currentIndex = i;
                    AppUtils.updateHomeScreenWidget(state.newModel[currentIndex]);
                  }
                  else{
                    if (currentIndex == 0 && state.newModel.isNotEmpty) {
                      currentIndex = state.newModel.length - 1;
                      AppUtils.updateHomeScreenWidget(state.newModel[currentIndex]);

                    }
                  }

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
                  child: MainUIWidget(
                    cityNamesData: cityNamesData,
                    isSyncing: isSyncing,
                    saveNewCityTextController: saveNewCityTextController,
                    isCurrentCityNotFound: widget.isCurrentCityNotFound,
                  ),
                ),
              ),
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
}
