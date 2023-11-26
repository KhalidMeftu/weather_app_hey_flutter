import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterweatherapp/const/app_color.dart';
import 'package:flutterweatherapp/presentation/controller/local_database_database/user_city_controller/user_city_controller_bloc.dart';

class UserCities extends StatelessWidget {
  const UserCities({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //FetchUserCity
    final userCityBloc =
    BlocProvider.of<UserCityControllerBloc>(context);
    userCityBloc.add(const FetchUserCity());
    return Scaffold(

        body: Container(
          decoration: BoxDecoration(
            gradient: WeatherAppColor.linearGradientBackground,
          ),
          child: Center(
            child: BlocConsumer<UserCityControllerBloc,UserCityControllerState>(
              listener: (context, state) {
                // TODO: implement listener
                if(state is UserCityLoaded)
                  {
                    print("User city Loaded");
                    print(state.usermodel[0].name);
                    print(state.usermodel[0].clouds);
                    print(state.usermodel[0].updatedAt);


                  }
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
