import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterweatherapp/const/app_color.dart';
import 'package:flutterweatherapp/presentation/controller/local_database_database/user_city_controller/user_city_controller_bloc.dart';

class UserCities extends StatelessWidget {
  const UserCities({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //FetchUserCity
    return Scaffold(

        body: Container(
          decoration: BoxDecoration(
            gradient: WeatherAppColor.linearGradientBackground,
          ),
          child: Center(
            child: BlocConsumer<UserCityControllerBloc,UserCityControllerState>(
              listener: (context, state) {
                // TODO: implement listener
              },
              builder: (context, state) {
                return Text("HI");
              },
            ),
          ),
        )
    );
  }
}
