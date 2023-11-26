import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterweatherapp/presentation/controller/getCityImage/get_city_image_controller_bloc.dart';
import 'package:flutterweatherapp/presentation/controller/get_daily_forecast/get_daily_forecast_bloc.dart';
import 'package:flutterweatherapp/presentation/controller/get_user_city_controller/get_user_city_weather_controller_bloc.dart';
import 'package:flutterweatherapp/presentation/controller/get_user_saved_city_weather_controller/get_saved_cities_controller_bloc.dart';
import 'package:flutterweatherapp/presentation/screens/splash_screen/splash_screen.dart';
import 'package:flutterweatherapp/routes/weather_routes.dart';

import 'const/app_locator/service_locator.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  ServicesLocator().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        // Use builder only if you need to use library outside ScreenUtilInit context
        builder: (_, child) {
          return MultiBlocProvider(
            providers: [
              /// as soon as app started i need to get user current city data
              /// GetDailyForecastBloc
              ///
              BlocProvider(
                  create: (context) =>
                      GetDailyForecastBloc(sLocator())),
              BlocProvider(
                  create: (context) =>
                      GetUserCityWeatherControllerBloc(sLocator())),
              BlocProvider(
                  create: (context) =>
                      GetSavedCitiesControllerBloc(sLocator())),
              BlocProvider(
                  create: (context) =>
                      GetCityImageControllerBloc(sLocator())),
            ],
            child: MaterialApp(
              title: 'Flutter Demo',
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                useMaterial3: true,
              ),
              onGenerateRoute: RouteGenerator.getRoute,
              initialRoute: WeatherRoutes.splashRoute,
            ),
          );
        });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    print("Home page called");
    //BlocProvider<GetUserCityWeatherControllerBloc>(
    //  create: (context) => GetUserCityWeatherControllerBloc(sLocator())
    //    ..add(GetUserCityWeather()),
    // );
    final myBloc = BlocProvider.of<GetUserCityWeatherControllerBloc>(context);

    // Call a method on the bloc
    //myBloc.add(GetUserCityWeather());
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
