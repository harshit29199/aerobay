import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';


class LogicProvider with ChangeNotifier {
  String schoolName = '';

  String get data => schoolName;

  void setData(String value) {
    schoolName = value;
    notifyListeners();
  }


  Map<String, dynamic>? _weatherData;

  Map<String, dynamic>? get weatherData => _weatherData;

  List<String> windL=[];
  List<String> VisiL=[];
  List<String> UVL=[];

  void updatePreviousDaysData(List<String> wind, List<String> visi, List<String> uv) {
    windL = wind;
    VisiL = visi;
    UVL = uv;
    notifyListeners();
  }

  String temp = '';
  String humidity = '';
  String weatherInfo = '';
  String aqi = '';
  String dust = '';
  String smoke = '';
  String co2 = '';
  String co = '';
  String alcohol = '';
  String ammonia = '';
  String benzene = '';
  String toluene = '';
  String methane = '';
  String wind = '';
  String hum = '';
  String rainValue = '';
  String rainMax = '';
  String rainAvg = '';
  String rainTotal = '';
  String visibility = '';
  String atmDirection = '';
  String atmLat = '';
  String atmLong = '';
  String atmValue = '';
  String uv = '';


  // Update weather data and notify listeners
  void updateWeatherData(Map<String, dynamic> data) {
    // _weatherData = data;
    // temp= weatherData!['temp'];
    // weather = Weather.fromJson(data);

    if (data['weather'] != null) {
      temp = data['weather']['temp'] ?? '';
      humidity = data['weather']['humidity'] ?? '';
      weatherInfo = data['weather']['info'] ?? '';
    }

    if (data['aqi'] != null) {
      aqi = data['aqi']['aqi'] ?? '';
      dust = data['aqi']['dust'] ?? '';
      smoke = data['aqi']['smoke'] ?? '';
      co2 = data['aqi']['co2'] ?? '';
      co = data['aqi']['co'] ?? '';
      alcohol = data['aqi']['alcohol'] ?? '';
      ammonia = data['aqi']['ammonia'] ?? '';
      benzene = data['aqi']['benzene'] ?? '';
      toluene = data['aqi']['toluene'] ?? '';
      methane = data['aqi']['methane'] ?? '';
    }

    wind = data['wind'] ?? '';
    hum = data['hum'] ?? '';

    if (data['rain'] != null) {
      rainValue = data['rain']['value'] ?? '';
      rainMax = data['rain']['max'] ?? '';
      rainAvg = data['rain']['avg'] ?? '';
      rainTotal = data['rain']['total'] ?? '';
    }

    visibility = data['visibility'] ?? '';

    if (data['atm'] != null) {
      atmDirection = data['atm']['direction'] ?? '';
      atmLat = data['atm']['lat'] ?? '';
      atmLong = data['atm']['long'] ?? '';
      atmValue = data['atm']['value'] ?? '';
    }

    uv = data['uv'] ?? '';
    notifyListeners();
  }


  void updateWeatherData1(Map<String, dynamic> data) {
    if (data['weather'] != null) {
      final weatherData = jsonDecode(data['weather']); // Parse the JSON string
      temp = weatherData['temp'] ?? '';
      humidity = weatherData['humidity'] ?? '';
      weatherInfo = weatherData['info'] ?? '';
    }

    if (data['aqi_json'] != null) {
      final aqiData = jsonDecode(data['aqi_json']); // Parse the JSON string
      aqi = aqiData['aqi'] ?? '';
      dust = aqiData['dust'] ?? '';
      smoke = aqiData['smoke'] ?? '';
      co2 = aqiData['co2'] ?? '';
      co = aqiData['co'] ?? '';
      alcohol = aqiData['alcohol'] ?? '';
      ammonia = aqiData['ammonia'] ?? '';
      benzene = aqiData['benzene'] ?? '';
      toluene = aqiData['toluene'] ?? '';
      methane = aqiData['methane'] ?? '';
    }

    wind = data['wind'] ?? '';
    hum = data['humidity'] ?? '';

    if (data['rain_json'] != null) {
      final rainData = jsonDecode(data['rain_json']); // Parse the JSON string
      rainValue = rainData['value'] ?? '';
      rainMax = rainData['max'] ?? '';
      rainAvg = rainData['avg'] ?? '';
      rainTotal = rainData['total'] ?? '';
    }

    visibility = data['visibility'] ?? '';

    if (data['atm_json'] != null) {
      final atmData = jsonDecode(data['atm_json']); // Parse the JSON string
      atmDirection = atmData['direction'] ?? '';
      atmLat = atmData['lat'] ?? '';
      atmLong = atmData['long'] ?? '';
      atmValue = atmData['value'] ?? '';
    }

    uv = data['uv'] ?? '';
    notifyListeners();
  }

}


// To retrieve school name
// String schoolName = context.watch<LogicProvider>().schoolName;

// To update school name
// context.read<LogicProvider>().setSchoolName('New School Name');

// Access weather information
// print('Temperature: ${weatherData.weather.temp}°C');
// print('Humidity: ${weatherData.weather.humidity}%');
// print('Condition: ${weatherData.weather.info}');
//
// // Access AQI information
// print('AQI: ${weatherData.aqi.aqi}');
// print('Dust: ${weatherData.aqi.dust}');
// print('Smoke: ${weatherData.aqi.smoke}');
// print('CO2: ${weatherData.aqi.co2}');
// print('CO: ${weatherData.aqi.co}');
// print('Alcohol: ${weatherData.aqi.alcohol}');
// print('Ammonia: ${weatherData.aqi.ammonia}');
// print('Benzene: ${weatherData.aqi.benzene}');
// print('Toluene: ${weatherData.aqi.toluene}');
// print('Methane: ${weatherData.aqi.methane}');
//
// // Access other values
// print('Wind Speed: ${weatherData.wind}');
// print('Humidity: ${weatherData.hum}');
//
// // Access rain information
// print('Rain Value: ${weatherData.rain.value}');
// print('Max Rain: ${weatherData.rain.max}');
// print('Avg Rain: ${weatherData.rain.avg}');
// print('Total Rain: ${weatherData.rain.total}');
//
// // Access visibility
// print('Visibility: ${weatherData.visibility}');
//
// // Access atmospheric data
// print('Direction: ${weatherData.atm.direction}');
// print('Latitude: ${weatherData.atm.lat}');
// print('Longitude: ${weatherData.atm.long}');
// print('Atmospheric Pressure: ${weatherData.atm.value}');
//
// // Access UV index
// print('UV Index: ${weatherData.uv}');
