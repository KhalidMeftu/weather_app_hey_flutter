import 'package:flutter/material.dart';
class WeatherHomePage extends StatelessWidget {
  final String cityName;
  final String imageUrl;
  const WeatherHomePage({Key? key, required this.cityName, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
        Scaffold(
          body:Stack(
            children: [
              Positioned.fill(
                child:Image.network("https://d13k13wj6adfdf.cloudfront.net/urban_areas/nairobi-8e8453c4de.jpg", fit: BoxFit.cover,) ,
              ),
              Column(
                children: [
                  const Text("Test title"),
                  Text(cityName),
                  Text((imageUrl.isEmpty).toString()),

                  Container(),
                ],
              ),
            ],
          )
        );



  }
}
