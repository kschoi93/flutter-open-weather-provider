// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:open_weather_provider/models/direct_geocoding.dart';

import '../exceptions/weather_exception.dart';
import '../models/custom_error.dart';
import '../models/weather.dart';
import '../services/weather_api_services.dart';

class WeatherRepository {
  final WeatherApiServices weatherApiServices;
  WeatherRepository({
    required this.weatherApiServices,
  });

  Future<Weather> fetchWeather(String city) async {
    try {
      final DirectGeocoding directGeocoding =
          await weatherApiServices.getDirectGeocoding(city);
      print('directGeocoding: $directGeocoding');

      final Weather tempWeather =
          await weatherApiServices.getWeather(directGeocoding);

      // print('tempWeather: $tempWeather');

      final Weather weather = tempWeather.copyWith(
          name: directGeocoding.name, country: directGeocoding.country);
      // print('weather: $weather');

      return weather;
    } on WeatherException catch (e) {
      throw CustomError(errMsg: e.message);
    } catch (e) {
      throw CustomError(errMsg: e.toString());
    }
  }
}
